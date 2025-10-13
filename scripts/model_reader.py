from pddl_plus_parser.lisp_parsers.domain_parser import DomainParser
from pddl_plus_parser.lisp_parsers.problem_parser import ProblemParser


def print_model_domain(domain):
    print(f'# Model name: {domain.name}')
    print('\n## Object types:')
    for obj_type in domain.types:
        print(f'- Type: {obj_type}')

    print('\n## Predicates:')
    for predicate, value in domain.predicates.items():
        print(f'- {predicate}: {value}')
        print(f' {value.name}, {value.__dict__}')
        break

    print('\n## Actions: .........')
    # for action, value in domain.actions.items():
    #     print(f'- Action: {action}')
    #     print(f'  Preconditions: {value.preconditions}')
    #     break


def print_model_problem(problem):
    print(f'# Problem name: {problem.name}, domain: {problem.domain.name}')
    print('\n## Objects:')
    for obj in problem.objects:
        print(f'- {obj}')

    print(problem.__dict__)
    print('\n## Initial state:')
    for predicate, values in problem.initial_state_predicates.items():
        print(f'- {predicate}')
        for arg in values:
            print(f'  - {arg}')
            print(f'    {arg.__dict__}')
        break


if __name__ == '__main__':
    domain_path = 'domains/blocksworld/domain.pddl'
    problem_path = 'domains/blocksworld/problem.pddl'

    domain_parser = DomainParser(domain_path)
    domain = domain_parser.parse_domain()
    problem_parser = ProblemParser(problem_path, domain)
    problem = problem_parser.parse_problem()

    print_model_domain(domain)
    print('\n\n')
    print_model_problem(problem)

