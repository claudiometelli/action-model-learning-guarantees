from typing import Dict, List

from pddl_plus_parser.models.pddl_state import State
from pddl_plus_parser.models.pddl_domain import Domain
from pddl_plus_parser.models.pddl_problem import Problem

from pddl_plus_parser.lisp_parsers.domain_parser import DomainParser
from pddl_plus_parser.lisp_parsers.problem_parser import ProblemParser
from pddl_plus_parser.exporters.domain_exporter import DomainExporter as Exporter

from utils.dataset_reader import DatasetReader
from utils.domain_exporter import DomainExporter
from utils.aml_utils import state_to_str, get_action_space, action_intersection, update_preconds_ub, effect_union, reduce_upper_bound, get_effect_space

DEBUG = False
DOMAIN_NAME: str = 'zeno'
PROBLEM_INDEX: str = '00'

def main() -> None:

    domain_path: str = f'domains/{DOMAIN_NAME}/domain.pddl'
    problem_path: str = f'domains/{DOMAIN_NAME}/problem_{PROBLEM_INDEX}.pddl'
    dataset_path: str = f'domains/{DOMAIN_NAME}/dataset_{PROBLEM_INDEX}.csv'

    sound_model_path: str = f'domains/{DOMAIN_NAME}/sound_domain_{PROBLEM_INDEX}.pddl'
    complete_model_path: str = f'domains/{DOMAIN_NAME}/complete_domain_{PROBLEM_INDEX}.pddl'

    dataset: DatasetReader = DatasetReader(domain_path).load_dataset(dataset_path)
    domain: Domain = DomainParser(domain_path).parse_domain()
    problem: Problem = ProblemParser(problem_path, domain).parse_problem()

    if DEBUG:
        print(f'DOMAIN PREDICATES: {[predicate_name for predicate_name in domain.predicates]}')
        print(f'DOMAIN ACTIONS: {[action_name for action_name in domain.actions]}')
        print(f'PROBLEM OBJECTS: {[problem_obj for problem_obj in problem.objects]}')

    lower_preconds: Dict[str, State] = {}
    upper_preconds: Dict[str, List[State]] = {}
    lower_effects: Dict[str, State] = {}
    upper_effects: Dict[str, State] = {}
    for action_name in domain.actions:
        lower_preconds[action_name] = get_action_space(domain, action_name)
        upper_preconds[action_name] = [State(None, None)]
        lower_effects[action_name] = State(None, None)
        upper_effects[action_name] = get_action_space(domain, action_name)

    for row in dataset:
        state: State = row[0]
        action_name: str = row[1]
        action_params: List[str] = row[2]
        action_result: bool = row[3]
        next_state: State = row[4]
        
        if action_result:
            lower_preconds[action_name] = action_intersection(
                state,
                domain.actions[action_name],
                action_params,
                lower_preconds[action_name],
                domain
            )
            lower_effects[action_name] = effect_union(
                state,
                next_state,
                domain.actions[action_name],
                action_params,
                lower_effects[action_name],
                domain
            )
            upper_effects[action_name] = action_intersection(
                next_state,
                domain.actions[action_name],
                action_params,
                upper_effects[action_name],
                domain
            )
    
    for row in dataset:
        state: State = row[0]
        action_name: str = row[1]
        action_params: List[str] = row[2]
        action_result: bool = row[3]
        next_state: State = row[4]
        if not action_result:
            upper_preconds[action_name] = update_preconds_ub(
                state,
                domain.actions[action_name],
                action_params,
                lower_preconds[action_name],
                upper_preconds[action_name],
                domain
            )
    
    for action_name in domain.actions:
        upper_preconds[action_name] = reduce_upper_bound(upper_preconds[action_name])
    
    if DEBUG:
        for action_name in domain.actions:
            print(f"\n{'='*60}\nACTION ANALYSIS FOR ACTION: {action_name}\n{'='*60}")
            print(f"{'='*40}\n PRECONDITIONS LOWER BOUND: {action_name}\n{'='*40}\n{state_to_str(lower_preconds[action_name])}")
            print(f"{'='*40}\n PRECONDITIONS UPPER BOUND: {action_name}\n{'='*40}")
            for hypotesis in upper_preconds[action_name]:
                print(f"{state_to_str(hypotesis)}\n{'-'*40}")
            print(f"{'='*40}\n EFFECTS LOWER BOUND: {action_name}\n{'='*40}\n{state_to_str(lower_effects[action_name])}")
            print(f"{'='*40}\n EFFECTS UPPER BOUND: {action_name}\n{'='*40}\n{state_to_str(upper_effects[action_name])}")

    domain_exporter: DomainExporter = DomainExporter(
        lower_preconds=lower_preconds,
        upper_preconds=upper_preconds,
        lower_effects=lower_effects,
        upper_effects=upper_effects,
        previous_domain=domain
    )

    sound_domain = domain_exporter.get_sound_model()        
    complete_domain = domain_exporter.get_complete_model()

    Exporter().export_domain(sound_domain, sound_model_path)
    Exporter().export_domain(complete_domain, complete_model_path)


if __name__ == '__main__':
    main()