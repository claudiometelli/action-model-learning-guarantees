(define (domain zeno-travel)
    (:requirements :strips :typing)
    (:types
        aircraft person city flevel - object
    )

    (:predicates
        (at-person ?p - person ?c - city)
        (at-aircraft ?a - aircraft ?c - city)
        (in ?pass - person ?plane - aircraft)

        (route-fly ?city1 - city ?city2 - city)
        (route-zoom ?city1 - city ?city2 - city)

    	(fuel-level ?plane - aircraft ?level - flevel)
    	(next ?level1 ?level2 - flevel)
    )


    (:action board
        :parameters (?p - person ?a - aircraft ?c - city)
        :precondition (and
            (at-person ?p ?c)
            (at-aircraft ?a ?c))
        :effect (and
            (not (at-person ?p ?c))
            (in ?p ?a))
    )

    (:action debark
        :parameters (?p - person ?a - aircraft ?c - city)
        :precondition (and
            (in ?p ?a)
            (at-aircraft ?a ?c))
        :effect (and
            (not (in ?p ?a))
            (at-person ?p ?c))
    )

    (:action fly 
        :parameters (?a - aircraft ?c1 ?c2 - city ?l1 ?l2 - flevel)
        :precondition (and
            (at-aircraft ?a ?c1)
            (route-fly ?c1 ?c2)
            (fuel-level ?a ?l1)
            (next ?l2 ?l1))
        :effect (and
            (not (at-aircraft ?a ?c1))
            (at-aircraft ?a ?c2)
            (not (fuel-level ?a ?l1))
            (fuel-level ?a ?l2))
    )
                                  
    (:action zoom
        :parameters (?a - aircraft ?c1 ?c2 - city ?l1 ?l2 ?l3 - flevel)
        :precondition (and
            (at-aircraft ?a ?c1)
            (route-zoom ?c1 ?c2)
            (fuel-level ?a ?l1)
            (next ?l2 ?l1)
            (next ?l3 ?l2))
        :effect (and
            (not (at-aircraft ?a ?c1))
            (at-aircraft ?a ?c2)
            (not (fuel-level ?a ?l1))
            (fuel-level ?a ?l3))
    ) 

    (:action refuel
        :parameters (?a - aircraft ?c - city ?l - flevel ?l1 - flevel)
        :precondition (and
            (fuel-level ?a ?l)
            (next ?l ?l1)
            (at-aircraft ?a ?c))
        :effect (and
            (fuel-level ?a ?l1)
            (not (fuel-level ?a ?l)))
    )

)