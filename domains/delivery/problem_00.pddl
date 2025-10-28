(define (problem five-packages)
  (:domain robot-delivery)

  (:objects
    p1 p2 p3 p4 p5 - package
    t - table
  )

  (:init
    (on p1 t)
    (on p2 t)
    (on p3 t)
    (on p4 t)
    (on p5 t)
    (clear p1)
    (clear p2)
    (clear p3)
    (clear p4)
    (clear p5)
    (robot-empty)
  )

  (:goal (and
    (on p1 t)
    (on p2 p1)
    (on p3 p2)
    (on p4 p3)
    (on p5 p4)
    (clear p5)
  ))
)
