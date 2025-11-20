(define (problem zenotravel-01)
    (:domain zeno-travel)

    (:objects
        A1 A2 - aircraft
        P1 P2 P3 P4 P5 P6 - person 
        CA CB CC CD CE CF - city 
        L0 L1 L2 L3 L4 L5 L6 L7 L8 - flevel 
    )

    (:init
        (next L0 L1)
        (next L1 L2)
        (next L2 L3)
        (next L3 L4)
        (next L4 L5)
        (next L5 L6)
        (next L6 L7)
        (next L7 L8)
        
        (route-fly CA CB)
        (route-fly CB CC)
        (route-fly CD CE)
        (route-fly CF CA)
        
        (route-zoom CC CD)
        (route-zoom CE CF) 
        
        (at-aircraft A1 CA) 
        (fuel-level A1 L1)
        
        (at-aircraft A2 CD)
        (fuel-level A2 L5) 

        (at-person P1 CA)
        (at-person P2 CA)
        (at-person P3 CB)
        (at-person P4 CC)
        (at-person P5 CF)
        (at-person P6 CF)
        
        (at-person P1 CA)
        (at-person P2 CA)
        (at-person P3 CB)
        (at-person P4 CC)
        (at-person P5 CF)
        (at-person P6 CF)
    )

    (:goal
        (and
            (at-person P1 CD)
            (at-person P2 CD)
            (at-person P3 CD)
            (at-person P4 CD)
            (at-person P5 CD)
            (at-person P6 CD)
            
            (at-aircraft A1 CC)
            (fuel-level A1 L8)
            
            (fuel-level A2 L0)
        )
    )
)