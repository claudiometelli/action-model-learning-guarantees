from pddl_plus_parser.models.pddl_state import State

from pddl_plus_parser.lisp_parsers.domain_parser import DomainParser
from pddl_plus_parser.lisp_parsers.problem_parser import ProblemParser

from utils.dataset_reader import DatasetReader
from utils.aml_utils import state_to_str, get_action_space, action_intersection, update_preconds_ub, effect_union


if __name__ == '__main__':
    
    dataset_path = 'domains/blocksworld/dataset.csv' 
    domain_path = 'domains/blocksworld/domain.pddl'
    problem_path = 'domains/blocksworld/problem.pddl'

    dataset = DatasetReader(domain_path).load_dataset(dataset_path)
    domain = DomainParser(domain_path).parse_domain()
    problem = ProblemParser(problem_path, domain).parse_problem()

    action_row_index = 0
    state, action_name, action_params = dataset[action_row_index][0], dataset[action_row_index][1], dataset[action_row_index][2]

    lower_preconds = get_action_space(domain, action_name)
    upper_preconds = [State(None, None)]
    lower_effects = State(None, None)
    upper_effects = get_action_space(domain, action_name)


    intersection_result = action_intersection(
        state,
        domain.actions[action_name],
        action_params,
        lower_preconds,
        domain
    )
    
    # print('=' * 40, 'ACTION SPACE', '=' * 40, sep='\n', end='\n')
    # print(state_to_str(lower_preconds))
    # print('=' * 40, 'ACTION INTERSECTION', '=' * 40, sep='\n', end='\n')
    # print(state_to_str(intersection_result))
    # print('=' * 40, 'UUP OPERATION', '=' * 40, sep='\n', end='\n')
    # action_row_index = 4
    # state, action_name, action_params = dataset[action_row_index][0], dataset[action_row_index][1], dataset[action_row_index][2]
    # uup_result = UUP(
    #     state,
    #     domain.actions[action_name],
    #     action_params,
    #     intersection_result,
    #     upper_preconds,
    #     domain
    # )
    # for element in uup_result:
    #     print(state_to_str(element))
    #     print('-'*40)


    action_row_index = 0
    state, action_name, action_params, next_state = dataset[action_row_index][0], dataset[action_row_index][1], dataset[action_row_index][2], dataset[action_row_index][4]

    res = action_intersection(next_state, domain.actions[action_name], action_params, upper_effects, domain)
    print(state_to_str(res))

    # res = RLE(
    #     state,
    #     next_state,
    #     domain.actions[action_name],
    #     action_params, 
    #     lower_effects,
    #     domain
    # )

    action_row_index = 6
    state, action_name, action_params, next_state = dataset[action_row_index][0], dataset[action_row_index][1], dataset[action_row_index][2], dataset[action_row_index][4]

    res2 = action_intersection(next_state, domain.actions[action_name], action_params, res, domain)
    print(state_to_str(res2))

    # res2 = RLE(
    #     state,
    #     next_state,
    #     domain.actions[action_name],
    #     action_params, 
    #     res,
    #     domain
    # )

    

    # print(state_to_str(res))
    # print('=' * 40, 'RES 2', '=' * 40, sep='\n', end='\n')
    # print(state_to_str(res2))
    