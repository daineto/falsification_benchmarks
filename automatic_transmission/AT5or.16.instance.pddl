(define (problem problem_name) (:domain AT)

(:objects

	;gear1 gear2 gear3 gear4 - gear
	cdp1 cdp2 cdp3 cdp4 cdp5 cdp6 cdp7 cdp8 cdp9 cdp10 cdp11 cdp12 cdp13 cdp14 cdp15 cdp16 cdp17 cdp18 cdp19 cdp20 cdp21 cdp22 - converterDataPoint
	etp1 etp2 etp3 etp4 etp5 etp6 etp7 etp8 etp9 etp10 - engineThrottlePoint
	erp1 erp2 erp3 erp4 erp5 erp6 erp7 erp8 erp9 erp10 erp11 - engineRPMPoint
	utp1 utp2 utp3 utp4 utp5 utp6 - upThresholdPoint
	dtp1 dtp2 dtp3 dtp4 dtp5 dtp6 - downThresholdPoint

)

(:init

	(premonitor gear1)
	(premonitor gear2)
	(premonitor gear3)
	(premonitor gear4)
	
	(= (Brake) 162.5)
	(= (Throttle) 50)
	(= (input_splits) 16) ; SOLVED (2,40) (2,50)
	(adaptive)
	
    (= (WheelSpeed) 0)
	(= (RPM) 1000)
	(steady)
	(currentGear gear1)
	(currentThrottleInterval etp1)
	(currentRPMInterval erp1)
	(currentUpThresholdInterval utp1)
	(currentDownThresholdInterval dtp1)

	(nextGear gear1 gear2)
	(nextGear gear2 gear3)
	(nextGear gear3 gear4)

	(converterDataInterval cdp1 cdp2)
	(converterDataInterval cdp2 cdp3)
	(converterDataInterval cdp3 cdp4)
	(converterDataInterval cdp4 cdp5)
	(converterDataInterval cdp5 cdp6)
	(converterDataInterval cdp6 cdp7)
	(converterDataInterval cdp7 cdp8)
	(converterDataInterval cdp8 cdp9)
	(converterDataInterval cdp9 cdp10)
	(converterDataInterval cdp10 cdp11)
	(converterDataInterval cdp11 cdp12)
	(converterDataInterval cdp12 cdp13)
	(converterDataInterval cdp13 cdp14)
	(converterDataInterval cdp14 cdp15)
	(converterDataInterval cdp15 cdp16)
	(converterDataInterval cdp16 cdp17)
	(converterDataInterval cdp17 cdp18)
	(converterDataInterval cdp18 cdp19)
	(converterDataInterval cdp19 cdp20)
	(converterDataInterval cdp20 cdp21)
	(converterDataInterval cdp21 cdp22)

	(engineThrottleInterval etp1 etp2)
	(engineThrottleInterval etp2 etp3)
	(engineThrottleInterval etp3 etp4)
	(engineThrottleInterval etp4 etp5)
	(engineThrottleInterval etp5 etp6)
	(engineThrottleInterval etp6 etp7)
	(engineThrottleInterval etp7 etp8)
	(engineThrottleInterval etp8 etp9)
	(engineThrottleInterval etp9 etp10)

	(engineRPMInterval erp1 erp2)
	(engineRPMInterval erp2 erp3)
	(engineRPMInterval erp3 erp4)
	(engineRPMInterval erp4 erp5)
	(engineRPMInterval erp5 erp6)
	(engineRPMInterval erp6 erp7)
	(engineRPMInterval erp7 erp8)
	(engineRPMInterval erp8 erp9)
	(engineRPMInterval erp9 erp10)
	(engineRPMInterval erp10 erp11)

	(upThresholdInterval utp1 utp2)
	(upThresholdInterval utp2 utp3)
	(upThresholdInterval utp3 utp4)
	(upThresholdInterval utp4 utp5)
	(upThresholdInterval utp5 utp6)

	(downThresholdInterval dtp1 dtp2)
	(downThresholdInterval dtp2 dtp3)
	(downThresholdInterval dtp3 dtp4)
	(downThresholdInterval dtp4 dtp5)
	(downThresholdInterval dtp5 dtp6)

	(= (running_time) 0)
	(= (shift_clock) 0)

	; [2.393 1.450 1.000 0.677]
	(= (TransmissionGearRatio gear1) 2.393)
	(= (TransmissionGearRatio gear2) 1.450)
	(= (TransmissionGearRatio gear3) 1.000)
	(= (TransmissionGearRatio gear4) 0.677)

	;;;; CONVERTER DATA

	(= (SpeedRatio cdp1) 0)
	(= (FactorK cdp1) 137.4652089938063)
	(= (TorqueRatio cdp1) 2.2319999999999998)

	(= (SpeedRatio cdp2) 0.1)
	(= (FactorK cdp2) 137.06501915685197)
	(= (TorqueRatio cdp2) 2.075)

	(= (SpeedRatio cdp3) 0.2)
	(= (FactorK cdp3) 135.86444964598905)
	(= (TorqueRatio cdp3) 1.975)

	(= (SpeedRatio cdp4) 0.30000000000000004)
	(= (FactorK cdp4) 135.66435472751189)
	(= (TorqueRatio cdp4) 1.8459999999999999)

	(= (SpeedRatio cdp5) 0.4)
	(= (FactorK cdp5) 137.56525645304487)
	(= (TorqueRatio cdp5) 1.72)

	(= (SpeedRatio cdp6) 0.5)
	(= (FactorK cdp6) 140.36658531172509)
	(= (TorqueRatio cdp6) 1.564)

	(= (SpeedRatio cdp7) 0.60000000000000009 )
	(= (FactorK cdp7) 145.26891081441539)
	(= (TorqueRatio cdp7) 1.409)

	(= (SpeedRatio cdp8) 0.70000000000000007 )
	(= (FactorK cdp8) 152.87251771654735)
	(= (TorqueRatio cdp8) 1.254)

	(= (SpeedRatio cdp9) 0.8 )
	(= (FactorK cdp9) 162.97731109964374)
	(= (TorqueRatio cdp9) 1.0959999999999999)

	(= (SpeedRatio cdp10) 0.81 )
	(= (FactorK cdp10) 164.2779280697452)
	(= (TorqueRatio cdp10) 1.08)

	(= (SpeedRatio cdp11) 0.82000000000000006 )
	(= (FactorK cdp11) 166.17882979527823)
	(= (TorqueRatio cdp11) 1.061)

	(= (SpeedRatio cdp12) 0.83000000000000007 )
	(= (FactorK cdp12) 167.97968406157264)
	(= (TorqueRatio cdp12) 1.043)

	(= (SpeedRatio cdp13) 0.84 )
	(= (FactorK cdp13) 170.08068070558275)
	(= (TorqueRatio cdp13) 1.028)

	(= (SpeedRatio cdp14) 0.85 )
	(= (FactorK cdp14) 172.78196210502438)
	(= (TorqueRatio cdp14) 1.012)

	(= (SpeedRatio cdp15) 0.86 )
	(= (FactorK cdp15) 175.38319604522741)
	(= (TorqueRatio cdp15) 1.002)

	(= (SpeedRatio cdp16) 0.87 )
	(= (FactorK cdp16) 179.58518933324765)
	(= (TorqueRatio cdp16) 1.002)

	(= (SpeedRatio cdp17) 0.88 )
	(= (FactorK cdp17) 183.58708770279083)
	(= (TorqueRatio cdp17) 1.001)

	(= (SpeedRatio cdp18) 0.89 )
	(= (FactorK cdp18) 189.89007763482121)
	(= (TorqueRatio cdp18) 0.998)

	(= (SpeedRatio cdp19) 0.9 )
	(= (FactorK cdp19) 197.69377945543027)
	(= (TorqueRatio cdp19) 0.99900000000000011)

	(= (SpeedRatio cdp20) 0.92)
	(= (FactorK cdp20) 215.90241703685155)
	(= (TorqueRatio cdp20) 1.001)

	(= (SpeedRatio cdp21) 0.94 )
	(= (FactorK cdp21) 244.51599037908485 )
	(= (TorqueRatio cdp21) 1.002)

	(= (SpeedRatio cdp22)  2)
	(= (FactorK cdp22) 1761.035377517 )
	(= (TorqueRatio cdp22) 1.055)

	
	;;; ENGINE THROTTLE
	(= (EngineThrottle etp1) 0)
	(= (EngineThrottle etp2) 20)
	(= (EngineThrottle etp3) 30)
	(= (EngineThrottle etp4) 40)
	(= (EngineThrottle etp5) 50)
	(= (EngineThrottle etp6) 60)
	(= (EngineThrottle etp7) 70)
	(= (EngineThrottle etp8) 80)
	(= (EngineThrottle etp9) 90)
	(= (EngineThrottle etp10) 100.001)

	;;; ENGINE RPM
	(= (EngineRPM erp1) 799.99999999999989)
	(= (EngineRPM erp2) 1200)
	(= (EngineRPM erp3) 1599.9999999999998)
	(= (EngineRPM erp4) 1999.9999999999998)
	(= (EngineRPM erp5) 2400)
	(= (EngineRPM erp6) 2800.0000000000005)
	(= (EngineRPM erp7) 3199.9999999999995)
	(= (EngineRPM erp8) 3599.9999999999995)
	(= (EngineRPM erp9) 3999.9999999999995)
	(= (EngineRPM erp10) 4400)
	(= (EngineRPM erp11) 4800)


	;;; ENGINE TORQUE 10x11 matrix
	; (1, 1:11): -40 -44 -49 -53 -57 -61 -65 -70 -74 -78 -82
	(= (EngineTorque etp1 erp1) -40)
	(= (EngineTorque etp1 erp2) -44)
	(= (EngineTorque etp1 erp3) -49)
	(= (EngineTorque etp1 erp4) -53)
	(= (EngineTorque etp1 erp5) -57)
	(= (EngineTorque etp1 erp6) -61)
	(= (EngineTorque etp1 erp7) -65)
	(= (EngineTorque etp1 erp8) -70)
	(= (EngineTorque etp1 erp9) -74)
	(= (EngineTorque etp1 erp10) -78)
	(= (EngineTorque etp1 erp11) -82)

	; (2, 1:11): 215 117 85 66 44 29 10 -2 -13 -22 -32
	(= (EngineTorque etp2 erp1) 215)
	(= (EngineTorque etp2 erp2) 117)
	(= (EngineTorque etp2 erp3) 85)
	(= (EngineTorque etp2 erp4) 66)
	(= (EngineTorque etp2 erp5) 44)
	(= (EngineTorque etp2 erp6) 29)
	(= (EngineTorque etp2 erp7) 10)
	(= (EngineTorque etp2 erp8) -2)
	(= (EngineTorque etp2 erp9) -13)
	(= (EngineTorque etp2 erp10) -22)
	(= (EngineTorque etp2 erp11) -32)

	; (3, 1:11): 245 208 178 148 122 104 85 66 48 33 18
	(= (EngineTorque etp3 erp1) 245)
	(= (EngineTorque etp3 erp2) 208)
	(= (EngineTorque etp3 erp3) 178)
	(= (EngineTorque etp3 erp4) 148)
	(= (EngineTorque etp3 erp5) 122)
	(= (EngineTorque etp3 erp6) 104)
	(= (EngineTorque etp3 erp7) 85)
	(= (EngineTorque etp3 erp8) 66)
	(= (EngineTorque etp3 erp9) 48)
	(= (EngineTorque etp3 erp10) 33)
	(= (EngineTorque etp3 erp11) 18)

	; (4, 1:11): 264 260 241 219 193 167 152 133 119 96 85
	(= (EngineTorque etp4 erp1) 264)
	(= (EngineTorque etp4 erp2) 260)
	(= (EngineTorque etp4 erp3) 241)
	(= (EngineTorque etp4 erp4) 219)
	(= (EngineTorque etp4 erp5) 193)
	(= (EngineTorque etp4 erp6) 167)
	(= (EngineTorque etp4 erp7) 152)
	(= (EngineTorque etp4 erp8) 133)
	(= (EngineTorque etp4 erp9) 119)
	(= (EngineTorque etp4 erp10) 96)
	(= (EngineTorque etp4 erp11) 85)

	; (5, 1:11): 264 279 282 275 260 238 223 208 189 171 152
	(= (EngineTorque etp5 erp1) 264)
	(= (EngineTorque etp5 erp2) 279)
	(= (EngineTorque etp5 erp3) 282)
	(= (EngineTorque etp5 erp4) 275)
	(= (EngineTorque etp5 erp5) 260)
	(= (EngineTorque etp5 erp6) 238)
	(= (EngineTorque etp5 erp7) 223)
	(= (EngineTorque etp5 erp8) 208)
	(= (EngineTorque etp5 erp9) 189)
	(= (EngineTorque etp5 erp10) 171)
	(= (EngineTorque etp5 erp11) 152)

	; (6, 1:11): 267 290 293 297 290 275 260 256 234 212 193
	(= (EngineTorque etp6 erp1) 267)
	(= (EngineTorque etp6 erp2) 290)
	(= (EngineTorque etp6 erp3) 293)
	(= (EngineTorque etp6 erp4) 297)
	(= (EngineTorque etp6 erp5) 290)
	(= (EngineTorque etp6 erp6) 275)
	(= (EngineTorque etp6 erp7) 260)
	(= (EngineTorque etp6 erp8) 256)
	(= (EngineTorque etp6 erp9) 234)
	(= (EngineTorque etp6 erp10) 212)
	(= (EngineTorque etp6 erp11) 193)

	; (7, 1:11): 267 297 305 305 305 301 293 282 267 249 226
	(= (EngineTorque etp7 erp1) 267)
	(= (EngineTorque etp7 erp2) 297)
	(= (EngineTorque etp7 erp3) 305)
	(= (EngineTorque etp7 erp4) 305)
	(= (EngineTorque etp7 erp5) 305)
	(= (EngineTorque etp7 erp6) 301)
	(= (EngineTorque etp7 erp7) 293)
	(= (EngineTorque etp7 erp8) 282)
	(= (EngineTorque etp7 erp9) 267)
	(= (EngineTorque etp7 erp10) 249)
	(= (EngineTorque etp7 erp11) 226)

	; (8, 1:11): 267 301 308 312 319 323 319 316 297 279 253
	(= (EngineTorque etp8 erp1) 267)
	(= (EngineTorque etp8 erp2) 301)
	(= (EngineTorque etp8 erp3) 308)
	(= (EngineTorque etp8 erp4) 312)
	(= (EngineTorque etp8 erp5) 319)
	(= (EngineTorque etp8 erp6) 323)
	(= (EngineTorque etp8 erp7) 319)
	(= (EngineTorque etp8 erp8) 316)
	(= (EngineTorque etp8 erp9) 297)
	(= (EngineTorque etp8 erp10) 279)
	(= (EngineTorque etp8 erp11) 253)

	; (9, 1:11): 267 301 312 319 327 327 327 327 312 293 267
	(= (EngineTorque etp9 erp1) 267)
	(= (EngineTorque etp9 erp2) 301)
	(= (EngineTorque etp9 erp3) 312)
	(= (EngineTorque etp9 erp4) 319)
	(= (EngineTorque etp9 erp5) 327)
	(= (EngineTorque etp9 erp6) 327)
	(= (EngineTorque etp9 erp7) 327)
	(= (EngineTorque etp9 erp8) 327)
	(= (EngineTorque etp9 erp9) 312)
	(= (EngineTorque etp9 erp10) 293)
	(= (EngineTorque etp9 erp11) 267)

	; (10, 1:11): 267 301 312 319 327 334 334 334 319 305 275
	(= (EngineTorque etp10 erp1) 267)
	(= (EngineTorque etp10 erp2) 301)
	(= (EngineTorque etp10 erp3) 312)
	(= (EngineTorque etp10 erp4) 319)
	(= (EngineTorque etp10 erp5) 327)
	(= (EngineTorque etp10 erp6) 334)
	(= (EngineTorque etp10 erp7) 334)
	(= (EngineTorque etp10 erp8) 334)
	(= (EngineTorque etp10 erp9) 319)
	(= (EngineTorque etp10 erp10) 305)
	(= (EngineTorque etp10 erp11) 275)


	;;; SHIFT LOGIC

	; Upshifting
	; [0;25;35;50;90;100]
	(= (UpThresholdThrottle utp1) 0)
	(= (UpThresholdThrottle utp2) 25)
	(= (UpThresholdThrottle utp3) 35)
	(= (UpThresholdThrottle utp4) 50)
	(= (UpThresholdThrottle utp5) 90)
	(= (UpThresholdThrottle utp6) 100.001)

	; 10 30 50 1.0E+6
	(= (UpThreshold utp1 gear1) 10)
	(= (UpThreshold utp1 gear2) 30)
	(= (UpThreshold utp1 gear3) 50)
	(= (UpThreshold utp1 gear4) 1000000)

	;10 30 50 1.0E+6
	(= (UpThreshold utp2 gear1) 10)
	(= (UpThreshold utp2 gear2) 30)
	(= (UpThreshold utp2 gear3) 50)
	(= (UpThreshold utp2 gear4) 1000000)

	;15 30 50 1.0E+6
	(= (UpThreshold utp3 gear1) 15)
	(= (UpThreshold utp3 gear2) 30)
	(= (UpThreshold utp3 gear3) 50)
	(= (UpThreshold utp3 gear4) 1000000)

	;23 41 60 1.0E+6
	(= (UpThreshold utp4 gear1) 23)
	(= (UpThreshold utp4 gear2) 41)
	(= (UpThreshold utp4 gear3) 60)
	(= (UpThreshold utp4 gear4) 1000000)

	;40 70 100 1.0E+6
	(= (UpThreshold utp5 gear1) 40)
	(= (UpThreshold utp5 gear2) 70)
	(= (UpThreshold utp5 gear3) 100)
	(= (UpThreshold utp5 gear4) 1000000)

	;40 70 100 1.0E+6
	(= (UpThreshold utp6 gear1) 40)
	(= (UpThreshold utp6 gear2) 70)
	(= (UpThreshold utp6 gear3) 100)
	(= (UpThreshold utp6 gear4) 1000000)


	; Downshifting
	;[0;5;40;50;90;100]
	(= (DownThresholdThrottle dtp1) 0)
	(= (DownThresholdThrottle dtp2) 5)
	(= (DownThresholdThrottle dtp3) 40)
	(= (DownThresholdThrottle dtp4) 50)
	(= (DownThresholdThrottle dtp5) 90)
	(= (DownThresholdThrottle dtp6) 100.001)

	; 0 5 20 35
	(= (DownThreshold dtp1 gear1) 0)
	(= (DownThreshold dtp1 gear2) 5)
	(= (DownThreshold dtp1 gear3) 20)
	(= (DownThreshold dtp1 gear4) 35)

	; 0 5 20 35
	(= (DownThreshold dtp2 gear1) 0)
	(= (DownThreshold dtp2 gear2) 5)
	(= (DownThreshold dtp2 gear3) 20)
	(= (DownThreshold dtp2 gear4) 35)

	; 0 5 25 40
	(= (DownThreshold dtp3 gear1) 0)
	(= (DownThreshold dtp3 gear2) 5)
	(= (DownThreshold dtp3 gear3) 25)
	(= (DownThreshold dtp3 gear4) 40)

	; 0 5 30 50
	(= (DownThreshold dtp4 gear1) 0)
	(= (DownThreshold dtp4 gear2) 5)
	(= (DownThreshold dtp4 gear3) 30)
	(= (DownThreshold dtp4 gear4) 50)

	; 0 30 50 80
	(= (DownThreshold dtp5 gear1) 0)
	(= (DownThreshold dtp5 gear2) 30)
	(= (DownThreshold dtp5 gear3) 50)
	(= (DownThreshold dtp5 gear4) 80)

	; 0 30 50 80
	(= (DownThreshold dtp6 gear1) 0)
	(= (DownThreshold dtp6 gear2) 30)
	(= (DownThreshold dtp6 gear3) 50)
	(= (DownThreshold dtp6 gear4) 80)



)

(:goal
	(and
		(<= running_time 40)
		(monitor2 gear1)
		(monitor2 gear2)
		(monitor2 gear3)
		(monitor2 gear4)
	)
)

)