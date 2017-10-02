.section .data

prompt:     .asciz "Hello! Welcome to Two Integers.\n\n"
prompt_1:   .asciz "Enter an integer for first number:"
prompt_2:   .asciz "Enter an integer for second number:"

number_1:   .word 0 
number_2:   .word 0 
sum:        .word 0 
difference: .word 0 
product:    .word 0 

.global main

main: 	push {lr}         /*save our return address*/
        ldr r0, =prompt   /**/
        bl printf         /*Call printf to output*/
	
	ldr r0, =prompt_1   /**/
        bl printf         /*Call printf to output*/
	
	ldr r0, =prompt_2   /**/
        bl printf         /*Call printf to output*/

  // assembly program here

	mov r0, #0 // return code for your program (must be 8 bits)
	pop {pc}

