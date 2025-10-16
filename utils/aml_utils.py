from itertools import product as itertool_product
from typing import Dict, List, Set, Tuple

from pddl_plus_parser.models.pddl_domain import Domain
from pddl_plus_parser.models.pddl_problem import Problem
from pddl_plus_parser.models.pddl_predicate import Predicate, GroundedPredicate
from pddl_plus_parser.models.pddl_action import Action
from pddl_plus_parser.models.pddl_state import State

def state_to_str(state: State):
    """Function that represent a state as a string"""
    result = ''
    for predicate_name, predicate_set in state.state_predicates.items():
        # sort elements in the predicate set
        predicate_list = sorted([str(p) for p in predicate_set])
        result += predicate_name + ':\n'
        for predicate in predicate_list:
            result += f'- {predicate}\n'
        result += '\n'
    return result

def get_sorted_predicate_params(predicate: Predicate) -> List[str]:
    """Function that returns predicate parameters as a list, mantaining the same order as declaration"""
    params_indices_dict = {str(predicate).index(param): param for param in predicate.signature}
    sorted_indices = sorted([index for index in params_indices_dict.keys()])
    sorted_params = [params_indices_dict[index] for index in sorted_indices]
    return sorted_params

def get_sorted_action_params(action: Action) -> List[str]:
    """Function that returns action parameters as a list, mantaining the same order as declaration"""
    params_indices_dict = {str(action).index(param): param for param in action.signature}
    sorted_indices = sorted([index for index in params_indices_dict.keys()])
    sorted_params = [params_indices_dict[index] for index in sorted_indices]
    return sorted_params


def get_literals_space(domain: Domain, problem: Problem) -> State:
    """
    Generates the entire space of possible grounded literals (predicates) for a given PDDL domain and problem.
    This includes both the positive literal and its negation for every valid object combination applicable to that predicate.

    Args:
        domain: The parsed PDDL Domain object.
        problem: The parsed PDDL Problem object.

    Returns:
        A State object containing all possible grounded literals (the full state space).
    """
    predicates = {}
    for predicate_name, predicate in domain.predicates.items():
        predicates[predicate_name] = {}

        # Determine compatible objects for each parameter
        for param, param_type in predicate.signature.items():
            obj_list = []
            for obj_name, obj in problem.objects.items():
                # Type Checking for PDDL Type
                # if param type is equal or param type is object, accept
                if param_type.parent is None or obj.type == param_type:
                    obj_list.append(obj_name)
                else:
                    parent_type = obj.type.parent
                    while parent_type is not None and parent_type != param_type:
                        parent_type = parent_type.parent
                    # accept only if object type is son of param_type
                    if parent_type is not None:
                        obj_list.append(obj_name)
            
            predicates[predicate_name][param] = obj_list

        # Calculate all possible object combinations (grounding)
        predicates[predicate_name] = list(itertool_product(*predicates[predicate_name].values()))
        # This sorted list is necessary for correct object mapping, using zip
        sorted_params = get_sorted_predicate_params(predicate)
        # Create grounded predicates
        grounded_predicates = set()

        # For each possible couple
        for param_sign in predicates[predicate_name]:
            # Apply mapping associating ordered parameters name with concrete objects
            obj_mapping = {param: value for param, value in zip(sorted_params, param_sign)}
            true_predicate = GroundedPredicate(predicate_name, predicate.signature, obj_mapping, True)
            false_predicate = GroundedPredicate(predicate_name, predicate.signature, obj_mapping, False)
            grounded_predicates.add(true_predicate)
            grounded_predicates.add(false_predicate)
        
        predicates[predicate_name] = grounded_predicates
    # Return the literal space as a State object
    result = State(predicates, None)
    return result


def get_action_space(domain: Domain, action: str) -> State:
    """
    Generates the symbolic literal space for a given action. 
    This function grounds all domain predicates using the action's own parameter names.
    This resulting space defines all potential literals relevant to the action's signature.

    Args:
        domain: The parsed PDDL Domain object.
        action: The name of the action to analyze.

    Returns:
        A State object containing all possible symbolic grounded literals for the action.
    """
    action_space = {}
    action_parameters = tuple(domain.actions[action].signature.keys())

    for predicate_name, predicate in domain.predicates.items():
        # This sorted list is necessary for correct object mapping, using zip
        sorted_params = get_sorted_predicate_params(predicate)
        predicate_set = set()
        
        # Generate all symbolic combinations
        for action_params_combination in itertool_product(action_parameters, repeat=len(predicate.signature)):
            # Apply mapping associating ordered predicate parameter names with action parameter names
            obj_mapping = {p: v for p, v in zip(sorted_params, action_params_combination)}
            true_predicate = GroundedPredicate(predicate_name, predicate.signature, obj_mapping, True)
            false_predicate = GroundedPredicate(predicate_name, predicate.signature, obj_mapping, False)
            predicate_set.add(true_predicate)
            predicate_set.add(false_predicate)
        action_space[predicate_name] = predicate_set
    
    # Return the action space as a State object
    result = State(action_space, None)
    return result


def action_intersection(state: State, action: Action, action_parameters: List[str], action_space: State, domain: Domain) -> State:
    """
    Computes the intersection between a concrete problem state and the symbolic action space.
    The process involves three main steps:
    1. Filter the concrete State to keep only literals involving the action's specific grounded objects.
    2. Translate these filtered concrete literals into symbolic literals using the action's parameter names.
    3. Intersect the translated literals with the full symbolic action Space.

    Args:
        state: The current concrete State of the problem.
        action: The Action object (used to get parameter mapping).
        action_parameters: The list of concrete objects grounding the action (e.g., ['b1', 't']).
        action_space: The State object representing all possible symbolic literals for the action.
        domain: The PDDL Domain object.

    Returns:
        A State object containing the set of symbolic literals from the Action Space 
        that are TRUE (or FALSE) in the current concrete State.
    """
    # State representing step 1
    substate: Dict[str, Set[GroundedPredicate]] = {}
    # State representing step 2
    parametrized_substate: Dict[str, Set[GroundedPredicate]] = {}
    # State representing step 3
    action_result: Dict[str, Set[GroundedPredicate]] = {}
    # This sorted list is necessary for correct object mapping, using zip
    sorted_params = get_sorted_action_params(action)
    parameters_pairing = {k: v for k, v in zip(action_parameters, sorted_params)}

    # Step 1
    for predicate_name, predicates in state.items():
        substate[predicate_name] = set()
        for predicate in predicates:
            # Check if all objects involved in the grounded predicate are part of the action's grounded parameters.
            involved = True
            for p_ground in predicate.object_mapping.values():
                if p_ground not in action_parameters:
                    involved = False
                    break
            if involved:
                substate[predicate_name].add(predicate)
    
    # Step 2
    for predicate_name, predicates in substate.items():
        parametrized_substate[predicate_name] = set()

        predicate_signature = domain.predicates[predicate_name].signature
        for predicate in predicates:
            obj_mapping = {}
            for param, ground in predicate.object_mapping.items():
                obj_mapping[param] = parameters_pairing[ground]
            grounded = GroundedPredicate(predicate_name, predicate_signature, obj_mapping, predicate.is_positive)
            parametrized_substate[predicate_name].add(grounded)
    
    for predicate_name, predicates in action_space.items():
        action_result[predicate_name] = action_space[predicate_name].intersection(parametrized_substate[predicate_name])
    
    result = State(action_result, None)
    return result