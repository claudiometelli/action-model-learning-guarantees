import random
import itertools
from unified_planning.io import PDDLReader
from unified_planning.shortcuts import *

get_environment().credits_stream = None
domain_path = 'domains/blocksworld/domain.pddl'
problem_path = 'domains/blocksworld/problem.pddl'
reader = PDDLReader()
problem = reader.parse_problem(domain_path, problem_path)



with OneshotPlanner(name='pyperplan') as planner:
    result = planner.solve(problem)

plan = None
if result is not None and result.plan is not None:
    plan = result.plan
    print(result)
    print('\n', '=' * 20, '\n')

dataset = []
positive_examples_per_state = 2
negative_examples_per_state = 2

with SequentialSimulator(problem) as simulator:
    current_state = simulator.get_initial_state()

    for step in range(len(plan.actions)):
        action_param_choices = {}
    
        for action in problem.actions:
            possible_params = []
            
            for param in action.parameters:
                possible_params.append(problem.objects(param.type))

            possible_combinations = list(itertools.product(*possible_params))
            random.shuffle(possible_combinations)
            action_param_choices[action] = {'index': 0, 'params': possible_combinations}

        positive_examples = []
        negative_examples = []
        exit_condition = False
        i = 0

        while not exit_condition:
            random_action = list(action_param_choices.keys())[random.randint(0, len(action_param_choices)-1)]
            random_combo = action_param_choices[random_action]['params'][action_param_choices[random_action]['index']]

            if simulator.is_applicable(current_state, random_action, random_combo):
                if len(positive_examples) < positive_examples_per_state:
                    positive_examples.append((current_state, random_action, random_combo, True))
            else:
                if len(negative_examples) < negative_examples_per_state:
                    negative_examples.append((current_state, random_action, random_combo, False))
            
            if len(positive_examples) == positive_examples_per_state and len(negative_examples) == negative_examples_per_state:
                exit_condition = True
            
            action_param_choices[random_action]['index'] += 1
            if action_param_choices[random_action]['index'] == len(action_param_choices[random_action]['params']):
                del action_param_choices[random_action]
            if len(action_param_choices) == 0:
                exit_condition = True

            i += 1
            
        dataset.extend(positive_examples)
        dataset.extend(negative_examples)
        state, action, params, _ = positive_examples[random.randint(0, len(positive_examples)-1)]
        next_state = simulator.apply(state, action, params)
        for fact, value in current_state._values.items():
            if next_state._values.get(fact) is None:
                next_state._values[fact] = value
        current_state = next_state

print('\nFIRST ELEMENT:')
state, action, params, result = dataset[0]
print('- State')
for fact, value in state._values.items():
    print(f'\t{fact} - {value}')
print(f'- Action: {action.name}')
print(f'- Objects: {params}')
print(f'- Result: {result}')

print('\nLAST ELEMENT:')
state, action, params, result = dataset[-1]
print('- State')
for fact, value in state._values.items():
    print(f'\t{fact} - {value}')
print(f'- Action: {action.name}')
print(f'- Objects: {params}')
print(f'- Result: {result}')
