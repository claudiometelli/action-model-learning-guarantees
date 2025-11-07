import random
import itertools
from unified_planning.io import PDDLReader
from unified_planning.shortcuts import *

get_environment().credits_stream = None

domain_name = 'blocksworld'

domain_path = f'domains/{domain_name}/domain.pddl'
problem_path = f'domains/{domain_name}/problem_00.pddl'
output_filename = f'domains/{domain_name}/dataset_00.csv'

reader = PDDLReader()
problem = reader.parse_problem(domain_path, problem_path)

with OneshotPlanner(name='pyperplan') as planner:
    result = planner.solve(problem)

plan = None
if result is not None and result.plan is not None:
    plan = result.plan
    print(result)
    print(f'\n{'='*20}\n')

dataset = []

with SequentialSimulator(problem) as simulator:
    current_state = simulator.get_initial_state()

    for plan_action in plan.actions:
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
                    positive_examples.append((current_state, random_action, random_combo, True, None))
            else:
                if len(negative_examples) < negative_examples_per_state:
                    negative_examples.append((current_state, random_action, random_combo, False, None))
            
            if len(positive_examples) == positive_examples_per_state and len(negative_examples) == negative_examples_per_state:
                exit_condition = True
            
            action_param_choices[random_action]['index'] += 1
            if action_param_choices[random_action]['index'] == len(action_param_choices[random_action]['params']):
                del action_param_choices[random_action]
            if len(action_param_choices) == 0:
                exit_condition = True

            i += 1

        # Se qualcosa non torna è perchè ho mischiato un po' di logiche essendo che mi pesa il culo
        # TODO fixare
        # found_index = -1
        # for index, example in enumerate(positive_examples):
        #     if plan_action.action.name == example[1].name and str(plan_action.actual_parameters) == str(example[2]):
        #         found_index = index
        
        # if found_index == -1:
        #     plan_example = (current_state, plan_action.action, plan_action.actual_parameters, True)
        #     positive_examples.append(plan_example)
        #     found_index = len(positive_examples) - 1

        next_state = simulator.apply(current_state, plan_action.action, plan_action.actual_parameters)
        for fact, value in current_state._values.items():
            if next_state._values.get(fact) is None:
                next_state._values[fact] = value
        plan_example = (current_state, plan_action.action, plan_action.actual_parameters, True, next_state)
        positive_examples.append(plan_example)

        dataset.extend(positive_examples)
        dataset.extend(negative_examples)
        
        current_state = next_state
