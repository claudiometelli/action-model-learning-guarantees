from typing import Dict, List, Set, Tuple
from pddl_plus_parser.models.pddl_state import State
from pddl_plus_parser.models.pddl_predicate import Predicate
from pddl_plus_parser.models.pddl_precondition import Precondition, CompoundPrecondition
from pddl_plus_parser.models.pddl_domain import Domain

class DomainExporter:

    def __init__(
        self,
        lower_preconds: Dict[str, State],
        upper_preconds:Dict[str, List[State]],
        lower_effects: Dict[str, State],
        upper_effects: Dict[str, State],
        previous_domain: Domain
    ):
        self.lower_preconds = lower_preconds
        self.upper_preconds = upper_preconds
        self.lower_effects = lower_effects
        self.upper_effects = upper_effects
        self.domain = previous_domain
    
    def get_sound_model(self) -> Domain:
        new_domain = self.domain.shallow_copy()

        for action_name in self.domain.actions:
            sound_preconds: Set[Predicate] = set()
            sound_effects: Set[Predicate] = set()

            if self.lower_preconds[action_name].state_predicates is not None:
                for predicate_name, predicates in self.lower_preconds[action_name].state_predicates.items():
                    for predicate in predicates:
                        preconds = {}
                        for param in predicate.signature:
                            preconds[predicate.object_mapping[param]] = self.domain.actions[action_name].signature[predicate.object_mapping[param]]
                        # Questo controllo serve perchè non possono diventare dei predicati dei grounded predicate tipo on(x, x),
                        # visto che il predicato non accetta due parametri uguali per sua struttura in libreria, il comportamento in questo caso è da definire
                        if len(preconds) == len(predicate.signature):
                            sound_preconds.add(Predicate(predicate_name, preconds, None, predicate.is_positive))
                
                for precond in sound_preconds:
                    new_domain.actions[action_name].preconditions.add_condition(precond)

            if self.lower_effects[action_name].state_predicates is not None:
                for predicate_name, predicates in self.lower_effects[action_name].state_predicates.items():
                    for predicate in predicates:
                        effect = {}
                        for param in predicate.signature:
                            effect[predicate.object_mapping[param]] = self.domain.actions[action_name].signature[predicate.object_mapping[param]]
                        if len(effect) == len(predicate.signature):
                            sound_effects.add(Predicate(predicate_name, effect, None, predicate.is_positive))

                new_domain.actions[action_name].discrete_effects = sound_effects

        return new_domain


    def get_complete_model(self):
        new_domain = self.domain.shallow_copy()

        for action_name in self.domain.actions:
            complete_effects: Set[Predicate] = set()

            if len(self.upper_preconds[action_name]) == 1:
                complete_preconds: Set[Predicate] = set()
                hypotesis = self.upper_preconds[action_name][0]
                if hypotesis.state_predicates is not None:
                    for predicate_name, predicates in hypotesis.state_predicates.items():
                        for predicate in predicates:
                            preconds = {}
                            for param in predicate.signature:
                                preconds[predicate.object_mapping[param]] = self.domain.actions[action_name].signature[predicate.object_mapping[param]]
                            # Questo controllo serve perchè non possono diventare dei predicati dei grounded predicate tipo on(x, x),
                            # visto che il predicato non accetta due parametri uguali per sua struttura in libreria, il comportamento in questo caso è da definire
                            if len(preconds) == len(predicate.signature):
                                complete_preconds.add(Predicate(predicate_name, preconds, None, predicate.is_positive))
                    for precond in complete_preconds:
                        new_domain.actions[action_name].preconditions.add_condition(precond)


            else:
                complete_preconds: CompoundPrecondition = CompoundPrecondition()
                complete_preconds.root = Precondition('or')
                for hypotesis in self.upper_preconds[action_name]:
                    hypotesis_preconds = Precondition('and')

                    for predicate_name, predicates in hypotesis.state_predicates.items():
                        for predicate in predicates:
                            preconds = {}
                            for param in predicate.signature:
                                preconds[predicate.object_mapping[param]] = self.domain.actions[action_name].signature[predicate.object_mapping[param]]
                            # Questo controllo serve perchè non possono diventare dei predicati dei grounded predicate tipo on(x, x),
                            # visto che il predicato non accetta due parametri uguali per sua struttura in libreria, il comportamento in questo caso è da definire
                            if len(preconds) == len(predicate.signature):
                                predicate = Predicate(predicate_name, preconds, None, predicate.is_positive)
                                hypotesis_preconds.add_condition(predicate)
                    
                    complete_preconds.add_condition(hypotesis_preconds)
                
                new_domain.actions[action_name].preconditions = complete_preconds

        # for action_name, action in new_domain.actions.items():
        #     print(f'ACTION NAME: {action_name}')
        #     for operand in action.preconditions.root.operands:
        #         print(operand)


            if self.upper_effects[action_name].state_predicates is not None:
                for predicate_name, predicates in self.upper_effects[action_name].state_predicates.items():
                    for predicate in predicates:
                        effect = {}
                        for param in predicate.signature:
                            effect[predicate.object_mapping[param]] = self.domain.actions[action_name].signature[predicate.object_mapping[param]]
                        if len(effect) == len(predicate.signature):
                            complete_effects.add(Predicate(predicate_name, effect, None, predicate.is_positive))

                new_domain.actions[action_name].discrete_effects = complete_effects

            print(f'Action: {action_name}')
            for effect in new_domain.actions[action_name].discrete_effects:
                print(f'- {effect}')

        return new_domain
                