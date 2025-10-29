(define (problem grocery00)
    (:domain grocery)
    
    (:objects
        clerk1 - agent
        apple1 apple2 carrot1 potato1 tomato1 - product_item
        fruit-sec veg-sec scale-sec - compartment
        main-scale - scale
    )
    
    (:init
        (at clerk1 fruit-sec)
        
        (connected fruit-sec veg-sec)
        (connected veg-sec fruit-sec)
        (connected veg-sec scale-sec)
        (connected scale-sec veg-sec)
        
        (scale-at main-scale scale-sec)
        
        (has-product fruit-sec apple1)
        (has-product fruit-sec apple2)
        (has-product veg-sec carrot1)
        (has-product veg-sec potato1) 
        (has-product veg-sec tomato1) 

        (left-hand-free clerk1)
        (right-hand-free clerk1)
    )
    
    (:goal 
        (and
            (ready-to-weigh apple1)
            (ready-to-weigh apple2)
            (ready-to-weigh carrot1)
            (ready-to-weigh potato1)
            (holding-left clerk1 tomato1)
        )
    )
)