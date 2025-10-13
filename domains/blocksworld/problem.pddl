(define (problem bw00)
    (:domain blocksworld)
    (:objects
        A B C - block
	    T - table
    )
    (:init
        (on c b)
        (on b a)
        (on a t)
        (clear c) 
        (arm-empty)
    )
    (:goal
        (and
            (on a b)
            (on b c)
            (on c t)
        )
    )
)