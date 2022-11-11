(define (domain AT)

(:types
    gear converterDataPoint engineThrottlePoint engineRPMPoint upThresholdPoint downThresholdPoint - object 
)

(:predicates
	(upThresholdInterval ?p1 ?p2 - upThresholdPoint)
	(currentUpThresholdInterval ?p - upThresholdPoint)
	(downThresholdInterval ?p1 ?p2 - downThresholdPoint)
	(currentDownThresholdInterval ?p - downThresholdPoint)

	(engineThrottleInterval ?p1 ?p2 - engineThrottlePoint)
	(currentThrottleInterval ?p - engineThrottlePoint)
	(engineRPMInterval ?p1 ?p2 - engineRPMPoint)
	(currentRPMInterval ?p - engineRPMPoint)	

	(converterDataInterval ?p1 ?p2 - converterDataPoint)

	(nextGear ?g1 ?g2 - gear)
	(currentGear ?g - gear)

	(steady)
	(downshifting)
	(upshifting)

	(input_splits)
)

(:functions
	(Throttle)
    (Brake)
	(input_splits)

    (WheelSpeed)
	(RPM)
	

	(UpThresholdThrottle ?p - upThresholdPoint)
	(DownThresholdThrottle ?p - downThresholdPoint)
	(UpThreshold ?p - upThresholdPoint ?g - gear)
	(DownThreshold ?p - downThresholdPoint  ?g - gear)

	(EngineRPM ?p - engineRPMPoint)
	(EngineThrottle ?p - engineThrottlePoint)
	(EngineTorque ?etp - engineThrottlePoint ?erp - engineRPMPoint)

	(SpeedRatio ?p - converterDataPoint)
	(FactorK ?p - converterDataPoint)
	(TorqueRatio ?p - converterDataPoint)
	(LB_SpeedRatio)
	(UB_SpeedRatio)
	(LB_FactorK)
	(UB_FactorK)
	(LB_TorqueRatio)
	(UB_TorqueRatio)

	(TransmissionGearRatio ?g - gear)
	
	(running_time)  ;; time
	(shift_clock)
)

(:action increase_throttle
	:parameters ()
	:precondition (and 
		(< (Throttle) 100)
	)
	:effect ( and
		(increase (Throttle) (/ 100 (input_splits)))
	)
)

(:action decrease_throttle
	:parameters ()
	:precondition (and 
		(> (Throttle) 0)
	)
	:effect ( and
		(decrease (Throttle) (/ 100 (input_splits)))
	)
)

(:action increase_brake
	:parameters ()
	:precondition (and 
		(< (Brake) 325)
	)
	:effect ( and
		(increase (Brake) (/ 325 (input_splits)))
	)
)

(:action decrease_brake
	:parameters ()
	:precondition (and 
		(> (Brake) 0)
	)
	:effect ( and
		(decrease (Brake) (/ 325 (input_splits)))
	)
)



(:process flow-time
	:parameters ()
	:precondition (and
	)
	:effect (and
        (increase (running_time) (* #t 1.0))
		(increase (shift_clock) (* #t 1.0))
	)
)


; Bilinear interpolation
; f(x,y1): (/ (+ (* (f x1 y1) (- x2 x)) (* (f x2 y1) (- x x1))) (- x2 x1))
; f(x,y2): (/ (+ (* (f x1 y2) (- x2 x)) (* (f x2 y2) (- x x1))) (- x2 x1))
; f(x,y): (/ (+ (* (f x y1) (- y2 y)) (* (f x y2) (- y y1))) (- y2 y1))

(:process flow-RPM
	:parameters (?etp1 - engineThrottlePoint ?etp2 - engineThrottlePoint ?erp1 - engineRPMPoint ?erp2 - engineRPMPoint ?g - gear)
	:precondition (and
		(currentThrottleInterval ?etp1)
		(currentRPMInterval ?erp1)
		(engineThrottleInterval ?etp1 ?etp2)
		(engineRPMInterval ?erp1 ?erp2)
		(currentGear ?g)
	)
	:effect (and
		(increase (RPM) (* #t (/ (- (/ (+ (* (/ (+ (* (EngineTorque ?etp1 ?erp1) (- (EngineThrottle ?etp2) (Throttle))) (* (EngineTorque ?etp2 ?erp1) (- (Throttle) (EngineThrottle ?etp1)))) (- (EngineThrottle ?etp2) (EngineThrottle ?etp1))) (- (EngineRPM ?erp2) (RPM))) (* (/ (+ (* (EngineTorque ?etp1 ?erp2) (- (EngineThrottle ?etp2) (Throttle))) (* (EngineTorque ?etp2 ?erp2) (- (Throttle) (EngineThrottle ?etp1)))) (- (EngineThrottle ?etp2) (EngineThrottle ?etp1))) (- (RPM) (EngineRPM ?erp1)))) (- (EngineRPM ?erp2) (EngineRPM ?erp1))) (^ (/ RPM (+ LB_FactorK (* (- (/ (* (TransmissionGearRatio ?g) (* 3.23 WheelSpeed)) RPM) LB_SpeedRatio) (/ (- UB_FactorK LB_FactorK) (- UB_SpeedRatio LB_SpeedRatio))))) 2)) 0.021991488283555904)))
	)
)



; OutputTorque
;(* (* (^ (/ RPM (+ LB_FactorK (* (- (/ (* (TransmissionGearRatio ?g) (* 3.23 WheelSpeed)) RPM) LB_SpeedRatio) (/ (- UB_FactorK LB_FactorK) (- UB_SpeedRatio LB_SpeedRatio))))) 2) (+ LB_TorqueRatio (* (- (/ (* (TransmissionGearRatio ?g) (* 3.23 WheelSpeed)) RPM) LB_SpeedRatio) (/ (- UB_TorqueRatio LB_TorqueRatio) (- UB_SpeedRatio LB_SpeedRatio))))) (TransmissionGearRatio ?g))

; Linear interpolation
; (+ y0 (* (- x x0) (/ (- y1 y0) (- x1 x0))))

; SpeedRatio
; (/ (* (TransmissionGearRatio ?g) (* 3.23 WheelSpeed)) RPM)

(:process flow-WS
	:parameters (?g - gear)
	:precondition (and
		(currentGear ?g)
	)
	:effect (and
		(increase (WheelSpeed) (* #t (* 0.267071317 (* (* (^ (/ RPM (+ LB_FactorK (* (- (/ (* (TransmissionGearRatio ?g) (* 3.23 WheelSpeed)) RPM) LB_SpeedRatio) (/ (- UB_FactorK LB_FactorK) (- UB_SpeedRatio LB_SpeedRatio))))) 2) (+ LB_TorqueRatio (* (- (/ (* (TransmissionGearRatio ?g) (* 3.23 WheelSpeed)) RPM) LB_SpeedRatio) (/ (- UB_TorqueRatio LB_TorqueRatio) (- UB_SpeedRatio LB_SpeedRatio))))) (TransmissionGearRatio ?g)) )  ))
	)
)

(:process flow-WS-neg
	:parameters ()
	:precondition (and
		(< WheelSpeed 0)
	)
	:effect (and
		(decrease (WheelSpeed) (* #t (* -0.082684618  (+ Brake (+ 40 (* 0.02 (^ (* 0.071399833 WheelSpeed ) 2))))) ))
	)
)

(:process flow-WS-pos
	:parameters ()
	:precondition (and
		(> WheelSpeed 0)
	)
	:effect (and
		(decrease (WheelSpeed) (* #t (* 0.082684618 (+ Brake (+ 40 (* 0.02 (^ (* 0.071399833 WheelSpeed ) 2))))) ))
	)
)

(:event saturation
	:parameters ()
	:precondition (and
		(< (RPM) 600)
	)
	:effect (and
		(assign (RPM) 600)
	)
)


(:event update_ConverterDataInterval
	:parameters (?p1 - converterDataPoint ?p2 - converterDataPoint ?g - gear) 
	:precondition (and
        (converterDataInterval ?p1 ?p2)
		(currentGear ?g)
		(>= (/ (* (* 3.23 WheelSpeed) (TransmissionGearRatio ?g)) RPM) (SpeedRatio ?p1))
		(< (/ (* (* 3.23 WheelSpeed) (TransmissionGearRatio ?g)) RPM) (SpeedRatio ?p2))
		(not (= (SpeedRatio ?p1) LB_SpeedRatio))
	)
	:effect (and
		(assign (LB_SpeedRatio) (SpeedRatio ?p1))
		(assign (UB_SpeedRatio) (SpeedRatio ?p2))
		(assign (LB_FactorK) (FactorK ?p1))
		(assign (UB_FactorK) (FactorK ?p2))
		(assign (LB_TorqueRatio) (TorqueRatio ?p1))
		(assign (UB_TorqueRatio) (TorqueRatio ?p2))
	)
)

(:event update_EngineThrottleInterval
	:parameters (?p1 - engineThrottlePoint ?p2 - engineThrottlePoint ?pc - engineThrottlePoint) 
	:precondition (and
        (engineThrottleInterval ?p1 ?p2)
		(currentThrottleInterval ?pc)
		(not (= ?p1 ?pc))
		(>= (Throttle) (EngineThrottle ?p1))
		(< (Throttle) (EngineThrottle ?p2))
	)
	:effect (and
		(not (currentThrottleInterval ?pc))
		(currentThrottleInterval ?p1)
	)
)

(:event update_EngineRPMInterval
	:parameters (?p1 - engineRPMPoint ?p2 - engineRPMPoint ?pc - engineRPMPoint) 
	:precondition (and
        (engineRPMInterval ?p1 ?p2)
		(currentRPMInterval ?pc)
		(not (= ?p1 ?pc))
		(>= (RPM) (EngineRPM ?p1))
		(< (RPM) (EngineRPM ?p2))
	)
	:effect (and
		(not (currentRPMInterval ?pc))
		(currentRPMInterval ?p1)
	)
)


(:event update_UpThresholdInterval
	:parameters (?p1 - upThresholdPoint ?p2 - upThresholdPoint ?pc - upThresholdPoint)
	:precondition (and
        (upThresholdInterval ?p1 ?p2)
		(currentUpThresholdInterval ?pc)
		(not (= ?p1 ?pc))
		(>= (Throttle) (UpThresholdThrottle ?p1))
		(< (Throttle) (UpThresholdThrottle ?p2))
	)
	:effect (and
		(not (currentUpThresholdInterval ?pc))
		(currentUpThresholdInterval ?p1)
	)
)

(:event update_DownThresholdInterval
	:parameters (?p1 - downThresholdPoint ?p2 - downThresholdPoint ?pc - downThresholdPoint)
	:precondition (and
        (downThresholdInterval ?p1 ?p2)
		(currentDownThresholdInterval ?pc)
		(not (= ?p1 ?pc))
		(>= (Throttle) (DownThresholdThrottle ?p1))
		(< (Throttle) (DownThresholdThrottle ?p2))
	)
	:effect (and
		(not (currentDownThresholdInterval ?pc))
		(currentDownThresholdInterval ?p1)
	)
)


; Linear interpolation
; (+ y0 (* (- x x0) (/ (- y1 y0) (- x1 x0))))

(:event steady_to_upshifting
	:parameters (?p1 - upThresholdPoint ?p2 - upThresholdPoint ?g - gear)
	:precondition (and
		(steady)
		(upThresholdInterval ?p1 ?p2)
		(currentUpThresholdInterval ?p1)
		(currentGear ?g)
		(> (* 0.071399833 WheelSpeed) (+ (UpThreshold ?p1 ?g) (* (- (Throttle) (UpThresholdThrottle ?p1)) (/ (- (UpThreshold ?p2 ?g) (UpThreshold ?p1 ?g)) (- (UpThresholdThrottle ?p2) (UpThresholdThrottle ?p1))))))
	)
	:effect (and
		(not (steady))
		(upshifting)
		(assign (shift_clock) 0)
	)
)

(:event upshifting_to_steady
	:parameters (?p1 - upThresholdPoint ?p2 - upThresholdPoint ?g - gear)
	:precondition (and
		(upshifting)
		(upThresholdInterval ?p1 ?p2)
		(currentUpThresholdInterval ?p1)
		(currentGear ?g)
		(< (* 0.071399833 WheelSpeed) (+ (UpThreshold ?p1 ?g) (* (- (Throttle) (UpThresholdThrottle ?p1)) (/ (- (UpThreshold ?p2 ?g) (UpThreshold ?p1 ?g)) (- (UpThresholdThrottle ?p2) (UpThresholdThrottle ?p1))))))
	)
	:effect (and
		(not (upshifting))
		(steady)
	)
)

(:event gear_up
	:parameters (?p1 - upThresholdPoint ?p2 - upThresholdPoint ?g1 - gear ?g2 - gear)
	:precondition (and
		(upshifting)
		(upThresholdInterval ?p1 ?p2)
		(currentUpThresholdInterval ?p1)
		(currentGear ?g1)
		(nextGear ?g1 ?g2)
		(>= shift_clock 0.08)
		(>= (* 0.071399833 WheelSpeed) (+ (UpThreshold ?p1 ?g1) (* (- (Throttle) (UpThresholdThrottle ?p1)) (/ (- (UpThreshold ?p2 ?g1) (UpThreshold ?p1 ?g1)) (- (UpThresholdThrottle ?p2) (UpThresholdThrottle ?p1))))))
	)
	:effect (and
		(not (upshifting))
		(steady)
		(not (currentGear ?g1))
		(currentGear ?g2)
	)
)

(:event steady_to_downshifting
	:parameters (?p1 - downThresholdPoint ?p2 - downThresholdPoint ?g - gear)
	:precondition (and
		(steady)
		(downThresholdInterval ?p1 ?p2)
		(currentDownThresholdInterval ?p1)
		(currentGear ?g)
		(< (* 0.071399833 WheelSpeed) (+ (DownThreshold ?p1 ?g) (* (- (Throttle) (DownThresholdThrottle ?p1)) (/ (- (DownThreshold ?p2 ?g) (DownThreshold ?p1 ?g)) (- (DownThresholdThrottle ?p2) (DownThresholdThrottle ?p1))))))
	)
	:effect (and
		(not (steady))
		(downshifting)
		(assign (shift_clock) 0)
	)
)

(:event downshifting_to_steady
	:parameters (?p1 - downThresholdPoint ?p2 - downThresholdPoint ?g - gear)
	:precondition (and
		(downshifting)
		(downThresholdInterval ?p1 ?p2)
		(currentDownThresholdInterval ?p1)
		(currentGear ?g)
		(> (* 0.071399833 WheelSpeed) (+ (DownThreshold ?p1 ?g) (* (- (Throttle) (DownThresholdThrottle ?p1)) (/ (- (DownThreshold ?p2 ?g) (DownThreshold ?p1 ?g)) (- (DownThresholdThrottle ?p2) (DownThresholdThrottle ?p1))))))
	)
	:effect (and
		(not (downshifting))
		(steady)
	)
)

(:event gear_down
	:parameters (?p1 - downThresholdPoint ?p2 - downThresholdPoint ?g1 - gear ?g2 - gear)
	:precondition (and
		(downshifting)
		(downThresholdInterval ?p1 ?p2)
		(currentDownThresholdInterval ?p1)
		(currentGear ?g1)
		(nextGear ?g2 ?g1)
		(>= shift_clock 0.08)
		(<= (* 0.071399833 WheelSpeed) (+ (DownThreshold ?p1 ?g1) (* (- (Throttle) (DownThresholdThrottle ?p1)) (/ (- (DownThreshold ?p2 ?g1) (DownThreshold ?p1 ?g1)) (- (DownThresholdThrottle ?p2) (DownThresholdThrottle ?p1))))))
	)
	:effect (and
		(not (downshifting))
		(steady)
		(not (currentGear ?g1))
		(currentGear ?g2)
	)
)

)