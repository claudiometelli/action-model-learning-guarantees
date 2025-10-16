from pddl_plus_parser.lisp_parsers.domain_parser import DomainParser
from pddl_plus_parser.lisp_parsers.problem_parser import ProblemParser

from utils.dataset_reader import DatasetReader
from utils.aml_utils import state_to_str, get_action_space, action_intersection


if __name__ == '__main__':
    
    dataset_path = 'domains/blocksworld/dataset.csv' 
    domain_path = 'domains/blocksworld/domain.pddl'
    problem_path = 'domains/blocksworld/problem.pddl'

    dataset = DatasetReader(domain_path).load_dataset(dataset_path)
    domain = DomainParser(domain_path).parse_domain()
    problem = ProblemParser(problem_path, domain).parse_problem()

    action_name = 'stack'
    action_row_index = 9
    state, action_params = dataset[action_row_index][0], dataset[action_row_index][2]

    lower_preconds = get_action_space(domain, action_name)
    intersection_result = action_intersection(
        state,
        domain.actions[action_name],
        action_params,
        lower_preconds,
        domain
    )
    
    print('=' * 40, 'ACTION SPACE', '=' * 40, sep='\n', end='\n')
    print(state_to_str(lower_preconds))
    print('=' * 40, 'ACTION INTERSECTION', '=' * 40, sep='\n', end='\n')
    print(state_to_str(intersection_result))
