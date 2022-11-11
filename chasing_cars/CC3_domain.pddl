(define (domain cars)

(:types
    car - object
)

(:predicates
	;HS locations
	(run ?c - car) ; car1

	(keeping ?c - car)
	(chasing ?c - car)
    (braking ?c - car)

    (next ?c1 ?c2 -car)

	(monitor_0)
	(monitor_1)
    (monitor_2)

)

(:functions
	;HS variables
    (throttle)
    (brake)
	(v ?c - car) 
	(y ?c - car)

	;monitor variables
	(clock1)
    (clock2)

	(input_splits)

)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; HS Continuous transitions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(:process flow-run
	:parameters (?c - car)
	:precondition (and
		(run ?c)
	)
	:effect (and
		(increase (v ?c) (* #t (+ (* -1 (* brake (v ?c))) (* -1 throttle))))
        (increase (y ?c) (* #t (v ?c)))
	)
)

(:process flow-keeping
	:parameters (?c - car)
	:precondition (and
		(keeping ?c)
	)
	:effect (and
        (increase (y ?c) (* #t (* -1 (v ?c))))
	)
)

(:process flow-chasing
	:parameters (?c - car)
	:precondition (and
		(chasing ?c)
	)
	:effect (and
		(increase (v ?c) (* #t 1))
        (increase (y ?c) (* #t (* -1 (v ?c))))
	)
)

(:process flow-braking
	:parameters (?c - car)
	:precondition (and
		(braking ?c)
	)
	:effect (and
		(increase (v ?c) (* #t (* -1 (v ?c))))
        (increase (y ?c) (* #t (* -1 (v ?c))))
	)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; HS Discrete transitions
;;;;;;;;;;;;;;;;;;;;;;;;;;;

(:event keeping_to_chasing
	:parameters (?c ?ahead - car) 
	:precondition (and
        (next ?ahead ?c)
		(keeping ?c)
		(>= (- (y ?c) (y ?ahead)) 15)
	)
	:effect (and
		(not (keeping ?c))
		(chasing ?c)
	)
)

(:event chasing_to_keeping
	:parameters (?c ?ahead - car) 
	:precondition (and
        (next ?ahead ?c)
		(chasing ?c)
		(<= (- (y ?c) (y ?ahead)) 10)
	)
	:effect (and
		(not (chasing ?c))
		(keeping ?c)
	)
)

(:event keeping_to_braking
	:parameters (?c ?ahead - car) 
	:precondition (and
        (next ?ahead ?c)
		(keeping ?c)
		(<= (- (y ?c) (y ?ahead)) 5)
	)
	:effect (and
		(not (keeping ?c))
		(braking ?c)
	)
)

(:event braking_to_chasing
	:parameters (?c ?ahead - car) 
	:precondition (and
        (next ?ahead ?c)
		(braking ?c)
		(>= (- (y ?c) (y ?ahead)) 20)
	)
	:effect (and
		(not (braking ?c))
		(chasing ?c)
	)
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Decisions
;;;;;;;;;;;;;;;;;;;;;;;;;;;

(:action increase_throttle 
	:parameters ()
	:precondition (and 
		(< (throttle) 1)
	)
	:effect (and 
		(increase (throttle) (/ 1 (input_splits)))
	)
)

(:action decrease_throttle  
	:parameters ()
	:precondition (and 
		(> (throttle) 0)
	)
	:effect (and 
		(decrease (throttle) (/ 1 (input_splits)))
	)
)

(:action increase_brake
	:parameters ()
	:precondition (and 
		(< (brake) 1)
	)
	:effect (and 
		(increase (brake) (/ 1 (input_splits)))
	)
)

(:action decrease_brake
	:parameters ()
	:precondition (and 
		(> (brake) 0)
	)
	:effect (and 
		(decrease (brake) (/ 1 (input_splits)))
	)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Monitor Continuous transitions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(:process flow-monitor_0
	:parameters ()
	:precondition (and
		(monitor_0)
	)
	:effect (and
		(increase (clock1) (* #t 1.0))
	)
)

(:process flow-monitor_1
	:parameters ()
	:precondition (and
		(monitor_1)
	)
	:effect (and
		(increase (clock1) (* #t 1.0))
        (increase (clock2) (* #t 1.0))
	)
)

(:event t_m0_m1
	:parameters ()
	:precondition (and
		(monitor_0)
		(<= clock1 80)
        (> (- (y car2) (y car1)) 20) 
		(< (- (y car5) (y car4)) 40)
	)
	:effect (and
		(not (monitor_0))
		(monitor_1)
        (assign (clock2) 0)
	)
)

(:event t_m1_m0
	:parameters ()
	:precondition (and
		(monitor_1)
		(< clock2 20)
		(>= (- (y car5) (y car4)) 40)
	)
	:effect (and
		(not (monitor_1))
		(monitor_0)
	)
)

(:event t_m1_m2
	:parameters ()
	:precondition (and
		(monitor_1)
		(>= clock2 20)
	)
	:effect (and
		(not (monitor_1))
		(monitor_2)
	)
)



)
