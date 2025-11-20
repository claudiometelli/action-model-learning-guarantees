(define (problem garden-task-10-7-7)
    (:domain gardenworld)

    (:objects
        g1 g2 g3 g4 g5 g6 g7 g8 g9 g10 - gardener
        watering-can scissors basket shovel rake hoe sprayer - tool
        rose tulip apple-tree fern sunflower orchid cactus - plant
    )

    (:init
        (free-hands g1)
        (free-hands g2)
        (free-hands g3)
        (free-hands g4)
        (free-hands g5)
        (holding g6 watering-can)
        (holding g7 scissors)
        (holding g8 basket)
        (holding g9 shovel)
        (holding g10 rake)
        
        (dry rose)
        (dry fern)
        (dry cactus)
        (dry sunflower)
        
        (grown tulip)
        (grown orchid)
        (grown apple-tree)
        
        (has-fruit tulip)
        (has-fruit cactus)
        
        (watered rose)
        (harvested fern)
    )

    (:goal
        (and
            (watered fern)
            (watered cactus)
            (watered sunflower)
            
            (has-fruit rose)
            (has-fruit orchid)
            (has-fruit apple-tree)
            
            (harvested tulip)
            (harvested cactus)
            
            (holding g1 hoe)
            (holding g3 sprayer)
            (free-hands g10)
        )
    )
)