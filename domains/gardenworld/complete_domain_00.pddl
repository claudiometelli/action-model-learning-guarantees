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
	:precondition (and (free-hands ?g))
	:effect       (and (holding ?g ?t)
		(not (free-hands ?g)) 
		 
		))

(:action drop-tool
	:parameters   (?g - gardener ?t - tool)
	:precondition (or (and (free-hands ?g))
	(and (holding ?g ?t)))
	:effect       (and (free-hands ?g)
		(holding ?g ?t)
		(not (free-hands ?g))
		(not (holding ?g ?t)) 
		 
		))

(:action water-plant
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p))
	(and (not (grown ?p))))
	:effect       (and (grown ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (harvested ?p))
		(not (has-fruit ?p))
		(watered ?p) 
		 
		))

(:action prune-plant
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p)
	(not (free-hands ?g)))
	(and (grown ?p)
	(not (has-fruit ?p)))
	(and (grown ?p))
	(and (holding ?g ?t)
	(not (free-hands ?g)))
	(and (holding ?g ?t)
	(not (has-fruit ?p)))
	(and (holding ?g ?t))
	(and (not (dry ?p))
	(not (free-hands ?g)))
	(and (not (dry ?p))
	(not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (harvested ?p))
		(not (watered ?p)) 
		 
		))

(:action harvest
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (holding ?g ?t)
	(not (free-hands ?g)))
	(and (holding ?g ?t)))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (grown ?p))
		(not (has-fruit ?p))
		(not (watered ?p)) 
		 
		))

)