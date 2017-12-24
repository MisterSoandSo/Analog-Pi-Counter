@Programer: Andrew So 
@Project: 	Parking lot counter with 7-segment displays and toggle switchs
@Date: 		Dec 11,2017

.equ IN,  0					//defined value of 0 for PIO read operation
.equ OUT, 1					//defined value of 1 for PIO write operation
 
.equ LOW,  0				//logical low = 0.1v or below
.equ HIGH, 1				//logical high = 1v or above

.equ PIN_12, 26				// clock pulse generator
.equ PIN_13, 23				// 7-seg reset line
.equ PIN_22, 3				// led control pin

.equ PIN_17, 0				// white toggle button - increment
.equ PIN_27, 2				// yellow toggle button - decrement

.equ PARK_CAP, 50			// car cap before red light turns on

.section .data
    number:                 .word 0     // number of pulses
    switch_P17:				.word 0		// switch condition for increment (1 - active, 0  - not active)
    switch_P27:				.word 0		// switch condition for decrement (1 - active, 0  - not active)
    status_P17:				.word 0		// meant to be a raise condition control (1 - active, 0  - not active)
    status_P27:				.word 0		// to handle various button press durration	 (1 - active, 0  - not active)					


.section .text
.global main
main:
		push {lr}				//save caller return address

		bl setup_bb				//setup pins for game input and output
		bl reset_pulse			//clear display
        
        ldr r2, =number			//seeding current display to start at 0.
        mov r1 ,#0
        str r1,[r2]            
	
		bl send_N_pulses		//display current stored/loaded number
		
	read_loop:
		bl read_pulses_pin		//read user button press conditions: on/off
		bl cap_check			//check if number < parking cap to diplay 
								//over/below capacity of a parking lot
	
		ldr r0, =switch_P17		//checking if increment counting switch is on/off
		ldr r1, [r0]		
		subs r1,r1,#0
		bne test_inc2			//yes it's on ... go to process it
	
	state_17:
		ldr r0, =status_P17		//if not on ... clear the previous button opperation
		mov r1, #0				//by setting it a non active state
		str r1, [r0]
	state_18:					//checking the decremental counting button
		ldr r0, =switch_P27
		ldr r1,[r0]
		subs r1,r1,#0
		bne test_dec1			//decrement button is active ... go to handler
		mov r1, #0				//if not active, clear the previous decrement button state
		ldr r0, =status_P27
		str r1,[r0]
		bal read_loop			//repeat main loop switch reading operation
	test_inc2:
		ldr r0, =status_P17		//handle the increment button operation
		ldr r1, [r0]
		subs r1,r1,#0		
		bne state_18			//skip the button request
		
		mov r1, #1				//otherwise new button increment is active
		str r1, [r0]			//this is to avoid the the raise condition due to
								//various button press duration
		
		ldr r0, =number 		//update display count by 1
		ldr r2, [r0]
		add r2,r2, #1
		str r2,[r0]
		bl send_N_pulses		//display current number count
		bal read_loop			//go back to main loop
	test_dec1:
		ldr r0, =status_P27		//handle decrement counting button
		ldr r1, [r0]
		subs r1,r1,#0			//if the previous button press is active
		bne read_loop			//ignore the current decrement request 
		mov r1,#1
		str r1,[r0]
		ldr r0, =number 		//otherwise decrement the counting
		ldr r2, [r0]		
		subs r2,r2,#0			//if count is already 0, then go back to main loop
		beq read_loop
		add r2,r2, #-1			//otherwise decrement the count
		str r2,[r0]
		bl send_N_pulses		//display current counting
		bal read_loop			//go back to main loop
		

	end_program:
		mov r0,#0
		pop {pc}				//exit program back to system

//-------------------------------------------------------------------
// Function: setup_bb - Setup GPIO Pins modes for the breadboard
//						setup the general state of the buttons
// Precondition:R0 and R1 are used for setup pins
// Postcondition: No Registers are preserved for return
// Other Notes: None
//-------------------------------------------------------------------
setup_bb:

		push {lr}				//save caller return address
		
		bl wiringPiSetup 
		
		mov r0, #PIN_17			//prepare read mode for pin17(inrementing)
		mov r1, #IN
		bl pinMode

		mov r0, #PIN_27			//prepare read mode for pin27(decrementing)
		mov r1, #IN
		bl pinMode

		mov r0, #PIN_12			//prepare output mode for counting pulses to external circuit
		mov r1, #OUT
		bl pinMode

		mov r0, #PIN_13			//prepare reset pulse to external circuit
		mov r1, #OUT
		bl pinMode

		mov r0, #PIN_22			//prepare ouput for led display(on/off - under cap/max cap)
		mov r1, #OUT
		bl pinMode

		//prepare previous state memory for toggle buttons
		mov r0, #0
		ldr r1, =status_P17		//count up process
		str r0, [r1]			//set to not active 
		
		ldr r1, =status_P27		//count down process
		str r0, [r1]			//set to not active 
		
		ldr r1, =switch_P17		//no down press action for increment
		str r0, [r1]			//set to not active 
		
		ldr r1, =switch_P27		//no down press action for decrement
		str r0, [r1]			//set to not active 

		mov r0, #0			
		pop {pc}				//exit back to caller

//-------------------------------------------------------------------
// Function: reset_pulse - reset 7 segement displays with a HIGH then
//						   low pulse with a 3ms delay
// Precondition:R0 and R1 are used for setup pins
// Postcondition: No Registers are preserved
// Other Notes: The delay is mainly there to give the decode counter
//				enough time to reset the display.
//-------------------------------------------------------------------
reset_pulse:

		push {lr}				//save caller return address
		
		mov r0, #PIN_13
		mov r1, #HIGH			//generate a reset "high" pulse to external circuit
		bl digitalWrite
		mov r0, #3
		bl delayMicroseconds	//help to the external circuit to 
								//to pick up the true pulse level.
								//essentially making low pass circuit
	
		mov r0, #PIN_13
		mov r1, #LOW 			//generate a reset "low" pulse to external circuit
		bl digitalWrite
		mov r0, #3
		bl delayMicroseconds	//help to the external circuit to 
								//to pick up the true pulse level.
								//essentially making low pass circuit
		
		mov r0, #0			
		pop {pc}				//exit back to caller
	
//-------------------------------------------------------------------
// Function: pin12_clock_pulse - 1 pulse generator 
// Precondition:
// Postcondition: No Registers are preserved
// Other Notes: The delay is there is there to mainly there for display
//				stability and to keep the numbers from jumping. By 
//				sacrificing display speed, we gain more stability 
//				over the long run. 
//				Due to the wire from the pgio pin to the clock chip,
//				it forms a resistor-capacitor delay circuit which causes
//				erronous pulse counting, To resolve this issues, yjr delay is intrdouce
// 				to extend the pulse with the 3ms delay to guarrentee that the chip picks
//				up the pulse.
//-------------------------------------------------------------------
pin12_clock_pulse:
		
		push {lr}				//save caller return address
		
		mov r0, #PIN_12
		mov r1, #HIGH 			//generate a count "high" pulse to external circuit
		bl digitalWrite
		mov r0, #3
		bl delayMicroseconds	//to avoid R-C circuit delay problem
		
		mov r0, #PIN_12
		mov r1, #LOW 			//generate a count "low" pulse to external circuit
		bl digitalWrite			//to complete one count for the external circuit
		mov r0, #3
		bl delayMicroseconds	//to avoid R-C circuit delay problem
		
		mov r0, #0				
		pop {pc}				//return back to caller

//-------------------------------------------------------------------
// Function: send_N_pulses
// Precondition: R0 and R1 reserved for other function calls
//				 R2 - contains number of pulses
// Postcondition: No Registers are preserved
// Other Notes: if number == 0, then just only reset display
//				this is mainly to keep the number from going out of
//				bounds
//-------------------------------------------------------------------
send_N_pulses:
		
		push {lr}				//save caller return address
		
		bl reset_pulse			//clear current display to 0
		ldr r2, =number
		ldr r0,[r2]
		mov r1, #0
		cmp r1,r0 				//check if count is 0
		bne loop_back			//if not go to pulse count display operation
		bl end_pulse			//if 0 go back to caller
	loop_back:	
		push {r0}				//prevent status change of r2
		bl pin12_clock_pulse	//send 1 pulse to external circuit
		pop {r0}
		subs r0,r0,#1			//check flag condition
		bne loop_back			//if count is not done so continue
	end_pulse:
		mov r0, #0		

		pop {pc}				//return back to caller
		

//-------------------------------------------------------------------
// Function: read_pulses_pin - reads pin values and store at labels
// Precondition: R0 and R1 reserved for other function calls
//				 				 
// Postcondition: labels are updated with pin states
// Other Notes: None
//-------------------------------------------------------------------
read_pulses_pin:
		push {lr}				//save caller return address
			
		mov r0, #PIN_17			//read increment counting switch condition
		bl digitalRead

		ldr r2, =switch_P17
		str r0, [r2]			//save switch condition into memory

		mov r0, #PIN_27			//read the decrement counting switch condition
		bl digitalRead
		ldr r2, =switch_P27	
		str r0, [r2]			//save switch condition into memory 
		mov r0,#0
		pop {pc}				//return back to caller

//-------------------------------------------------------------------
// Function: cap_check - the function checks if our current number is
//						 greater or equal to the parking cap
// Precondition: R0 and R1 reserved for other function calls
//				 
// Postcondition: No Registers are preserved
// Other Notes: The green led will be on if number < parking cap and 
//				will turn off the green led if greater than parking cap
//				The 5v inverter will turn on the red light in that case.
//-------------------------------------------------------------------
cap_check:
		push {lr}				//save caller return address
		
		ldr r0, =number
		ldr r1, [r0]
		cmp r1, #PARK_CAP		//if current count < parking capacity
		blt light_on			//if not over ...
		mov r0,#PIN_22			//turn on red light and turn off green light
								//we are going over capacity
		mov r1,#LOW
		bal end_check
	light_on:
		mov r0,#PIN_22			//turn on green light and turn off red light
								//there is still room
		mov r1,#HIGH
	end_check:
		bl digitalWrite
	
		mov r0,#0
		pop {pc}				//return back to caller
