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
