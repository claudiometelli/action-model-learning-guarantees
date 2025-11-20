(define (problem guaranteed-solvable-task)
    (:domain grocery)
    
    (:objects
        clerk1 clerk2 porter1 - agent
        apple1 carrot1 tomato1 potato1 milk1 bread1 cheese1 onion1 - product_item
        fruit-sec veg-sec dairy-sec scale-sec - compartment
        main-scale backup-scale - scale
    )
    
    (:init
        ; --- Posizioni Agenti (Prossimità ai compiti) ---
        (at clerk1 fruit-sec)
        (at clerk2 veg-sec)
        (at porter1 dairy-sec)
        
        ; --- Topologia (Mappa completa e chiara) ---
        (connected fruit-sec veg-sec)
        (connected veg-sec fruit-sec)
        (connected veg-sec dairy-sec)
        (connected dairy-sec veg-sec)
        (connected veg-sec scale-sec)
        (connected scale-sec veg-sec)
        
        ; --- Attrezzature ---
        (scale-at main-scale scale-sec)
        (scale-at backup-scale dairy-sec)
        
        ; --- Prodotti negli Scomparti ---
        (has-product fruit-sec apple1)
        (has-product veg-sec carrot1)
        (has-product veg-sec tomato1)
        (has-product dairy-sec potato1)
        (has-product fruit-sec milk1)
        (has-product dairy-sec bread1)
        (has-product veg-sec cheese1)
        (has-product fruit-sec onion1)

        ; --- Stato Mani (TUTTE LIBERE per evitare deadlock) ---
        (left-hand-free clerk1)
        (right-hand-free clerk1)
        (left-hand-free clerk2)
        (right-hand-free clerk2)
        (left-hand-free porter1)
        (right-hand-free porter1)
    )
    
    (:goal 
        (and
            ; 1. Obiettivo di Pesatura (Richiede movimento e bilance)
            (ready-to-weigh apple1)
            (ready-to-weigh carrot1)
            (ready-to-weigh potato1)
            
            ; 2. Obiettivo di Holding (Richiede il coordinamento tra gli agenti)
            (holding-left clerk2 onion1)
            (holding-right porter1 milk1)
            
            ; 3. Vincolo Finale: Un agente deve finire in una posizione precisa, con la mano destra libera
            (at clerk1 dairy-sec)
            (right-hand-free clerk1)
        )
    )
)