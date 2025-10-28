(define (domain robot-delivery)
  (:requirements :strips :typing)

  (:types
      package table - object
  )

  (:predicates
    (on ?p - package ?o - object)
    (clear ?p - package)
    (robot-empty)
    (holding ?p - package)
  )

  (:action pick-up
    :parameters (?pkg - package ?t - table)
    :precondition (and (clear ?pkg) (on ?pkg ?t) (robot-empty))
    :effect (and
             (not (on ?pkg ?t))
             (not (clear ?pkg))
             (not (robot-empty))
             (holding ?pkg))
  )

  (:action put-down
    :parameters (?pkg - package ?t - table)
    :precondition (holding ?pkg)
    :effect (and
             (not (holding ?pkg))
             (clear ?pkg)
             (robot-empty)
             (on ?pkg ?t))
  )

  (:action stack
    :parameters (?pkg - package ?underpkg - package)
    :precondition (and (holding ?pkg) (clear ?underpkg))
    :effect (and
             (not (holding ?pkg))
             (not (clear ?underpkg))
             (clear ?pkg)
             (robot-empty)
             (on ?pkg ?underpkg))
  )

  (:action unstack
    :parameters (?pkg - package ?underpkg - package)
    :precondition (and (on ?pkg ?underpkg) (clear ?pkg) (robot-empty))
    :effect (and
             (holding ?pkg)
             (clear ?underpkg)
             (not (clear ?pkg))
             (not (robot-empty))
             (not (on ?pkg ?underpkg)))
  )
)
