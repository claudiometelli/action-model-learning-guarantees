(define (domain grocery)
    (:requirements :strips :typing)

    (:types 
        agent product_item compartment scale - object
    )

    (:predicates 
        (at ?x - agent ?comp - compartment)
        
        (connected ?comp1 - compartment ?comp2 - compartment)
        (scale-at ?x - scale ?comp - compartment)
        (has-product ?comp - compartment ?prod - product_item)
        
        (left-hand-free ?x - agent)
        (right-hand-free ?x - agent)
        (holding-left ?x - agent ?prod - product_item)
        (holding-right ?x - agent ?prod - product_item)

        (ready-to-weigh ?p - product_item)
    )
    
    (:action move
        :parameters (?a - agent ?c1 - compartment ?c2 - compartment)
        :precondition (and
            (at ?a ?c1) 
            (connected ?c1 ?c2))
        :effect (and
            (not (at ?a ?c1)) 
            (at ?a ?c2))
    )
    
    (:action pick-up-right
        :parameters (?a - agent ?c - compartment ?p - product_item)
        :precondition (and
            (at ?a ?c)
            (has-product ?c ?p)
            (right-hand-free ?a))
        :effect (and
            (not (has-product ?c ?p))
            (not (right-hand-free ?a))
            (holding-right ?a ?p))
    )

    (:action pick-up-left
        :parameters (?a - agent ?c - compartment ?p - product_item)
        :precondition (and
            (at ?a ?c)
            (has-product ?c ?p)
            (left-hand-free ?a))
        :effect (and
            (not (has-product ?c ?p))
            (not (left-hand-free ?a))
            (holding-left ?a ?p))
    )

    (:action place-on-scale-right
        :parameters (?a - agent ?p - product_item ?c - compartment ?s - scale)
        :precondition (and
            (at ?a ?c)
            (scale-at ?s ?c)
            (holding-right ?a ?p)
        )
        :effect (and
            (right-hand-free ?a)
            (not (holding-right ?a ?p))
            (ready-to-weigh ?p)
        )
    )

    (:action place-on-scale-left
        :parameters (?a - agent ?p - product_item ?c - compartment ?s - scale)
        :precondition (and
            (at ?a ?c)
            (scale-at ?s ?c)
            (holding-left ?a ?p)
        )
        :effect (and
            (left-hand-free ?a)
            (not (holding-left ?a ?p))
            (ready-to-weigh ?p)
        )
    )

)