(define (domain gardenworld)
(:requirements :strips :typing)
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
	:precondition (and (free-hands ?g))
	:effect       (and (holding ?g ?t)
		(not (free-hands ?g)) 
		 
		))

(:action drop-tool_0
	:parameters   (?g - gardener ?t - tool)
	:precondition (or (and (holding ?g ?t))
	(and (not (free-hands ?g))))
	:effect       (and (free-hands ?g) 
		 
		))

(:action drop-tool_1
	:parameters   (?g - gardener ?t - tool)
	:precondition (or (and (holding ?g ?t))
	(and (not (free-hands ?g))))
	:effect       (and (not (free-hands ?g)) 
		 
		))

(:action drop-tool_2
	:parameters   (?g - gardener ?t - tool)
	:precondition (or (and (holding ?g ?t))
	(and (not (free-hands ?g))))
	:effect       (and (holding ?g ?t) 
		 
		))

(:action drop-tool_3
	:parameters   (?g - gardener ?t - tool)
	:precondition (or (and (holding ?g ?t))
	(and (not (free-hands ?g))))
	:effect       (and (not (holding ?g ?t)) 
		 
		))

(:action drop-tool_4
	:parameters   (?g - gardener ?t - tool)
	:precondition (or (and (holding ?g ?t))
	(and (not (free-hands ?g))))
	:effect       (and (free-hands ?g)
		(not (free-hands ?g)) 
		 
		))

(:action drop-tool_5
	:parameters   (?g - gardener ?t - tool)
	:precondition (or (and (holding ?g ?t))
	(and (not (free-hands ?g))))
	:effect       (and (free-hands ?g)
		(holding ?g ?t) 
		 
		))

(:action drop-tool_6
	:parameters   (?g - gardener ?t - tool)
	:precondition (or (and (holding ?g ?t))
	(and (not (free-hands ?g))))
	:effect       (and (free-hands ?g)
		(not (holding ?g ?t)) 
		 
		))

(:action drop-tool_7
	:parameters   (?g - gardener ?t - tool)
	:precondition (or (and (holding ?g ?t))
	(and (not (free-hands ?g))))
	:effect       (and (holding ?g ?t)
		(not (free-hands ?g)) 
		 
		))

(:action drop-tool_8
	:parameters   (?g - gardener ?t - tool)
	:precondition (or (and (holding ?g ?t))
	(and (not (free-hands ?g))))
	:effect       (and (not (free-hands ?g))
		(not (holding ?g ?t)) 
		 
		))

(:action drop-tool_9
	:parameters   (?g - gardener ?t - tool)
	:precondition (or (and (holding ?g ?t))
	(and (not (free-hands ?g))))
	:effect       (and (holding ?g ?t)
		(not (holding ?g ?t)) 
		 
		))

(:action drop-tool_10
	:parameters   (?g - gardener ?t - tool)
	:precondition (or (and (holding ?g ?t))
	(and (not (free-hands ?g))))
	:effect       (and (free-hands ?g)
		(holding ?g ?t)
		(not (free-hands ?g)) 
		 
		))

(:action drop-tool_11
	:parameters   (?g - gardener ?t - tool)
	:precondition (or (and (holding ?g ?t))
	(and (not (free-hands ?g))))
	:effect       (and (free-hands ?g)
		(not (free-hands ?g))
		(not (holding ?g ?t)) 
		 
		))

(:action drop-tool_12
	:parameters   (?g - gardener ?t - tool)
	:precondition (or (and (holding ?g ?t))
	(and (not (free-hands ?g))))
	:effect       (and (free-hands ?g)
		(holding ?g ?t)
		(not (holding ?g ?t)) 
		 
		))

(:action drop-tool_13
	:parameters   (?g - gardener ?t - tool)
	:precondition (or (and (holding ?g ?t))
	(and (not (free-hands ?g))))
	:effect       (and (holding ?g ?t)
		(not (free-hands ?g))
		(not (holding ?g ?t)) 
		 
		))

(:action drop-tool_14
	:parameters   (?g - gardener ?t - tool)
	:precondition (or (and (holding ?g ?t))
	(and (not (free-hands ?g))))
	:effect       (and (free-hands ?g)
		(holding ?g ?t)
		(not (free-hands ?g))
		(not (holding ?g ?t)) 
		 
		))

(:action water-plant_0
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p))
	(and (holding ?g ?t))
	(and (not (free-hands ?g))
	(not (harvested ?p)))
	(and (not (harvested ?p))
	(not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(not (dry ?p))
		(watered ?p) 
		 
		))

(:action water-plant_1
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p))
	(and (holding ?g ?t))
	(and (not (free-hands ?g))
	(not (harvested ?p)))
	(and (not (harvested ?p))
	(not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(watered ?p) 
		 
		))

(:action water-plant_2
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p))
	(and (holding ?g ?t))
	(and (not (free-hands ?g))
	(not (harvested ?p)))
	(and (not (harvested ?p))
	(not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(not (dry ?p))
		(not (has-fruit ?p))
		(watered ?p) 
		 
		))

(:action water-plant_3
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p))
	(and (holding ?g ?t))
	(and (not (free-hands ?g))
	(not (harvested ?p)))
	(and (not (harvested ?p))
	(not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(not (dry ?p))
		(not (free-hands ?g))
		(watered ?p) 
		 
		))

(:action water-plant_4
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p))
	(and (holding ?g ?t))
	(and (not (free-hands ?g))
	(not (harvested ?p)))
	(and (not (harvested ?p))
	(not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(not (dry ?p))
		(not (harvested ?p))
		(watered ?p) 
		 
		))

(:action water-plant_5
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p))
	(and (holding ?g ?t))
	(and (not (free-hands ?g))
	(not (harvested ?p)))
	(and (not (harvested ?p))
	(not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (has-fruit ?p))
		(watered ?p) 
		 
		))

(:action water-plant_6
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p))
	(and (holding ?g ?t))
	(and (not (free-hands ?g))
	(not (harvested ?p)))
	(and (not (harvested ?p))
	(not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(watered ?p) 
		 
		))

(:action water-plant_7
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p))
	(and (holding ?g ?t))
	(and (not (free-hands ?g))
	(not (harvested ?p)))
	(and (not (harvested ?p))
	(not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (harvested ?p))
		(watered ?p) 
		 
		))

(:action water-plant_8
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p))
	(and (holding ?g ?t))
	(and (not (free-hands ?g))
	(not (harvested ?p)))
	(and (not (harvested ?p))
	(not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (has-fruit ?p))
		(watered ?p) 
		 
		))

(:action water-plant_9
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p))
	(and (holding ?g ?t))
	(and (not (free-hands ?g))
	(not (harvested ?p)))
	(and (not (harvested ?p))
	(not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(not (dry ?p))
		(not (harvested ?p))
		(not (has-fruit ?p))
		(watered ?p) 
		 
		))

(:action water-plant_10
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p))
	(and (holding ?g ?t))
	(and (not (free-hands ?g))
	(not (harvested ?p)))
	(and (not (harvested ?p))
	(not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (harvested ?p))
		(watered ?p) 
		 
		))

(:action water-plant_11
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p))
	(and (holding ?g ?t))
	(and (not (free-hands ?g))
	(not (harvested ?p)))
	(and (not (harvested ?p))
	(not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (has-fruit ?p))
		(watered ?p) 
		 
		))

(:action water-plant_12
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p))
	(and (holding ?g ?t))
	(and (not (free-hands ?g))
	(not (harvested ?p)))
	(and (not (harvested ?p))
	(not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (harvested ?p))
		(not (has-fruit ?p))
		(watered ?p) 
		 
		))

(:action water-plant_13
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p))
	(and (holding ?g ?t))
	(and (not (free-hands ?g))
	(not (harvested ?p)))
	(and (not (harvested ?p))
	(not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (harvested ?p))
		(watered ?p) 
		 
		))

(:action water-plant_14
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p))
	(and (holding ?g ?t))
	(and (not (free-hands ?g))
	(not (harvested ?p)))
	(and (not (harvested ?p))
	(not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (harvested ?p))
		(not (has-fruit ?p))
		(watered ?p) 
		 
		))

(:action water-plant_15
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (dry ?p))
	(and (holding ?g ?t))
	(and (not (free-hands ?g))
	(not (harvested ?p)))
	(and (not (harvested ?p))
	(not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (harvested ?p))
		(not (has-fruit ?p))
		(watered ?p) 
		 
		))

(:action prune-plant_0
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p) 
		 
		))

(:action prune-plant_1
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(not (harvested ?p)) 
		 
		))

(:action prune-plant_2
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(not (watered ?p)) 
		 
		))

(:action prune-plant_3
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t) 
		 
		))

(:action prune-plant_4
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(not (dry ?p)) 
		 
		))

(:action prune-plant_5
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(not (free-hands ?g)) 
		 
		))

(:action prune-plant_6
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p) 
		 
		))

(:action prune-plant_7
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(not (harvested ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_8
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (harvested ?p)) 
		 
		))

(:action prune-plant_9
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(not (dry ?p))
		(not (harvested ?p)) 
		 
		))

(:action prune-plant_10
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(not (free-hands ?g))
		(not (harvested ?p)) 
		 
		))

(:action prune-plant_11
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (harvested ?p)) 
		 
		))

(:action prune-plant_12
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (watered ?p)) 
		 
		))

(:action prune-plant_13
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(not (dry ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_14
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(not (free-hands ?g))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_15
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (watered ?p)) 
		 
		))

(:action prune-plant_16
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p)) 
		 
		))

(:action prune-plant_17
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (free-hands ?g)) 
		 
		))

(:action prune-plant_18
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t) 
		 
		))

(:action prune-plant_19
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(not (dry ?p))
		(not (free-hands ?g)) 
		 
		))

(:action prune-plant_20
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (dry ?p)) 
		 
		))

(:action prune-plant_21
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (free-hands ?g)) 
		 
		))

(:action prune-plant_22
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (harvested ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_23
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(not (dry ?p))
		(not (harvested ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_24
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(not (free-hands ?g))
		(not (harvested ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_25
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (harvested ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_26
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (harvested ?p)) 
		 
		))

(:action prune-plant_27
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (free-hands ?g))
		(not (harvested ?p)) 
		 
		))

(:action prune-plant_28
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (harvested ?p)) 
		 
		))

(:action prune-plant_29
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (harvested ?p)) 
		 
		))

(:action prune-plant_30
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (dry ?p))
		(not (harvested ?p)) 
		 
		))

(:action prune-plant_31
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (free-hands ?g))
		(not (harvested ?p)) 
		 
		))

(:action prune-plant_32
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_33
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (free-hands ?g))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_34
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (watered ?p)) 
		 
		))

(:action prune-plant_35
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_36
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (dry ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_37
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (free-hands ?g))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_38
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g)) 
		 
		))

(:action prune-plant_39
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p)) 
		 
		))

(:action prune-plant_40
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (free-hands ?g)) 
		 
		))

(:action prune-plant_41
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (dry ?p))
		(not (free-hands ?g)) 
		 
		))

(:action prune-plant_42
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (harvested ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_43
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (free-hands ?g))
		(not (harvested ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_44
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (harvested ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_45
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (harvested ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_46
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (dry ?p))
		(not (harvested ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_47
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (free-hands ?g))
		(not (harvested ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_48
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (harvested ?p)) 
		 
		))

(:action prune-plant_49
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (harvested ?p)) 
		 
		))

(:action prune-plant_50
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (free-hands ?g))
		(not (harvested ?p)) 
		 
		))

(:action prune-plant_51
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (harvested ?p)) 
		 
		))

(:action prune-plant_52
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_53
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_54
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (free-hands ?g))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_55
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_56
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g)) 
		 
		))

(:action prune-plant_57
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (harvested ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_58
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (harvested ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_59
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (free-hands ?g))
		(not (harvested ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_60
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (harvested ?p))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_61
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (harvested ?p)) 
		 
		))

(:action prune-plant_62
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (watered ?p)) 
		 
		))

(:action prune-plant_63
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (grown ?p))
	(and (not (has-fruit ?p))))
	:effect       (and (grown ?p)
		(has-fruit ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (harvested ?p))
		(not (watered ?p)) 
		 
		))

(:action harvest_0
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_1
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(not (has-fruit ?p))
		(not (watered ?p)) 
		 
		))

(:action harvest_2
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(not (grown ?p))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_3
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_4
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(not (dry ?p))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_5
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(not (free-hands ?g))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_6
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(not (grown ?p))
		(not (has-fruit ?p))
		(not (watered ?p)) 
		 
		))

(:action harvest_7
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (has-fruit ?p))
		(not (watered ?p)) 
		 
		))

(:action harvest_8
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(not (dry ?p))
		(not (has-fruit ?p))
		(not (watered ?p)) 
		 
		))

(:action harvest_9
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(not (free-hands ?g))
		(not (has-fruit ?p))
		(not (watered ?p)) 
		 
		))

(:action harvest_10
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (grown ?p))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_11
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(not (dry ?p))
		(not (grown ?p))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_12
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(not (free-hands ?g))
		(not (grown ?p))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_13
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_14
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (free-hands ?g))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_15
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_16
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (grown ?p))
		(not (has-fruit ?p))
		(not (watered ?p)) 
		 
		))

(:action harvest_17
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(not (dry ?p))
		(not (grown ?p))
		(not (has-fruit ?p))
		(not (watered ?p)) 
		 
		))

(:action harvest_18
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(not (free-hands ?g))
		(not (grown ?p))
		(not (has-fruit ?p))
		(not (watered ?p)) 
		 
		))

(:action harvest_19
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (has-fruit ?p))
		(not (watered ?p)) 
		 
		))

(:action harvest_20
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (free-hands ?g))
		(not (has-fruit ?p))
		(not (watered ?p)) 
		 
		))

(:action harvest_21
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (has-fruit ?p))
		(not (watered ?p)) 
		 
		))

(:action harvest_22
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (grown ?p))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_23
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (free-hands ?g))
		(not (grown ?p))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_24
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (grown ?p))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_25
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_26
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (grown ?p))
		(not (has-fruit ?p))
		(not (watered ?p)) 
		 
		))

(:action harvest_27
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (free-hands ?g))
		(not (grown ?p))
		(not (has-fruit ?p))
		(not (watered ?p)) 
		 
		))

(:action harvest_28
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (grown ?p))
		(not (has-fruit ?p))
		(not (watered ?p)) 
		 
		))

(:action harvest_29
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (has-fruit ?p))
		(not (watered ?p)) 
		 
		))

(:action harvest_30
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (grown ?p))
		(not (has-fruit ?p)) 
		 
		))

(:action harvest_31
	:parameters   (?g - gardener ?t - tool ?p - plant)
	:precondition (or (and (has-fruit ?p))
	(and (holding ?g ?t))
	(and (not (grown ?p))))
	:effect       (and (harvested ?p)
		(holding ?g ?t)
		(not (dry ?p))
		(not (free-hands ?g))
		(not (grown ?p))
		(not (has-fruit ?p))
		(not (watered ?p)) 
		 
		))

)