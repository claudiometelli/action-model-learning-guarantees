(define (domain blocksworld)
(:requirements :typing :strips)
(:types 	block table - object
)

(:predicates (on ?x - block ?y - object)
	(clear ?x - block)
	(arm-empty )
	(holding ?x - block)
)

(:action pick-up_0
	:parameters   (?ob1 - block ?t - table)
	:precondition (or (and (arm-empty )
	(on ?ob1 ?t))
	(and (clear ?ob1)
	(on ?ob1 ?t)))
	:effect       (and (holding ?ob1)
		(not (arm-empty ))
		(not (clear ?ob1))
		(not (on ?ob1 ?t)) 
		 
		))

(:action put-down_0
	:parameters   (?ob - block ?t - table)
	:precondition (or (and (holding ?ob))
	(and (not (on ?ob ?t))))
	:effect       (and (arm-empty )
		(clear ?ob)
		(not (holding ?ob))
		(on ?ob ?t) 
		 
		))

(:action stack_0
	:parameters   (?sob - block ?sunderob - block)
	:precondition (or (and (clear ?sunderob)
	(not (arm-empty )))
	(and (holding ?sob)))
	:effect       (and (arm-empty )
		(clear ?sob)
		(not (clear ?sunderob))
		(not (holding ?sob))
		(on ?sob ?sunderob) 
		 
		))

(:action stack_1
	:parameters   (?sob - block ?sunderob - block)
	:precondition (or (and (clear ?sunderob)
	(not (arm-empty )))
	(and (holding ?sob)))
	:effect       (and (arm-empty )
		(clear ?sob)
		(not (clear ?sunderob))
		(not (holding ?sob))
		(not (on ?sunderob ?sob))
		(on ?sob ?sunderob) 
		 
		))

(:action stack_2
	:parameters   (?sob - block ?sunderob - block)
	:precondition (or (and (clear ?sunderob)
	(not (arm-empty )))
	(and (holding ?sob)))
	:effect       (and (arm-empty )
		(clear ?sob)
		(not (clear ?sunderob))
		(not (holding ?sob))
		(not (holding ?sunderob))
		(on ?sob ?sunderob) 
		 
		))

(:action stack_3
	:parameters   (?sob - block ?sunderob - block)
	:precondition (or (and (clear ?sunderob)
	(not (arm-empty )))
	(and (holding ?sob)))
	:effect       (and (arm-empty )
		(clear ?sob)
		(not (clear ?sunderob))
		(not (holding ?sob))
		(not (holding ?sunderob))
		(not (on ?sunderob ?sob))
		(on ?sob ?sunderob) 
		 
		))

(:action unstack_0
	:parameters   (?sob - block ?sunderob - block)
	:precondition (or (and (arm-empty )
	(not (clear ?sunderob)))
	(and (clear ?sob)
	(not (clear ?sunderob)))
	(and (on ?sob ?sunderob)))
	:effect       (and (clear ?sunderob)
		(holding ?sob)
		(not (arm-empty ))
		(not (clear ?sob))
		(not (on ?sob ?sunderob)) 
		 
		))

(:action unstack_1
	:parameters   (?sob - block ?sunderob - block)
	:precondition (or (and (arm-empty )
	(not (clear ?sunderob)))
	(and (clear ?sob)
	(not (clear ?sunderob)))
	(and (on ?sob ?sunderob)))
	:effect       (and (clear ?sunderob)
		(holding ?sob)
		(not (arm-empty ))
		(not (clear ?sob))
		(not (on ?sob ?sunderob))
		(not (on ?sunderob ?sob)) 
		 
		))

(:action unstack_2
	:parameters   (?sob - block ?sunderob - block)
	:precondition (or (and (arm-empty )
	(not (clear ?sunderob)))
	(and (clear ?sob)
	(not (clear ?sunderob)))
	(and (on ?sob ?sunderob)))
	:effect       (and (clear ?sunderob)
		(holding ?sob)
		(not (arm-empty ))
		(not (clear ?sob))
		(not (holding ?sunderob))
		(not (on ?sob ?sunderob)) 
		 
		))

(:action unstack_3
	:parameters   (?sob - block ?sunderob - block)
	:precondition (or (and (arm-empty )
	(not (clear ?sunderob)))
	(and (clear ?sob)
	(not (clear ?sunderob)))
	(and (on ?sob ?sunderob)))
	:effect       (and (clear ?sunderob)
		(holding ?sob)
		(not (arm-empty ))
		(not (clear ?sob))
		(not (holding ?sunderob))
		(not (on ?sob ?sunderob))
		(not (on ?sunderob ?sob)) 
		 
		))

)