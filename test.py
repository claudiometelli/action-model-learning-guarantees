from pddl_plus_parser.models.pddl_state import State

from pddl_plus_parser.lisp_parsers.domain_parser import DomainParser
from pddl_plus_parser.lisp_parsers.problem_parser import ProblemParser
from pddl_plus_parser.exporters.domain_exporter import DomainExporter as Exporter

from utils.dataset_reader import DatasetReader
from utils.domain_exporter import DomainExporter
from utils.aml_utils import state_to_str, get_action_space, action_intersection, update_preconds_ub, effect_union, check_type

debug = False

if __name__ == '__main__':

    domain_name = 'grocery'

    domain_path = f'domains/{domain_name}/domain.pddl'
    problem_path = f'domains/{domain_name}/problem_00.pddl'
    dataset_path = f'domains/{domain_name}/dataset_00.csv'

    sound_model_path = f'domains/{domain_name}/sound_domain_00.pddl'
    complete_model_path = f'domains/{domain_name}/complete_domain_00.pddl'

    dataset = DatasetReader(domain_path).load_dataset(dataset_path)
    domain = DomainParser(domain_path).parse_domain()
    problem = ProblemParser(problem_path, domain).parse_problem()

    lower_preconds = {}
    upper_preconds = {}
    lower_effects = {}
    upper_effects = {}
    for action_name in domain.actions:
        lower_preconds[action_name] = get_action_space(domain, action_name)
        upper_preconds[action_name] = [State(None, None)]
        lower_effects[action_name] = State(None, None)
        upper_effects[action_name] = get_action_space(domain, action_name)