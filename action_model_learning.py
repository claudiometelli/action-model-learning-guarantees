from pddl_plus_parser.models.pddl_state import State

from pddl_plus_parser.lisp_parsers.domain_parser import DomainParser
from pddl_plus_parser.lisp_parsers.problem_parser import ProblemParser

from utils.dataset_reader import DatasetReader
from utils.aml_utils import state_to_str, get_action_space, action_intersection, update_preconds_ub, effect_union


if __name__ == '__main__':
    
    dataset_path = 'domains/blocksworld/dataset_01.csv' 
    domain_path = 'domains/blocksworld/domain.pddl'
    problem_path = 'domains/blocksworld/problem_01.pddl'

    dataset = DatasetReader(domain_path).load_dataset(dataset_path)
    domain = DomainParser(domain_path).parse_domain()
    problem = ProblemParser(problem_path, domain).parse_problem()

    print(f'DOMAIN PREDICATES: {[predicate_name for predicate_name in domain.predicates]}')
    print(f'DOMAIN ACTIONS: {[action_name for action_name in domain.actions]}')
    print(f'PROBLEM OBJECTS: {[problem_obj for problem_obj in problem.objects]}')


    lower_preconds = {}
    upper_preconds = {}
    lower_effects = {}
    upper_effects = {}
    for action_name in domain.actions:
        lower_preconds[action_name] = get_action_space(domain, action_name)
        upper_preconds[action_name] = [State(None, None)]
        lower_effects[action_name] = State(None, None)
        upper_effects[action_name] = get_action_space(domain, action_name)

    for row in dataset:
        state = row[0]
        action_name = row[1]
        action_params = row[2]
        action_result = row[3]
        next_state = row[4]
        
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
        state = row[0]
        action_name = row[1]
        action_params = row[2]
        action_result = row[3]
        next_state = row[4]
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
        print(f"\n{'='*60}\nACTION ANALYSIS FOR ACTION: {action_name}\n{'='*60}")
        print(f"{'='*40}\n PRECONDITIONS LOWER BOUND: {action_name}\n{'='*40}\n{state_to_str(lower_preconds[action_name])}")
        print(f"{'='*40}\n PRECONDITIONS UPPER BOUND: {action_name}\n{'='*40}")
        for hypotesis in upper_preconds[action_name]:
            print(f"{state_to_str(hypotesis)}\n{'-'*40}")
        print(f"{'='*40}\n EFFECTS LOWER BOUND: {action_name}\n{'='*40}\n{state_to_str(lower_effects[action_name])}")
        print(f"{'='*40}\n EFFECTS UPPER BOUND: {action_name}\n{'='*40}\n{state_to_str(upper_effects[action_name])}")