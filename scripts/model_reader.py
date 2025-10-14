import itertools
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
        for param, param_type in value.signature.items():
            print(f'{param}, {param_type}, {type(param).__name__}, {type(param_type).__name__}')
            print(param_type.parent)
        break

    print('\n## Actions: .........')
    for action, value in domain.actions.items():
        print(f'- Action: {action}')
        print(f'  Preconditions: {value.preconditions}')
        print(f'  Effects: {value.discrete_effects}')
        break


def print_model_problem(problem):
    print(f'# Problem name: {problem.name}, domain: {problem.domain.name}')
    print('\n## Objects:')
    for obj_name, obj in problem.objects.items():
        print(f'-> {obj.name} - {obj.type}')
        print(type(obj).__name__)

    # print(problem.__dict__)
    print('\n## Initial state:')
    print(f'Initial State Type: {type(problem.initial_state_predicates).__name__}')
    for predicate, values in problem.initial_state_predicates.items():
        print(f'- {predicate}; predicate type: {type(predicate).__name__}')
        print(type(values).__name__)
        for arg in values:
            print(f'  - {arg}; type: {type(arg).__name__}')
            print(f'    {arg.__dict__}')
        


def grounding(domain, problem):
    predicate_param_objs = {}
    for predicate, p_value in domain.predicates.items():
        predicate_param_objs[predicate] = {}
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
        
        predicate_param_objs[predicate] = list(itertools.product(*predicate_param_objs[predicate].values()))
    
    # for k, v in predicate_param_objs.items():
    #     print(f'{k}: {v}; {len(v)}')


        


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
    print('\n\n')
    grounding(domain, problem)
