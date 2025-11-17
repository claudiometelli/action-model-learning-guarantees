import numpy as np
import matplotlib.pyplot as plt
from typing import Dict
from pddl_plus_parser.models.pddl_domain import Domain

class ModelEvaluator:

    def __init__(self, real_domain: Domain, sound_domain: Domain, complete_domain: Domain):
        self.real_domain = real_domain
        self.sound_domain  = sound_domain
        self.complete_domain = complete_domain
        
    def evaluate_sound_preconditions(self, print_chart=False):
        """
        Evaluates the correctness and overlap of the preconditions found in the 
        sound domain compared to the real domain.

        Args:
            print_chart (bool): If True, calls a method to visualize the results using a chart.

        Returns:
            Dict[str, Dict[str, int]]: A dictionary where each action is mapped to a dictionary containing:
                'common': Number of real preconditions.
                'sound': Number of sound preconditions.
        """
        result = {}
        for action_name, action in self.sound_domain.actions.items():
            total, intersec = 0, 0
            for precondition_item in action.preconditions:
                # Check if the hypothesized precondition is present in the real domain
                if precondition_item in self.real_domain.actions[action_name].preconditions:
                    intersec += 1
                total += 1
            
            result[action_name] = {}
            result[action_name]['common'] = intersec
            result[action_name]['sound'] = total
        
        if print_chart:
            self.print_sound_preconds_chart(result)

        return result
    
    def evaluate_sound_effects(self, print_chart=False):
        """
        Evaluates the correctness and overlap of the effects found in the 
        sound domain compared to the real domain.

        Args:
            print_chart (bool): If True, calls a method to visualize the results using a chart.

        Returns:
            Dict[str, Dict[str, int]]: A dictionary where each action is mapped to a dictionary containing:
                'common': Number of real effects.
                'sound': Number of sound effects.
        """
        result = {}
        for action_name, action in self.real_domain.actions.items():
            total, intersec = 0, 0
            for effect in action.discrete_effects:
                # Check if the hypothesized precondition is present in the real domain
                if effect in self.sound_domain.actions[action_name].discrete_effects:
                    intersec += 1
                total += 1
            
            result[action_name] = {}
            result[action_name]['common'] = intersec
            result[action_name]['sound'] = total
        
        if print_chart:
            self.print_sound_data_chart(result, counting='effects')

        return result

    
    def print_sound_data_chart(self, data: Dict[str, Dict[str, int]], counting='preconditions'):
        """
        Generate bar chart with real precondition and sound precondition for the two models

        Args:
            data (Dict[str, Dict[str, int]]): Dict with pre-calculated results
        """

        actions = list(data.keys())
        common_counts = np.array([data[a]['common'] for a in actions])
        sound_counts = np.array([data[a]['sound'] for a in actions])
        non_common_counts = sound_counts - common_counts
        
        
        ratios = np.zeros(len(actions))
        for i in range(len(actions)):
            if sound_counts[i] > 0:
                ratios[i] = (common_counts[i] / sound_counts[i]) * 100
            else:
                ratios[i] = 0

        x = np.arange(len(actions))  
        width = 0.5
        fig, ax = plt.subplots(figsize=(10, 6))

        rects1 = ax.bar(
            x, 
            common_counts, 
            width, 
            label=f'Common {counting.title()}', 
            color='#107755'
        )
        r2_label = 'Sound' if counting == 'preoconditions' else 'Real'
        rects2 = ax.bar(
            x, 
            non_common_counts, 
            width, 
            bottom=common_counts,
            label=f'{r2_label} {counting.title()}', 
            color='#c91e1e'
        )
        
        ax.set_ylabel(f'{counting.title()} Count')
        ax.set_title('Sound Model Comparison')
        ax.set_xticks(x)
        ax.set_xticklabels(actions, rotation=45, ha='right')
        ax.legend(loc='upper left')

        for i, rect in enumerate(rects1):
            height = sound_counts[i] 
            percentage_text = f'{ratios[i]:.1f}%'
            ax.annotate(
                percentage_text,
                xy=(rect.get_x() + rect.get_width() / 2, height),
                xytext=(0, 3),
                textcoords='offset points',
                ha='center',
                fontsize=9,
                fontweight='bold'
            )

        max_height = max(sound_counts) if sound_counts.size > 0 else 1
        ax.set_ylim(0, max_height * 1.2) 
        fig.tight_layout()
        plt.show()


    def evaluate_complete_preconditions(self, print_chart=False):
        result = {}
        for action_name, action in self.complete_domain.actions.items():
            result[action_name] = {}
            precision, recall= 0, 0

            real_domain_preconds = set()
            for _, predicate in self.real_domain.actions[action_name].preconditions:
                real_domain_preconds.add(predicate)
            
            if action.preconditions.root.binary_operator == 'or':
                
                for and_precondition in action.preconditions.root.operands:
                    if and_precondition.binary_operator != 'and':
                        continue
                    
                    TP, FP, FN = 0, 0, 0
                    and_predicates = [p[1] for p in and_precondition]
                    
                    for predicate in and_predicates:
                        if predicate in real_domain_preconds:
                            TP += 1
                        else:
                            FP += 1
                    
                    for predicate in real_domain_preconds:
                        if predicate not in and_predicates:
                            FN += 1

                    precision += TP / (TP + FP)
                    recall += TP / (TP + FN)
                
                precision /= len(action.preconditions.root.operands)
                recall /= len(action.preconditions.root.operands)
                
            elif action.preconditions.root.binary_operator == 'and':
                TP, FP, FN = 0, 0, 0
                for _, predicate in action.preconditions:
                    if predicate in real_domain_preconds:
                        TP += 1
                    else:
                        FP += 1

                for predicate in real_domain_preconds:
                    if predicate not in [p[1] for p in action.preconditions]:
                        FN += 1

                precision = TP / (TP + FP)
                recall = TP / (TP + FN)
            
            result[action_name]['precision'] = precision
            result[action_name]['recall'] = recall

        if print_chart:
            self.print_complete_preconditions_chart(result)

        return result
            

    def evaluate_complete_effects(self, print_chart=False):
        result = {}
        for action_name, action in self.complete_domain.actions.items():
            total, intersec = 0, 0
            for effect in action.discrete_effects:
                # Check if the hypothesized precondition is present in the real domain
                if effect in self.real_domain.actions[action_name].discrete_effects:
                    intersec += 1
                total += 1
            
            result[action_name] = {}
            result[action_name]['common'] = intersec
            result[action_name]['sound'] = total
        
        if print_chart:
            self.print_sound_data_chart(result, counting='effects')

        return result
    
    def print_complete_preconditions_chart(self, data: Dict[str, Dict[str, float]]):
        """
        Generate plot bar with precision and recall value of complete preconditions.

        Args:
            data (Dict[str, Dict[str, float]]): data (Dict[str, Dict[str, int]]): Dict with pre-calculated results
        """
        
        actions = list(data.keys())
        precision_values = np.array([data[a]['precision'] for a in actions])
        recall_values = np.array([data[a]['recall'] for a in actions])
        
        x = np.arange(len(actions))  
        width = 0.35
        fig, ax = plt.subplots(figsize=(12, 6), facecolor='white')

        for spine in ax.spines.values():
            spine.set_edgecolor('black')
            spine.set_linewidth(1.5)

        rects1 = ax.bar(
            x - width/2,
            precision_values, 
            width, 
            label='Precisione', 
            color='#10b981', 
            edgecolor='black'
        )

        rects2 = ax.bar(
            x + width/2,
            recall_values, 
            width, 
            label='Recall', 
            color='#3b82f6', 
            edgecolor='black'
        )

        ax.set_ylabel('Valore (0.0 - 1.0)')
        ax.set_title('Precisione e Recall per Azione del Dominio Completo')
        ax.set_xticks(x)
        ax.set_xticklabels(actions, rotation=45, ha="right")
        ax.legend()
        
        ax.set_ylim(0, 1.1)

        for rects in [rects1, rects2]:
            for rect in rects:
                height = rect.get_height()
                ax.annotate(
                    f'{height:.2f}',
                    xy=(rect.get_x() + rect.get_width() / 2, height),
                    xytext=(0, 3),
                    textcoords='offset points',
                    ha='center',
                    fontsize=8
                )

        fig.tight_layout()
        fig.patch.set_edgecolor('black')
        fig.patch.set_linewidth(2)
        plt.show()



