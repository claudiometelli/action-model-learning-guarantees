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

(:action take-tool_0
	:parameters   (?g - gardener ?t - tool)
	:precondition (or (and (free-hands ?g))
	(and (not (holding ?g ?t))))
	:effect       (and (holding ?g ?t)
		(not (free-hands ?g)) 
		 
		))

(:action drop-tool_0
	:parameters   (?g - gardener ?t - tool)
	:precondition (and (holding ?g ?t))
	:effect       (and (free-hands ?g)
		(not (holding ?g ?t)) 
		 
		))

(:action water-plant_0
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p)
	(holding ?g ?t))
	(and (holding ?g ?t)
	(not (grown ?p))))
	:effect       (and (grown ?p)
		(not (dry ?p))
		(watered ?p) 
		 
		))

(:action water-plant_1
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p)
	(holding ?g ?t))
	(and (holding ?g ?t)
	(not (grown ?p))))
	:effect       (and (grown ?p)
		(not (dry ?p))
		(not (free-hands ?g))
		(watered ?p) 
		 
		))

(:action water-plant_2
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p)
	(holding ?g ?t))
	(and (holding ?g ?t)
	(not (grown ?p))))
	:effect       (and (grown ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(watered ?p) 
		 
		))

(:action water-plant_3
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p)
	(holding ?g ?t))
	(and (holding ?g ?t)
	(not (grown ?p))))
	:effect       (and (grown ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(watered ?p) 
		 
		))

(:action prune-plant_0
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (has-fruit ?p) 
		 
		))

(:action prune-plant_1
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (has-fruit ?p)
		(not (free-hands ?g)) 
		 
		))

(:action prune-plant_2
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (grown ?p)
		(has-fruit ?p) 
		 
		))

(:action prune-plant_3
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t) 
		 
		))

(:action prune-plant_4
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (has-fruit ?p)
		(not (dry ?p)) 
		 
		))

(:action prune-plant_5
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (free-hands ?g)) 
		 
		))

(:action prune-plant_6
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (free-hands ?g)) 
		 
		))

(:action prune-plant_7
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (has-fruit ?p)
		(not (dry ?p))
		(not (free-hands ?g)) 
		 
		))

(:action prune-plant_8
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t) 
		 
		))

(:action prune-plant_9
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (dry ?p)) 
		 
		))

(:action prune-plant_10
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p)) 
		 
		))

(:action prune-plant_11
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (free-hands ?g)) 
		 
		))

(:action prune-plant_12
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (dry ?p))
		(not (free-hands ?g)) 
		 
		))

(:action prune-plant_13
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g)) 
		 
		))

(:action prune-plant_14
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p)) 
		 
		))

(:action prune-plant_15
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g)) 
		 
		))

(:action harvest_0
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (harvested ?p)
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_1
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (harvested ?p)
		(not (free-hands ?g))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_2
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (grown ?p)
		(harvested ?p)
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_3
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_4
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (harvested ?p)
		(not (dry ?p))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_5
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (grown ?p)
		(harvested ?p)
		(not (free-hands ?g))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_6
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (free-hands ?g))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_7
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (harvested ?p)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_8
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (grown ?p)
		(harvested ?p)
		(holding ?g ?t)
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_9
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (grown ?p)
		(harvested ?p)
		(not (dry ?p))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_10
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_11
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (grown ?p)
		(harvested ?p)
		(holding ?g ?t)
		(not (free-hands ?g))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_12
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (grown ?p)
		(harvested ?p)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_13
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_14
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (grown ?p)
		(harvested ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_15
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (and (holding ?g ?t))
	:effect       (and (grown ?p)
		(harvested ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (has-fruit ?p)) 
		 
		))

)