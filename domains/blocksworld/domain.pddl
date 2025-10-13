(define (domain blocksworld)
  (:requirements :strips :typing)
  (:types block table - object)
  (:predicates (on ?x - block ?y - object)
               (clear ?x - block)
               (arm-empty)
               (holding ?x - block)
               )
  (:action pick-up
             :parameters (?ob1 - block ?t - table)
             :precondition (and (clear ?ob1) (on ?ob1 ?t) (arm-empty))
             :effect
             (and (not (on ?ob1 ?t))
                   (not (clear ?ob1))
                   (not (arm-empty))
                   (holding ?ob1)))
  (:action put-down
             :parameters (?ob - block ?t - table)
             :precondition (holding ?ob)
             :effect
             (and (not (holding ?ob))
                   (clear ?ob)
                   (arm-empty)
                   (on ?ob ?t)))
  (:action stack
             :parameters (?sob - block ?sunderob - block)
             :precondition (and (holding ?sob) (clear ?sunderob))
             :effect
             (and (not (holding ?sob))
                   (not (clear ?sunderob))
                   (clear ?sob)
                   (arm-empty)
                   (on ?sob ?sunderob)))
  (:action unstack
             :parameters (?sob - block ?sunderob - block)
             :precondition (and (on ?sob ?sunderob) (clear ?sob) (arm-empty))
             :effect
             (and (holding ?sob)
                   (clear ?sunderob)
                   (not (clear ?sob))
                   (not (arm-empty))
                   (not (on ?sob ?sunderob)))))
