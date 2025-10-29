(define (domain blocksworld)
<<<<<<< HEAD
(:requirements :typing :strips)
=======
(:requirements :strips :typing)
>>>>>>> origin/main
(:types 	block table - object
)

(:predicates (on ?x - block ?y - object)
	(clear ?x - block)
	(arm-empty )
	(holding ?x - block)
)

(:action pick-up
	:parameters   (?ob1 - block ?t - table)
	:precondition (and (arm-empty )
	(clear ?ob1)
	(not (holding ?ob1))
	(on ?ob1 ?t))
	:effect       (and (holding ?ob1)
		(not (arm-empty ))
		(not (clear ?ob1))
		(not (on ?ob1 ?t)) 
		 
		))

(:action put-down
	:parameters   (?ob - block ?t - table)
	:precondition (and (holding ?ob)
	(not (arm-empty ))
	(not (clear ?ob))
	(not (on ?ob ?t)))
	:effect       (and (arm-empty )
		(clear ?ob)
		(not (holding ?ob))
		(on ?ob ?t) 
		 
		))

(:action stack
	:parameters   (?sob - block ?sunderob - block)
	:precondition (and (clear ?sunderob)
	(holding ?sob)
	(not (arm-empty ))
	(not (clear ?sob))
	(not (holding ?sunderob))
	(not (on ?sob ?sunderob))
	(not (on ?sunderob ?sob)))
	:effect       (and (arm-empty )
		(clear ?sob)
		(not (clear ?sunderob))
		(not (holding ?sob))
		(on ?sob ?sunderob) 
		 
		))

(:action unstack
	:parameters   (?sob - block ?sunderob - block)
	:precondition (and (arm-empty )
	(clear ?sob)
	(not (clear ?sunderob))
	(not (holding ?sob))
	(not (holding ?sunderob))
	(not (on ?sunderob ?sob))
	(on ?sob ?sunderob))
	:effect       (and (clear ?sunderob)
		(holding ?sob)
		(not (arm-empty ))
		(not (clear ?sob))
		(not (on ?sob ?sunderob)) 
		 
		))

)