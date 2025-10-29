(define (problem garden-task)
  (:domain gardenworld)

  (:objects
    g1 - gardener
    watering-can scissors basket - tool
    rose tulip apple-tree - plant
  )

  (:init
    (dry rose)
    (grown tulip)
    (has-fruit apple-tree)
    (free-hands g1)
  )

  (:goal
    (and
      (watered rose)
      (has-fruit tulip)
      (harvested apple-tree)
    )
  )
)
