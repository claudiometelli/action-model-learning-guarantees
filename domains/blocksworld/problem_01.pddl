(define (problem ten-blocks)
    (:domain blocksworld)
    
    (:objects
        b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 - block
        t - table
    )
    
    (:init
        (on b1 t)
        (on b2 t)
        (on b3 t)
        (on b4 t)
        (on b5 t)
        (on b6 t)
        (on b7 t)
        (on b8 t)
        (on b9 t)
        (on b10 t)
        
        (clear b1)
        (clear b2)
        (clear b3)
        (clear b4)
        (clear b5)
        (clear b6)
        (clear b7)
        (clear b8)
        (clear b9)
        (clear b10)
        
        (arm-empty)
    )
    
    (:goal (and
        (on b1 t)
        (on b2 b1)
        (on b3 b2)
        (on b4 b3)
        (on b5 b4)
        (on b6 b5)
        (on b7 b6)
        (on b8 b7)
        (on b9 b8)
        (on b10 b9)
        (clear b10)
    ))
)