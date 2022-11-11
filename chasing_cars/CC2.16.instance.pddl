(define (problem problem_name) (:domain cars)

(:objects
    car1 car2 car3 car4 car5 - car
)

(:init
	; HS initial state
	(= (throttle) 0.5)
	(= (brake) 0.5)

	(= (v car1) 0)
	(= (y car1) 0)
	(run car1)

    (= (v car2) 0)
	(= (y car2) 10)
	(keeping car2)

    (= (v car3) 0)
	(= (y car3) 20)
	(keeping car3)

    (= (v car4) 0)
	(= (y car4) 30)
	(keeping car4)

    (= (v car5) 0)
	(= (y car5) 40)
	(keeping car5)

	(= (clock1) 0)
    (= (clock2) 0)

    (next car1 car2)
    (next car2 car3)
    (next car3 car4)
    (next car4 car5)

	(monitor_0)
	
	(= (input_splits) 16)

)
(:goal
	(and
		;(<= running_time horizon)
		;(<= (v car1) -5)
		;(> (- (y car5) (y car4)) 40)
		(monitor_2)
        ;(> clock1 100)
	)
)
)
