//Andrew So

.global main

.section .rodata

prompt:     .asciz "Hello! Welcome to Two Integers.\n\n"
prompt_1:   .asciz "Enter an integer for first number:"
prompt_2:   .asciz "Enter an integer for second number:"
int_in:     .asciz "%d"

.section .data
number_1:   .word 0 
number_2:   .word 0 
sum:        .word 0 
difference: .word 0 
product:    .word 0 

main: 	push {lr}         	/*save our return address*/
        
	ldr r0, =prompt  	/*Load welcome msg*/
        bl printf         	/*Call printf to output*/
	
	ldr r0, =prompt_1   	/*load 1st msg*/
        bl printf        	/*Call printf to output*/
	
	ldr r0, =int_in		/*load input format*/
        ldr r1, =number_1	/*read user input*/
        bl scanf
	
	ldr r0, =prompt_2   	/*load 2nd msg*/
        bl printf        	/*Call printf to output*/
	
	ldr r0, =int_in		/*load input format*/
        ldr r1, =number_2	/*read user input*/
        bl scanf
	
	/*Finished taking in user input*/

  // assembly program here

	mov r0, #0 // return code for your program (must be 8 bits)
	pop {pc}

