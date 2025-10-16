from itertools import product as itertool_product
from typing import Dict, List, Set, Tuple

from pddl_plus_parser.models.pddl_domain import Domain
from pddl_plus_parser.models.pddl_problem import Problem
from pddl_plus_parser.models.pddl_predicate import GroundedPredicate
from pddl_plus_parser.models.pddl_action import Action
from pddl_plus_parser.lisp_parsers.domain_parser import DomainParser
from pddl_plus_parser.lisp_parsers.problem_parser import ProblemParser

from dataset_reader import DatasetReader


def state_str(state: Dict[str, Set[GroundedPredicate]]):
    result = ''
    for predicate, p_set in state.items():
        p_list = sorted([str(p) for p in p_set])
        result += predicate + ':\n'
        for p_param in p_list:
            result += f'- {p_param}\n'
        result += '\n'
    return result


def get_literals_space(domain: Domain, problem: Problem) -> Dict[str, Set[GroundedPredicate]]:
    predicate_param_objs = {}
    for predicate, p_value in domain.predicates.items():
        predicate_param_objs[predicate] = {}
        signature_order_dict = {str(p_value).index(param): param for param in p_value.signature}
        param_sorted_list = sorted([index for index in signature_order_dict.keys()])
        param_sorted_list = [signature_order_dict[index] for index in param_sorted_list]

        for param, param_type in p_value.signature.items():
            obj_list = []
            for obj_name, obj in problem.objects.items():
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
            
            predicate_param_objs[predicate][param] = obj_list
        # TODO guardare bene se il prodotto funziona con nomi di variabili di lunghezza >1
        predicate_param_objs[predicate] = list(itertool_product(*predicate_param_objs[predicate].values()))

        g_predicates = set()
        for param_sign in predicate_param_objs[predicate]:
            obj_mapping = {param: value for param, value in zip(param_sorted_list, param_sign)}
            true_predicate = GroundedPredicate(predicate, p_value.signature, obj_mapping, True)
            false_predicate = GroundedPredicate(predicate, p_value.signature, obj_mapping, False)
            g_predicates.add(true_predicate)
            g_predicates.add(false_predicate)
        
        predicate_param_objs[predicate] = g_predicates

    return predicate_param_objs


def get_action_space(domain: Domain, action: str) -> Dict[str, Set[GroundedPredicate]]:
    action_space = {}
    action_parameters = tuple(domain.actions[action].signature.keys())

    # TODO prendere solo predicati che hanno len(parameters)<=len(action_parameters)

    for predicate_name, predicate in domain.predicates.items():
        signature_order_dict = {str(predicate).index(param): param for param in predicate.signature}
        param_sorted_list = sorted([index for index in signature_order_dict.keys()])
        param_sorted_list = [signature_order_dict[index] for index in param_sorted_list]

        predicate_set = set()
        for param_combo in itertool_product(action_parameters, repeat=len(predicate.signature)):
            obj_mapping = {p: v for p, v in zip(param_sorted_list, param_combo)}
            true_predicate = GroundedPredicate(predicate_name, predicate.signature, obj_mapping, True)
            false_predicate = GroundedPredicate(predicate_name, predicate.signature, obj_mapping, False)
            predicate_set.add(true_predicate)
            predicate_set.add(false_predicate)
        action_space[predicate_name] = predicate_set

    return action_space


def action_intersection(
    state: Dict[str, Set[GroundedPredicate]],
    action: Action,
    action_parameters: List[str],
    action_space: Dict[str, Set[GroundedPredicate]],
    domain: Domain
):
    substate: Dict[str, Set[GroundedPredicate]] = {}
    for predicate_name, predicates in state.items():
        substate[predicate_name] = set()
        for predicate in predicates:
            involved = True
            for p_ground in predicate.object_mapping.values():
                if p_ground not in action_parameters:
                    involved = False
                    break
            if involved:
                substate[predicate_name].add(predicate)

    # for p, p_set in substate.items():
    #     print(p)
    #     for el in p_set:
    #         print('-', el)
    # print('==============================')
    
    signature_order_dict = {str(action).index(param): param for param in action.signature.keys()}
    param_sorted_list = sorted([index for index in signature_order_dict.keys()])
    param_sorted_list = [signature_order_dict[index] for index in param_sorted_list]
    parameters_pairing = {k: v for k, v in zip(action_parameters, param_sorted_list)}
    # print(parameters_pairing)
    parametrized_substate: Dict[str, Set[GroundedPredicate]] = {}
    for predicate_name, predicates in substate.items():
        parametrized_substate[predicate_name] = set()

        # TODO SISTEMARE
        predicate_signature = domain.predicates[predicate_name].signature
        for predicate in predicates:
            obj_mapping = {}
            for param, ground in predicate.object_mapping.items():
                obj_mapping[param] = parameters_pairing[ground]
            grounded = GroundedPredicate(predicate_name, predicate_signature, obj_mapping, predicate.is_positive)
            parametrized_substate[predicate_name].add(grounded)
    action_result = {}
    for predicate_name, predicates in action_space.items():
        action_result[predicate_name] = action_space[predicate_name].intersection(parametrized_substate[predicate_name])
    
    return action_result


def action_diff(
    state: Dict[str, Set[GroundedPredicate]],
    action: Action,
    action_parameters: List[str],
    action_space: Dict[str, Set[GroundedPredicate]],
    domain: Domain
):
    substate: Dict[str, Set[GroundedPredicate]] = {}
    for predicate_name, predicates in state.items():
        substate[predicate_name] = set()
        for predicate in predicates:
            involved = True
            for p_ground in predicate.object_mapping.values():
                if p_ground not in action_parameters:
                    involved = False
                    break
            if involved:
                substate[predicate_name].add(predicate)

    # for p, p_set in substate.items():
    #     print(p)
    #     for el in p_set:
    #         print('-', el)
    # print('==============================')
    
    signature_order_dict = {str(action).index(param): param for param in action.signature.keys()}
    param_sorted_list = sorted([index for index in signature_order_dict.keys()])
    param_sorted_list = [signature_order_dict[index] for index in param_sorted_list]
    parameters_pairing = {k: v for k, v in zip(action_parameters, param_sorted_list)}
    # print(parameters_pairing)
    parametrized_substate: Dict[str, Set[GroundedPredicate]] = {}
    for predicate_name, predicates in substate.items():
        parametrized_substate[predicate_name] = set()

        # TODO SISTEMARE
        predicate_signature = domain.predicates[predicate_name].signature
        for predicate in predicates:
            obj_mapping = {}
            for param, ground in predicate.object_mapping.items():
                obj_mapping[param] = parameters_pairing[ground]
            grounded = GroundedPredicate(predicate_name, predicate_signature, obj_mapping, predicate.is_positive)
            parametrized_substate[predicate_name].add(grounded)
    action_result = {}
    for predicate_name, predicates in action_space.items():
        action_result[predicate_name] = action_space[predicate_name].difference(parametrized_substate[predicate_name])
    
    return action_result


    
    
    


if __name__ == '__main__':
    
    dataset_path = 'domains/blocksworld/dataset.csv' 
    domain_path = 'domains/blocksworld/domain.pddl'
    problem_path = 'domains/blocksworld/problem.pddl'
    dataset = DatasetReader(domain_path).load_dataset(dataset_path)

    domain = DomainParser(domain_path).parse_domain()
    problem = ProblemParser(problem_path, domain).parse_problem()

    lower_precond = get_literals_space(domain, problem)
    act = 'stack'
    low_prec_h = get_action_space(domain, act)
    # action state è un set oppure un super set?

    
    # for pr, p_set in low_prec_h.items():
    #     print(pr, ':')
    #     p_list = sorted([str(p) for p in p_set])
    #     for el in p_list:
    #         print('-', el)

    # print('\n', '='*30, '\n')
    res = action_intersection(dataset[9][0], domain.actions[act], dataset[9][2], low_prec_h, domain)
    res2 = action_intersection(dataset[15][0], domain.actions[act], dataset[15][2], res, domain)
    print(state_str(res2))
    print('-'*40, '\n', act, dataset[2][2])
    print(state_str(dataset[2][0]))
    res3 = action_diff(dataset[2][0], domain.actions[act], dataset[2][2], res, domain)
    print(state_str(res3))