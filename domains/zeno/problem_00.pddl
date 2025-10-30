(define (problem zenotravel00)
    (:domain zeno-travel)

    (:objects
        A1 - aircraft
        P1 P2 - person
        CA CB CC - city
        L0 L1 L2 L3 L4 - flevel
    )

    (:init
        (next L0 L1)
        (next L1 L2)
        (next L2 L3)
        (next L3 L4)
        
        (route-fly CA CB)
        (route-fly CB CA)

        (route-zoom CB CC)
        (route-zoom CC CB)
        
        (at-aircraft A1 CA)
        (fuel-level A1 L3)
        
        (at-person P1 CA)
        (at-person P2 CB)
    )

    (:goal
        (and
            (at-person P1 CC)
            (at-person P2 CC)
        )
    )
)