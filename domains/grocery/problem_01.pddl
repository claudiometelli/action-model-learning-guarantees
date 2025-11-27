(define (problem grocery01)
    (:domain grocery)
    
    (:objects
        clerk1 clerk2 clerk3 - agent
        apple1 apple2 apple3 carrot1 tomato1 potato1 potato2 onion1 - product_item
        fruit-sec veg-sec daily-sec scale-sec - compartment
        main-scale backup-scale - scale
    )
    
    (:init
        (at clerk1 fruit-sec)
        (at clerk2 veg-sec)
        (at clerk3 daily-sec)
        
        (connected fruit-sec veg-sec)
        (connected veg-sec fruit-sec)
        (connected veg-sec daily-sec)
        (connected daily-sec veg-sec)
        (connected veg-sec scale-sec)
        (connected scale-sec veg-sec)
        
        (scale-at main-scale scale-sec)
        (scale-at backup-scale daily-sec)
        
        (has-product fruit-sec apple1)
        (has-product fruit-sec apple2)
        (has-product fruit-sec apple3)
        (has-product veg-sec carrot1)
        (has-product veg-sec tomato1)
        (has-product veg-sec onion1)
        (has-product daily-sec potato1)
        (has-product daily-sec potato2)

        (left-hand-free clerk1)
        (right-hand-free clerk1)
        (left-hand-free clerk2)
        (right-hand-free clerk2)
        (left-hand-free clerk3)
        (right-hand-free clerk3)
    )
    
    (:goal 
        (and
            (ready-to-weigh apple1)
            (ready-to-weigh apple2)
            (ready-to-weigh carrot1)
            (ready-to-weigh tomato1)
            (ready-to-weigh potato1)
            
            (holding-left clerk1 potato2)
            (holding-left clerk2 onion1)
            (holding-right clerk3 apple3)
            
            (at clerk1 daily-sec)
            (right-hand-free clerk1)
        )
    )
)