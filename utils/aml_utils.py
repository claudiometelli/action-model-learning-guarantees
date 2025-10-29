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
    if state.state_predicates is None:
        return 'Empty State'
    for predicate_name, predicate_set in state.state_predicates.items():
        # sort elements in the predicate set
        predicate_list = sorted([str(p) for p in predicate_set])
        result += predicate_name + ':\n'
        for predicate in predicate_list:
            result += f'- {predicate}\n'
    result = result[:-1]
    return result

def get_sorted_predicate_params(predicate: Predicate) -> List[str]:
    """Function that returns predicate parameters as a list, mantaining the same order as declaration"""
    params_indices_dict = {str(predicate).index(param): param for param in predicate.signature}
    sorted_indices = sorted([index for index in params_indices_dict.keys()])
    sorted_params = [params_indices_dict[index] for index in sorted_indices]
    return sorted_params

# def get_sorted_predicate_groundings(predicate: GroundedPredicate) -> List[str]:
#     """Function that returns predicate groundings as a list, mantaining the same order as declaration"""
#     params_indices_dict = {str(predicate).index(param): param for param in predicate.object_mapping.values()}
#     sorted_indices = sorted([index for index in params_indices_dict.keys()])
#     sorted_params = [params_indices_dict[index] for index in sorted_indices]
#     return sorted_params


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
    result = State(predicates, {})
    return 

def check_type(obj_mapping: Dict[str, str], predicate: Predicate, action: Action) -> bool:
    # per ogni value dell'obj mapping, prendo il tipo della value dalla azione, e verifico che esso sia compatibile con il tipo nella signature del predicato
    result = True
    
    for predicate_symbol, action_symbol in obj_mapping.items():

        predicate_symbol_type = predicate.signature[predicate_symbol]
        action_symbol_type = action.signature[action_symbol]
        
        if predicate_symbol_type.parent is None or predicate_symbol_type == action_symbol_type:
            continue

        parent_type = action_symbol_type.parent
        while parent_type is not None and parent_type != predicate_symbol_type:
            parent_type = parent_type.parent
        if parent_type is None:
            result = False
            break

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
            # if parameter combination is acceptable due to PDDL types, add GroundedPredicate
            if check_type(obj_mapping, predicate, domain.actions[action]):
                true_predicate = GroundedPredicate(predicate_name, predicate.signature, obj_mapping, True)
                false_predicate = GroundedPredicate(predicate_name, predicate.signature, obj_mapping, False)
                predicate_set.add(true_predicate)
                predicate_set.add(false_predicate)
        action_space[predicate_name] = predicate_set
    
    # Return the action space as a State object
    result = State(action_space, {})
    return result

def get_involved_parameters_substate(state: State, action_parameters: List[str]) -> Dict[str, Set[GroundedPredicate]]:
    """
    Filters a complete state to create a substate containing only those grounded literals
    that exclusively involve the specific objects used in the current action instance.
    This substate represents the portion of the environment relevant for the prediction of the action's preconditions and effects.

    Args:
        state: The current concrete state of the problem.
        action_parameters: The list of concrete objects grounding the action.

    Returns:
        A dictionary mapping predicate names to the filtered set of GroundedPredicates that only involve the objects from action parameters.
    """
    substate: Dict[str, Set[GroundedPredicate]] = {}
    for predicate_name, predicates in state.state_predicates.items():
        substate[predicate_name] = set()
        for predicate in predicates:
            # Check if all objects involved in the grounded predicate are part of the action's grounded parameters.
            involved = True
            # If any object used by the predicate is not one of the action's parameters, the predicate is irrelevant.
            for p_ground in predicate.object_mapping.values():
                if p_ground not in action_parameters:
                    involved = False
                    break
            if involved:
                substate[predicate_name].add(predicate)
    return substate

def get_parametrized_substate(
    substate: Dict[str, Set[GroundedPredicate]],
    action: Action,
    action_parameters: List[str],
    domain: Domain
) -> Dict[str, Set[GroundedPredicate]]:
    """
    Translates a filtered substate (the substate of literals involving action's objects) into a symbolic substate,
    where concrete objects are replaced by the action's parameter names.

    NOTE: This simplified version does not correctly handle cases where the same 
    concrete object is repeated in action_parameters (e.g., stack(c, c)).

    Args:
        substate: The filtered concrete state.
        action: The action object.
        action_parameters: The list of concrete objects grounding the action.
        domain: The PDDL Domain object (to retrieve predicate signatures).

    Returns:
        A dictionary containing the set of symbolic GroundedPredicates.
    """
    parametrized_substate: Dict[str, Set[GroundedPredicate]] = {}
    # This sorted list is necessary for correct object mapping, using zip
    sorted_params = get_sorted_action_params(action)
    parameters_pairing = {k: v for k, v in zip(action_parameters, sorted_params)}
    
    for predicate_name, predicates in substate.items():
        parametrized_substate[predicate_name] = set()
        predicate_signature = domain.predicates[predicate_name].signature
        
        for predicate in predicates:
            obj_mapping = {}
            for param, ground in predicate.object_mapping.items():
                obj_mapping[param] = parameters_pairing[ground]
            grounded = GroundedPredicate(predicate_name, predicate_signature, obj_mapping, predicate.is_positive)
            parametrized_substate[predicate_name].add(grounded)
    
    return parametrized_substate


def action_intersection(state: State, action: Action, action_parameters: List[str], action_space: State, domain: Domain) -> State:
    """
    Computes the intersection between a concrete problem state and the symbolic action space.
    It corresponds to ULP operations in the article
    The process involves three main steps:
    1. Filter the concrete State to keep only literals involving the action's specific grounded objects.
    2. Translate these filtered concrete literals into symbolic literals using the action's parameter names.
    3. Intersect the translated literals with the full symbolic action Space.

    Args:
        state: The current concrete state of the problem.
        action: The action object.
        action_parameters: The list of concrete objects grounding the action.
        action_space: The state object representing all possible symbolic literals for the action.
        domain: The PDDL Domain object.

    Returns:
        A state object containing the set of symbolic literals from the action space that are either true or false in the current state.
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
    for predicate_name, predicates in state.state_predicates.items():
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
    
    # Step 3
    for predicate_name, predicates in action_space.state_predicates.items():
        action_result[predicate_name] = action_space.state_predicates[predicate_name].intersection(parametrized_substate[predicate_name])
    
    result = State(action_result, {})
    return result

def is_hypotesis_subset(hypotesis: State, parametrized_state: Dict[str, Set[GroundedPredicate]]):
    if hypotesis.state_predicates is None:
        return True
    is_subset = True
    for predicate_name, predicates in hypotesis.state_predicates.items():
        if not predicates.issubset(parametrized_state[predicate_name]):
            is_subset = False
            break
    return is_subset

def expand_hypotesis(hypotesis: State, parametrized_state: Dict[str, Set[GroundedPredicate]], action_space_lb: State) -> List[State]:
    result = []
    all_state_predicates: Set[GroundedPredicate] = set()
    all_action_space_predicates: Set[GroundedPredicate] = set()

    for predicates in parametrized_state.values():
        all_state_predicates.update(predicates)
    for predicates in action_space_lb.state_predicates.values():
        all_action_space_predicates.update(predicates)

    new_hypotesis = all_action_space_predicates.difference(all_state_predicates)
    for h in new_hypotesis:
        new_ub_element = None
        if hypotesis.state_predicates is not None:
            element = {}
            for predicate_name, predicates in hypotesis.state_predicates.items():
                element[predicate_name] = predicates
            if element.get(h.name) is None:
                element[h.name] = set()
            element[h.name].add(h)
            new_ub_element = State(element, {})
        else:
            singleton_hypotesis = set()
            singleton_hypotesis.add(h)
            ub_element_predicate = {h.name: singleton_hypotesis}
            new_ub_element = State(ub_element_predicate, {})
        
        result.append(new_ub_element)
    
    return result

def get_parametrized_substate_fixed(substate: Dict[str, Set[GroundedPredicate]], action: Action, action_parameters: List[str], domain: Domain) -> Dict[str, Set[GroundedPredicate]]:
    """
    TODO sistemare il caso per cui ad esempio si ha unstack(c,c)
    """
    parametrized_substate: Dict[str, Set[GroundedPredicate]] = {}
    
    sorted_params = get_sorted_action_params(action)
    grounded_to_symbolic_map: List[Tuple[str, str]] = list(zip(action_parameters, sorted_params))
    
    print(f"Map symbol-position: {grounded_to_symbolic_map}")
    
    for predicate_name, predicates in substate.items():
        parametrized_substate[predicate_name] = set()
        predicate_signature = domain.predicates[predicate_name].signature
        sorted_predicate_params = get_sorted_predicate_params(domain.predicates[predicate_name])

        for predicate in predicates:
            print(f'-- analysis of predicate: {predicate}')
            obj_mapping = {}
            predicate_params = sorted_predicate_params.copy()
            predicate_groundings = [predicate.object_mapping[param] for param in predicate_params]
            print(predicate_params, predicate_groundings)

            consumed_counts = {p: 0 for p in action_parameters}
            
            for param_name, ground_obj in zip(predicate_params, predicate_groundings):
                
                found = False
                for i, (map_ground, map_symbol) in enumerate(grounded_to_symbolic_map):

                    if map_ground == ground_obj and consumed_counts[ground_obj] == i - sum(consumed_counts.values()):
                        obj_mapping[param_name] = map_symbol
                        consumed_counts[ground_obj] += 1
                        found = True
                        break
                
                if not found:
                    # In teoria non dovrebbe mai succedere se substate è stato filtrato correttamente
                    raise ValueError("Errore logico: Impossibile trovare mappatura per un oggetto filtrato.")

            grounded = GroundedPredicate(predicate_name, predicate_signature, obj_mapping, predicate.is_positive)
            parametrized_substate[predicate_name].add(grounded)
    
    return parametrized_substate

def update_preconds_ub(state: State, action: Action, action_parameters: List[str], action_space_lb: State, action_space_ub: List[State], domain: Domain):
    """
    Updates upper bound of precondition hypotheses.
    It corresponds to UUP operations in the article
    The process involves three main steps:
    1. Filter the concrete state to keep only literals involving the action's specific grounded objects.
    2. Translate these filtered concrete literals into symbolic literals using the action's parameter names.
    3. For each hypotesis keep it or expand it, following the article rules.

    Args:
        state: The current concrete state of the problem.
        action: The action object.
        action_parameters: The list of concrete objects grounding the action.
        action_space_lb: The lower bound of preconditions.
        action_space_ub: The upper bound of preconditions.
        domain: The PDDL Domain object.

    Returns:
        A list of refined precondition hypotheses, which represents the updated upper bound of preconditions.
    """
    # Step 1
    substate: Dict[str, Set[GroundedPredicate]] = get_involved_parameters_substate(state, action_parameters)
    # Step 2
    parametrized_substate: Dict[str, Set[GroundedPredicate]] = get_parametrized_substate(substate, action, action_parameters, domain)

    # Step 3
    new_action_space_ub = action_space_ub.copy()
    for hypotesis in action_space_ub:
        # If the current state is subset, the hypotesis is expanded
        if is_hypotesis_subset(hypotesis, parametrized_substate):
            expanded_hypotesis_set = expand_hypotesis(hypotesis, parametrized_substate, action_space_lb)
            new_action_space_ub.remove(hypotesis)
            new_action_space_ub.extend(expanded_hypotesis_set)
        # Otherwise the hypotesis is kept as it is
    
    return new_action_space_ub

def effect_union(state: State, next: State, action: Action, action_parameters: List[str], action_space_lb: State, domain: Domain) -> State:
    """
    Computes the union between lower bound of action effects and the observed effects derived from the state transition: state -> next.
    This function identifies the actual changes caused by the action, translates them into symbolic literals, and adds them to the cumulative set of effects.

    Args:
        state: the state before the action was executed.
        next: the state after the action was executed.
        action: the action object.
        action_parameters: the list of concrete objects used to ground the action.
        action_space_lb: the current lower bound of the action's effects.
        domain: The PDDL Domain object.

    Returns:
        A new State object representing the updated lower bound of the action's effects.
    """

    # Compute grounded effects (next \ state) and store
    state_grounded_effects = {}
    for predicate_name in next.state_predicates:
        state_grounded_effects[predicate_name] = next.state_predicates[predicate_name].difference(state.state_predicates[predicate_name])
    # Translate grounded effects to symbolic literals
    parametrized_substate: Dict[str, Set[GroundedPredicate]] = get_parametrized_substate(state_grounded_effects, action, action_parameters, domain)

    # Compute the union with the lower bound
    result = None
    # This condition occurs when the current lower bound is empty, it should be the first observed transition.
    if action_space_lb.state_predicates is None:
        result = State(parametrized_substate, None)
    # Otherwise the lower bound is already initialized
    else:
        state_predicates = {}
        for predicate_name in action_space_lb.state_predicates:
            state_predicates[predicate_name] = action_space_lb.state_predicates[predicate_name].union(parametrized_substate[predicate_name])
        result = State(state_predicates, {})
    
    return result



