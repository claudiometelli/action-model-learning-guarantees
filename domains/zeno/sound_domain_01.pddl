(define (domain zeno-travel)
(:requirements :strips :typing)
(:types 	aircraft person city flevel - object
)

(:predicates (at-person ?p - person ?c - city)
	(at-aircraft ?a - aircraft ?c - city)
	(in ?pass - person ?plane - aircraft)
	(route-fly ?city1 - city ?city2 - city)
	(route-zoom ?city1 - city ?city2 - city)
	(fuel-level ?plane - aircraft ?level - flevel)
	(next ?level1 - flevel ?level2 - flevel)
)

(:action board
	:parameters   (?p - person ?a - aircraft ?c - city)
	:precondition (and (at-aircraft ?a ?c)
	(at-person ?p ?c)
	(not (in ?p ?a)))
	:effect       (and (in ?p ?a)
		(not (at-person ?p ?c)) 
		 
		))

(:action debark
	:parameters   (?p - person ?a - aircraft ?c - city)
	:precondition (and (at-aircraft ?a ?c)
	(in ?p ?a)
	(not (at-person ?p ?c)))
	:effect       (and (at-person ?p ?c)
		(not (in ?p ?a)) 
		 
		))

(:action fly
	:parameters   (?a - aircraft ?c1 - city ?c2 - city ?l1 - flevel ?l2 - flevel)
	:precondition (and (at-aircraft ?a ?c1)
	(fuel-level ?a ?l1)
	(next ?l2 ?l1)
	(not (at-aircraft ?a ?c2))
	(not (fuel-level ?a ?l2))
	(not (next ?l1 ?l2))
	(not (route-fly ?c2 ?c1))
	(not (route-zoom ?c1 ?c2))
	(not (route-zoom ?c2 ?c1))
	(route-fly ?c1 ?c2))
	:effect       (and (at-aircraft ?a ?c2)
		(fuel-level ?a ?l2)
		(not (at-aircraft ?a ?c1))
		(not (fuel-level ?a ?l1)) 
		 
		))

(:action zoom
	:parameters   (?a - aircraft ?c1 - city ?c2 - city ?l1 - flevel ?l2 - flevel ?l3 - flevel)
	:precondition (and (at-aircraft ?a ?c1)
	(fuel-level ?a ?l1)
	(next ?l2 ?l1)
	(next ?l3 ?l2)
	(not (at-aircraft ?a ?c2))
	(not (fuel-level ?a ?l2))
	(not (fuel-level ?a ?l3))
	(not (next ?l1 ?l2))
	(not (next ?l1 ?l3))
	(not (next ?l2 ?l3))
	(not (next ?l3 ?l1))
	(not (route-fly ?c1 ?c2))
	(not (route-fly ?c2 ?c1))
	(not (route-zoom ?c2 ?c1))
	(route-zoom ?c1 ?c2))
	:effect       (and (at-aircraft ?a ?c2)
		(fuel-level ?a ?l3)
		(not (at-aircraft ?a ?c1))
		(not (fuel-level ?a ?l1)) 
		 
		))

(:action refuel
	:parameters   (?a - aircraft ?c - city ?l - flevel ?l1 - flevel)
	:precondition (and (at-aircraft ?a ?c)
	(fuel-level ?a ?l)
	(next ?l ?l1)
	(not (fuel-level ?a ?l1))
	(not (next ?l1 ?l)))
	:effect       (and (fuel-level ?a ?l1)
		(not (fuel-level ?a ?l)) 
		 
		))

)