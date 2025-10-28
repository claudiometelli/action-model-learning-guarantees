(define (domain robot-delivery)
(:requirements :typing :strips)
(:types 	package table - object
)

(:predicates (on ?p - package ?o - object)
	(clear ?p - package)
	(robot-empty )
	(holding ?p - package)
)

(:action pick-up
	:parameters   (?pkg - package ?t - table)
	:precondition (and (clear ?pkg)
	(not (holding ?pkg))
	(on ?pkg ?t)
	(robot-empty ))
	:effect       (and (holding ?pkg)
		(not (clear ?pkg))
		(not (on ?pkg ?t))
		(not (robot-empty )) 
		 
		))

(:action put-down
	:parameters   (?pkg - package ?t - table)
	:precondition (and (holding ?pkg)
	(not (clear ?pkg))
	(not (on ?pkg ?t))
	(not (robot-empty )))
	:effect       (and (clear ?pkg)
		(not (holding ?pkg))
		(on ?pkg ?t)
		(robot-empty ) 
		 
		))

(:action stack
	:parameters   (?pkg - package ?underpkg - package)
	:precondition (and (clear ?underpkg)
	(holding ?pkg)
	(not (clear ?pkg))
	(not (holding ?underpkg))
	(not (on ?pkg ?underpkg))
	(not (on ?underpkg ?pkg))
	(not (robot-empty )))
	:effect       (and (clear ?pkg)
		(not (clear ?underpkg))
		(not (holding ?pkg))
		(on ?pkg ?underpkg)
		(robot-empty ) 
		 
		))

(:action unstack
	:parameters   (?pkg - package ?underpkg - package)
	:precondition (and (clear ?pkg)
	(not (clear ?underpkg))
	(not (holding ?pkg))
	(not (holding ?underpkg))
	(not (on ?underpkg ?pkg))
	(on ?pkg ?underpkg)
	(robot-empty ))
	:effect       (and (clear ?underpkg)
		(holding ?pkg)
		(not (clear ?pkg))
		(not (on ?pkg ?underpkg))
		(not (robot-empty )) 
		 
		))

)