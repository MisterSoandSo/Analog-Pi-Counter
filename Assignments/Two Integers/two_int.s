.section .data

prompt: .asciz "Hello! Welcome to Two Integers.\n\n"
prompt_1: .asciz "Enter an integer for first number:"
prompt_2: .asciz "Enter an integer for second number:"

.global main

main: 	push {lr}         /*save our return address*/
        ldr r0, =prompt   /**/
        bl printf         /*Call printf to output*/

  // assembly program here

	mov r0, #0 // return code for your program (must be 8 bits)
	pop {pc}

