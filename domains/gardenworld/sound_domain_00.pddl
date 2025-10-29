(define (domain gardenworld)
(:requirements :typing :strips)
(:types 	plant tool gardener - object
)

(:predicates (dry ?p - plant)
	(grown ?p - plant)
	(has-fruit ?p - plant)
	(watered ?p - plant)
	(harvested ?p - plant)
	(holding ?g - gardener ?t - tool)
	(free-hands ?g - gardener)
)

(:action take-tool
	:parameters   (?g - gardener ?t - tool)
	:precondition (and (free-hands ?g)
	(not (holding ?g ?t)))
	:effect       (and (holding ?g ?t)
		(not (free-hands ?g)) 
		 
		))

(:action drop-tool
	:parameters   (?g - gardener ?t - tool)
	:precondition (and (free-hands ?g)
	(holding ?g ?t)
	(not (free-hands ?g))
	(not (holding ?g ?t)))
	:effect       (and  
		 
		))

(:action water-plant
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (dry ?p)
	(holding ?g ?t)
	(not (free-hands ?g))
	(not (grown ?p))
	(not (harvested ?p))
	(not (has-fruit ?p))
	(not (watered ?p)))
	:effect       (and (grown ?p)
		(not (dry ?p))
		(watered ?p) 
		 
		))

(:action prune-plant
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (grown ?p)
	(holding ?g ?t)
	(not (dry ?p))
	(not (free-hands ?g))
	(not (harvested ?p))
	(not (has-fruit ?p))
	(not (watered ?p)))
	:effect       (and (has-fruit ?p) 
		 
		))

(:action harvest
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (has-fruit ?p)
	(holding ?g ?t)
	(not (dry ?p))
	(not (free-hands ?g))
	(not (grown ?p))
	(not (harvested ?p))
	(not (watered ?p)))
	:effect       (and (harvested ?p)
		(not (has-fruit ?p)) 
		 
		))

)