(define (domain grocery)
(:requirements :strips :typing)
(:types 	agent product_item compartment scale - object
)

(:predicates (at ?x - agent ?comp - compartment)
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
	:parameters   (?a - agent ?c1 - compartment ?c2 - compartment)
	:precondition (and (at ?a ?c1))
	:effect       (and (at ?a ?c2)
		(connected ?c1 ?c2)
		(connected ?c2 ?c1)
		(not (at ?a ?c1)) 
		 
		))

(:action pick-up-right
	:parameters   (?a - agent ?c - compartment ?p - product_item)
	:precondition (or (and (at ?a ?c)
	(not (ready-to-weigh ?p)))
	(and (has-product ?c ?p))
	(and (right-hand-free ?a)))
	:effect       (and (at ?a ?c)
		(holding-right ?a ?p)
		(not (has-product ?c ?p))
		(not (holding-left ?a ?p))
		(not (ready-to-weigh ?p))
		(not (right-hand-free ?a)) 
		 
		))

(:action pick-up-left
	:parameters   (?a - agent ?c - compartment ?p - product_item)
	:precondition (or (and (at ?a ?c))
	(and (has-product ?c ?p)))
	:effect       (and (at ?a ?c)
		(holding-left ?a ?p)
		(not (has-product ?c ?p))
		(not (holding-right ?a ?p))
		(not (left-hand-free ?a))
		(not (ready-to-weigh ?p)) 
		 
		))

(:action place-on-scale-right
	:parameters   (?a - agent ?p - product_item ?c - compartment ?s - scale)
	:precondition (and (holding-right ?a ?p))
	:effect       (and (at ?a ?c)
		(not (has-product ?c ?p))
		(not (holding-left ?a ?p))
		(not (holding-right ?a ?p))
		(ready-to-weigh ?p)
		(right-hand-free ?a)
		(scale-at ?s ?c) 
		 
		))

(:action place-on-scale-left
	:parameters   (?a - agent ?p - product_item ?c - compartment ?s - scale)
	:precondition (or (and (at ?a ?c)
	(not (left-hand-free ?a)))
	(and (holding-left ?a ?p))
	(and (not (has-product ?c ?p))
	(not (left-hand-free ?a))
	(not (ready-to-weigh ?p))
	(not (right-hand-free ?a)))
	(and (not (left-hand-free ?a))
	(not (ready-to-weigh ?p))
	(not (right-hand-free ?a))
	(scale-at ?s ?c)))
	:effect       (and (at ?a ?c)
		(left-hand-free ?a)
		(not (has-product ?c ?p))
		(not (holding-left ?a ?p))
		(not (holding-right ?a ?p))
		(not (right-hand-free ?a))
		(ready-to-weigh ?p)
		(scale-at ?s ?c) 
		 
		))

)