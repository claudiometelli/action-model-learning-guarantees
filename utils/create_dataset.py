from random import shuffle
from csv import writer as csv_writer
from json import dumps as json_dumps
from itertools import product, permutations
from typing import List, Set, Tuple

from unified_planning.io import PDDLReader
from unified_planning.plans.plan import ActionInstance
from unified_planning.shortcuts import *

get_environment().credits_stream = None

DOMAIN_NAME: str = 'grocery'
PROBLEM_INDEX: str = '00'

def get_all_possible_grounded_actions(problem: Problem) -> Dict[Action, List[Tuple[Object]]]:
    """
    Generates all possible grounded actions for a given UP problem,
    respecting type constraints and ensuring parameters are unique.

    Args:
        problem: The unified_planning.model.Problem object.

    Returns:
        A dictionary mapping each symbolic Action to a list
        of concrete grounding tuples (Objects) that satisfy the constraints.
    """
    result: Dict[Action, List[Tuple[Object]]] = {}

    for action in problem.actions:
        objects: List[List[Object]] = []
        
        # Determine available objects for each parameter
        for parameter in action.parameters:
            required_type = parameter.type
            # Filter all objects in the problem based on type compatibility
            available_objects = [
                obj for obj in problem.all_objects if obj.type.is_compatible(required_type)
            ]
            # If no objects are available for a required type, this action cannot be grounded
            if not available_objects:
                objects = []
                break

            objects.append(available_objects)
        
        result[action] = []
        if not objects:
            continue
        
        # Generates all possible combinations using cartesian product
        for grounding_tuple in list(product(*objects)):
            # Consider grounding tuple only if all objects in the tuple are unique
            # For example action stack(x, x) is not counted
            if len(set(grounding_tuple)) == len(grounding_tuple):
                result[action].append(tuple(grounding_tuple))

    return result

def get_non_required_fluents(problem: Problem, action: InstantaneousAction) -> Set[Fluent]:
    """
    Identifies symbolic fluents in the problem that are not action's preconditions.
    
    NOTE: This implementation assumes preconditions are:
    - a single FNode with a single expression,
    - a single FNode with one AND expression.
    It does not handle expressions like 'not', 'or', or nested expressions.
    
    Args:
        problem: The planning problem containing all fluents.
        action: The InstantaneousAction to analyze.

    Returns:
        A set of Fluent objects that are not required for the action.
    """
    # If the action has no preconditions defined return all possible fluents
    all_fluents: Set[Fluent] = set(problem.fluents)
    if len(action.preconditions) == 0:
        return all_fluents
    
    # Fluents required by the action
    required_fluents: Set[Fluent] = set()
    # Main precondition expression
    precondition_expression: FNode = action.preconditions[0]
    # Check the type of precondition among the supported ones:
    # [single expression, AND]
    if precondition_expression.is_and():    
        for argument in precondition_expression.args:
            required_fluents.add(argument.fluent())
    else:
        required_fluents.add(precondition_expression.fluent())

    non_required_fluents: Set[Fluent] = all_fluents - required_fluents
    return non_required_fluents


def ground_fluent_with_action_parameters(fluent: Fluent, action_parameters: List[Parameter]) -> List[Tuple[Parameter]]:
    """
    Generates all valid combinations of action's parameters for the fluent.

    It ensures:
    1. The number of parameters matches the fluent's signature length.
    2. Type compatibility is respected for each parameter position.
    3. All generated combinations are unique permutations of the action parameters.

    Args:
        fluent: The symbolic Fluent.
        action_parameters: List of symbolic parameters of the action.

    Returns:
        A list of tuples, where each tuple contains a valid tuple of action parameters
        that can be used to ground the fluent symbolically.
    """
    result: List[Tuple[Parameter]] = []
    # If fluent has more parameters that the action, fluent will not be grounded
    if len(fluent._signature) > len(action_parameters):
        return result
    
    # Check Type Compatibility for each parameter in the permutation
    for grounding_tuple in permutations(action_parameters, len(fluent._signature)):
        compute_tuple = True

        for i, obj in enumerate(grounding_tuple):
            required_type = fluent._signature[i].type
            if not required_type.is_compatible(obj.type):
                compute_tuple = False
                break

        if compute_tuple:
            result.append(grounding_tuple)

    return result

def is_empty_preconds(precond: Dict[Action, Dict[Fluent, List[Tuple[Parameter]]]]) -> bool:
    """
    Checks if the structured dictionary of actions associated with non-required symbolic grounded fluents is empty.

    Args:
        precond: A nested dictionary containing non-required symbolic grounded fluents associated to an action.

    Returns:
        True if all lists of symbolic groundings in the structure are empty, False otherwise.
    """
    for fluents_dict in precond.values():
        for groundings in fluents_dict.values():
            if len(groundings) != 0:
                return False
    return True

def symbolize_state_fluents(
        action: Action,
        grounding_tuple: Tuple[Object],
        state: State,
        problem_fluents: Set[Fluent]
    ) -> Dict[Fluent, List[Tuple[Parameter]]]:
    """
    Identifies the symbolic representations of all fluents in the state
    and whose concrete objects are fully covered by the action's grounding tuple.
    
    Args:
        action: The Action being analyzed.
        grounding_tuple: The concrete objects used to ground the action.
        state: The current State whose values are being inspected.
        problem_fluents: The set of all symbolic Fluents defined in the domain.

    Returns:
        A dictionary mapping the symbolic Fluent to a list of symbolic groundings.
    """
    # Map each concrete object to the corresponding symbolic parameter
    substitution_map: Dict[Object, Parameter] = {
        obj: param for obj, param in zip(grounding_tuple, action.parameters)
    }
    # Dictionary with all valid combinations of action's parameters for each fluent
    possible_fluents: Dict[Fluent, List[Tuple[Parameter]]] = {}
    result: Dict[Fluent, List[Tuple[Parameter]]] = {}

    for fluent in problem_fluents:
        # store permutations of the action's parameters that can form this fluent
        possible_fluent_params = ground_fluent_with_action_parameters(fluent, action.parameters)
        if len(possible_fluent_params) > 0:
            possible_fluents[fluent] = possible_fluent_params

    # Filter symbolic groundings using state's value
    for fluent_exp in state._values:
        # Check if the base fluent is stored in theoretically possible groundings with action's parameters
        if not possible_fluents.get(fluent_exp.fluent()):
            continue
        # Check if the grounded fluent itself doesn't use duplicate objects
        if len(set(fluent_exp.args)) != len(fluent_exp.args):
            continue
        # Check if all concrete arguments of the grounded fluent in the state are part of action's grounding tuple
        every_arg_in_substitution_map = True
        for fluent_arg in fluent_exp.args:
            if fluent_arg.object() not in substitution_map.keys():
                every_arg_in_substitution_map = False
                break
        if not every_arg_in_substitution_map:
            continue
        
        # It is possible to map the concrete objects with respective symbolic parameters.
        grounding = tuple([substitution_map[fluent_arg.object()] for fluent_arg in fluent_exp.args])
        # Check if the translated symbolic grounding is a valid combination in possible fluents
        if grounding in possible_fluents[fluent_exp.fluent()]:
            if not result.get(fluent_exp.fluent()):
                result[fluent_exp.fluent()] = []
            result[fluent_exp.fluent()].append(grounding)
    
    return result

def get_negative_examples(
    simulator: SequentialSimulator,
    current_state: State,
    possible_grounded_actions: Dict[Action, List[Tuple[Object]]],
    n_examples:int = 2 
    ) -> List[Tuple[State, Action, Tuple[Object], bool, State]]:
    """
    Collects a selected number (n_examples) of negative examples for the given state

    Args:
        simulator: The UP SequentialSimulator for checking applicability
        current_state: The State from which the action is attempted
        possible_grounded_actions: Dictionary mapping symbolic Actions to a list of all their possible concrete groundings
        n_examples: The desired number of unique negative examples to collect.

    Returns:
        A list of tuples: (Current State, Action, Grounding Tuple, Is_Applicable=False, Next State=None).
    """
    result: List[Tuple[State, Action, Tuple[Object], bool, State]] = []
    # Flatten the grounded actions into a list of tuples for random selection
    all_groundings: List[Tuple[Action, Tuple[Object]]] = []
    for action, groundings in possible_grounded_actions.items():
        for grounding in groundings:
            all_groundings.append((action, grounding))
    # Shuffle the list to randomize the search order
    shuffle(all_groundings)

    for random_action, random_grounding in all_groundings:
        
        # Check if collected examples are enough
        if len(result) >= n_examples:
            break
        
        instantiated_action = ActionInstance(random_action, random_grounding)
        possible_next_state = simulator.apply(current_state, instantiated_action)
        if possible_next_state is None:
            negative_example: Tuple[State, Action, Tuple[Object], bool, State] = (
                current_state,
                random_action,
                random_grounding,
                False,
                None
            )
            result.append(negative_example)
    
    return result

def write_dataset(
    dataset: List[Tuple[State, Action, Tuple[Object], bool, State]],
    output_path: str,
    csv_headers: Tuple[str, str, str, str, str] = ('state', 'action', 'action_parameters', 'result', 'next_state')
    ):
    """
    Writes the collected dataset of tuples to a CSV file,
    serializing State objects into JSON strings.

    Args:
        dataset: The list of collected transitions.
        output_path: The filesystem path where the CSV file should be saved.
        csv_headers: A tuple defining the column headers for the CSV file.
    """
    with open(output_path, 'w', newline='') as csvfile:
        writer = csv_writer(csvfile, delimiter=';')
        writer.writerow(csv_headers)
        
        for state, action, params, result, next in dataset:
            
            state_s = ''
            state_dict = {}
            for fluent, value in state._values.items():
                state_s += str(fluent) + ',' + str(value)
                state_dict[str(fluent)] = str(value)
            state_str = json_dumps(state_dict)
            action_name = action.name
            params_str = json_dumps([str(p) for p in params])
            result_str = 'True' if result else 'False'
            next_s = ''
            next_dict = {}
            if next is None:
                next_str = 'None'
            else:
                for fact, value in next._values.items():
                    next_s += str(fact) + ',' + str(value)
                    next_dict[str(fact)] = str(value)
                next_str = json_dumps(next_dict)
            
            row = [state_str, action_name, params_str, result_str, next_str]
            writer.writerow(row)


def main():
    # Define paths for the PDDL domain, problem file and dataset output
    domain_path: str = f'domains/{DOMAIN_NAME}/domain.pddl'
    problem_path: str = f'domains/{DOMAIN_NAME}/problem_{PROBLEM_INDEX}.pddl'
    output_filename: str = f'domains/{DOMAIN_NAME}/dataset_{PROBLEM_INDEX}.csv'

    # Load the PDDL problem using Unified Planning's PDDLReader
    reader: PDDLReader = PDDLReader()
    problem: Problem = reader.parse_problem(domain_path, problem_path)

    # List to store the collected examples in the dataset
    dataset: List[Tuple[State, Action, Tuple[Object], bool, State]] = []

    with SequentialSimulator(problem) as simulator:
        # Initial state
        current_state: State = simulator.get_initial_state()
        # Pre-calculate all possible grounded actions in the problem
        grounded_actions: Dict[Action, List[Tuple[Object]]] = get_all_possible_grounded_actions(problem)
        # Variable which stores the all symbolic non-required fluents with all possible combination of symbolic parameters
        useful_preconds: Dict[Action, Dict[Fluent, List[Tuple[Parameter]]]] = {}

        for action in problem.actions:
            # Identify fluents not explicitly in the action's preconditions
            non_required_fluents = get_non_required_fluents(problem, action)
            useful_preconds[action] = {}
            for non_required_fluent in non_required_fluents:
                useful_preconds[action][non_required_fluent] = []
                for grounding in ground_fluent_with_action_parameters(non_required_fluent, action.parameters):
                    useful_preconds[action][non_required_fluent].append(grounding)

        # --- Main Heuristic Loop ---
        # The loop continues until all non required fluents are covered or the goal state is reached.
        while not is_empty_preconds(useful_preconds) and not simulator.is_goal(current_state):
            # Dictionary to store the heuristic score for each possible action with grounded parameters
            # Score for each possibility is initially set to 0
            action_grounding_count: Dict[Tuple[Action, Tuple[Object]], int] = {}
            for action, groundings in grounded_actions.items():
                for grounding in groundings:
                    action_grounding_count[(action, grounding)] = 0

            # Heuristic evaluation assigning score for each possible action with grounded parameters
            for possible_action, possible_groundings in grounded_actions.items():
                for possible_grounding in possible_groundings:
                    # Simulate the action's effect and get next state if the action is applicable, otherwise skip
                    instantiated_action = ActionInstance(possible_action, possible_grounding)
                    possible_next_state = simulator.apply(current_state, instantiated_action)
                    if possible_next_state is None:
                        continue
                    # Find all symbolic fluents in the next state involved with the action's grounded objects
                    symbolic_fluents = symbolize_state_fluents(
                        possible_action,
                        possible_grounding,
                        possible_next_state,
                        problem.fluents
                    )
                    # Check how many useful preconditions are covered by this simulated state
                    useful_predicates = 0
                    for fluent, symbolic_groundings in symbolic_fluents.items():
                        for g in symbolic_groundings:
                            if useful_preconds[possible_action].get(fluent) and g in useful_preconds[possible_action].get(fluent):
                                useful_predicates += 1
                    
                    action_grounding_count[(possible_action, possible_grounding)] = useful_predicates

            # Action selection (Max Score or Fallback)
            best_action, best_grounding = None, None
            best_value = max(action_grounding_count.values())
            if best_value == 0:
                # Fallback: if no action contributes to reduction of non required precondition,
                # get next action through a planner
                next_action = None
                new_problem = problem.clone()
                # Initial state is set as current state
                for fluent_exp, value in current_state._values.items():
                    if value is not None:
                        new_problem.set_initial_value(fluent_exp, value)
                # Run the planner to get the next step towards the goal
                with OneshotPlanner(name='pyperplan') as planner:
                    result = planner.solve(new_problem)
                if result is not None and result.plan is not None:
                    next_action = result.plan.actions[0]
                # Extract the action and grounding from the ActionInstance
                best_action = next_action.action
                best_grounding = tuple([param.object() for param in next_action.actual_parameters])
            else:
                # Execution guided by heuristic, selecting action with higher number of non required fluents
                for action, grounding in action_grounding_count:
                    if action_grounding_count[(action, grounding)] == best_value:
                        best_action, best_grounding = action, grounding
            # State update with selected action
            best_instantiated_action = ActionInstance(best_action, best_grounding)
            next_state = simulator.apply(current_state, best_instantiated_action)
            next_symbolic_fluents = symbolize_state_fluents(
                best_action,
                best_grounding,
                next_state,
                problem.fluents
            )
            # Remove the covered non required fluents from useful preconditions
            for fluent, symbolic_groundings in next_symbolic_fluents.items():
                for g in symbolic_groundings:
                    if useful_preconds[best_action].get(fluent) and g in useful_preconds[best_action].get(fluent):
                        useful_preconds[best_action][fluent].remove(g)
            # Since UP library save new state as delta state (difference between current state and previous state)
            # Add all available fluents to the next state
            for fluent_exp, value in current_state._values.items():
                if fluent_exp not in next_state._values:
                    next_state._values[fluent_exp] = value

            # Record the successful transition as a positive example for the dataset
            positive_example = (
                current_state,
                best_action,
                best_grounding,
                True,
                next_state
            )
            dataset.append(positive_example)

            # Collect and record negative examples from the current state
            negative_examples = get_negative_examples(simulator, current_state, grounded_actions)
            dataset.extend(negative_examples)
            
            # Update current state
            current_state = next_state

        # If all non-required conditions have been covered reach the goal
        if is_empty_preconds(useful_preconds):
            # Initial state is set as current state
            new_problem = problem.clone()
            for fluent_exp, value in current_state._values.items():
                if value is not None:
                    new_problem.set_initial_value(fluent_exp, value)
            # Resolve
            with OneshotPlanner(name='pyperplan') as planner:
                result = planner.solve(new_problem)

            if result is not None and result.plan is not None:
                # Iterate through the final plan actions and record data for each action
                for plan_action in result.plan.actions:
                    # Execute the plan step
                    action = plan_action.action
                    grounding = tuple([param.object() for param in plan_action.actual_parameters])
                    instantiated_action = ActionInstance(action, grounding)
                    next_state = simulator.apply(current_state, instantiated_action)
                    for fluent_exp, value in current_state._values.items():
                        if fluent_exp not in next_state._values:
                            next_state._values[fluent_exp] = value

                    # Record the successful plan step as a positive example
                    positive_example = (
                        current_state,
                        action,
                        grounding,
                        True,
                        next_state
                    )
                    dataset.append(positive_example)

                    # Collect and record negative examples from the current state
                    negative_examples = get_negative_examples(simulator, current_state, grounded_actions)
                    dataset.extend(negative_examples)

                    # Update current state
                    current_state = next_state
    
    # Write resulting dataset on file
    write_dataset(dataset, output_filename)


if __name__ == '__main__':
    main()