import csv
import json
from typing import List, Tuple
from pddl_plus_parser.lisp_parsers.domain_parser import DomainParser
from pddl_plus_parser.models.pddl_predicate import GroundedPredicate
from pddl_plus_parser.models.pddl_state import State

class DatasetReader:

    def __init__(self, domain_path: str):
        self.domain = DomainParser(domain_path).parse_domain()

    def __read_state(self, state_str: str) -> State:
        """
        Read a dataset state-string and transform it in a state.

        Args:
            state_str: string representing a state in ,
            domain: domain of PDDL problem

        Returns:
            state as a Dict
        """
        try:
            state_dict_raw = json.loads(state_str)
            state = {predicate: set() for predicate in self.domain.predicates}

            for fact_str, value_str in state_dict_raw.items():

                state_value = False
                if value_str.lower() == 'true':
                    state_value = True

                predicate: GroundedPredicate
                split_list = fact_str.split('(')
                if len(split_list) == 1:
                    predicate = GroundedPredicate(fact_str, {}, {}, state_value)
                elif len(split_list) == 2:
                    predicate_name = split_list[0]
                    parameters_str = split_list[1].replace(')', '')
                    parameters_list = [s.strip() for s in parameters_str.split(',')]
                    predicate_signature = self.domain.predicates[predicate_name].signature
                    predicate_signature_str = str(self.domain.predicates[predicate_name])
                    predicate_signature_order_dict = {predicate_signature_str.index(s): s for s in predicate_signature}
                    predicate_signature_order_list = sorted([index for index in predicate_signature_order_dict.keys()])
                    predicate_signature_order_list = [predicate_signature_order_dict[index] for index in predicate_signature_order_list]
                    obj_mapping = {param_sign: param_actual for param_sign, param_actual in zip(predicate_signature_order_list, parameters_list)}
                    predicate = GroundedPredicate(predicate_name, predicate_signature, obj_mapping, state_value)
                else:
                    predicate = None
                
                state[predicate.name].add(predicate)
            
            state = State(state, None)
            return state
            
        except (json.JSONDecodeError, ValueError) as e:
            return None


    def load_dataset(self, file_path: str) -> List[Tuple[State, str, List[str], bool, State]]:
        """
        Load data from CSV file.
        Output format is:
        State - s
        str - string that represents the action
        List[str] - action parameters
        bool - action result
        State - New state s' after the action effects; if bool is False, this is None
        
        Args:
            file_path: file path of CSV file,
            domain: domain of PDDL problem,
            problem: instance of PDDL problem.
            
        Returns:
            A list of examples
            
        """
        
        with open(file_path, 'r', newline='', encoding='utf-8') as csvfile:
            
            reader = csv.reader(csvfile, delimiter=';')
            try:
                next(reader) 
            except StopIteration:
                print('File is empty.')
                return []
                
            transformed_data = []
            
            for row in reader:
                if len(row) != 5:
                    print(f'Skipped row due to incorrect format: {row}')
                    continue

                state_str, action_name, params_str, result_str, next_str = row
                
                # Column 1: state
                state = self.__read_state(state_str)
                if state is None:
                    print(f'Parsing error in JSON: {e}')
                    continue

                # Column 3: action parameters 
                try:
                    params_list = json.loads(params_str)
                except json.JSONDecodeError as e:
                    print(f'Parsing error in JSON: {e} at row: {row}')
                    continue

                # Column 4: action result
                result = False 
                if result_str.lower() == 'true':
                    result = True

                next_state = None

                # Column 5: state result
                if next_str.lower() == 'none':
                    next_state = None
                else:
                    next_state = self.__read_state(next_str)
                    if next_state is None:
                        print(f'Parsing error in JSON: {e}')
                        continue
                    
                transformed_data.append((state, action_name, params_list, result, next_state))
                
            return transformed_data
    