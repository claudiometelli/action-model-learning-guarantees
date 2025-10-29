(define (domain gardenworld)
  (:requirements :strips :typing)
  (:types plant tool gardener - object)

  (:predicates
    (dry ?p - plant)
    (grown ?p - plant)
    (has-fruit ?p - plant)
    (watered ?p - plant)
    (harvested ?p - plant)
    (holding ?g - gardener ?t - tool)
    (free-hands ?g - gardener)
  )

  (:action take-tool
    :parameters (?g - gardener ?t - tool)
    :precondition (and (free-hands ?g))
    :effect (and (holding ?g ?t)
                 (not (free-hands ?g)))
  )

  (:action drop-tool
    :parameters (?g - gardener ?t - tool)
    :precondition (and (holding ?g ?t))
    :effect (and (free-hands ?g)
                 (not (holding ?g ?t)))
  )

  (:action water-plant
    :parameters (?g - gardener ?t - tool ?p - plant)
    :precondition (and (holding ?g ?t) (dry ?p))
    :effect (and (not (dry ?p))
                 (watered ?p)
                 (grown ?p))
  )

  (:action prune-plant
    :parameters (?g - gardener ?t - tool ?p - plant)
    :precondition (and (holding ?g ?t) (grown ?p))
    :effect (and (has-fruit ?p))
  )

  (:action harvest
    :parameters (?g - gardener ?t - tool ?p - plant)
    :precondition (and (holding ?g ?t) (has-fruit ?p))
    :effect (and (harvested ?p)
                 (not (has-fruit ?p)))
  )
)
