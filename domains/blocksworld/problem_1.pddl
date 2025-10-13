(define
    (problem bw00)
    (:domain blocksworld)

    (:objects A B C)

    (:init
        (arm-empty)
        (on-table A)
        (on B A)
        (on C B)
        (clear C)
    )

    (:goal
        (and
            (on A B)
            (on B C)
            (on-table C)
        )
    )
)