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

	(= (running_time) 16)

    (next car1 car2)
    (next car2 car3)
    (next car3 car4)
    (next car4 car5)

	(monitor_0 car2 car1)
	(monitor_0 car3 car2)
	(monitor_0 car4 car3)
	(monitor_0 car5 car4)

	(= (input_splits) 4)

)
(:goal
	(and
		(monitor_1 car2 car1)
		(monitor_1 car3 car2)
		(monitor_1 car4 car3)
		(monitor_1 car5 car4)
	)
)
)
