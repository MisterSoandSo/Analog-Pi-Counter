//Andrew So

.global main

.section .rodata

prompt:     .asciz "Hello! Welcome to Two Integers.\n\n"
prompt_1:   .asciz "Enter an integer for first number:"
prompt_2:   .asciz "Enter an integer for second number:"
int_in:     .asciz "%d"
sum_out:    .asciz "The sum of %d and %d is %d\n\n"
dif_out:    .asciz "The difference of %d and %d is %d\n\n"
mul_out:    .asciz "The product of %d and %d is %d\n\n"

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
	
	ldr r0, #10		/*load newline*/
        bl printf
	
	/*Finished taking in user input*/
	/*Load input values into R0 and R1*/
	
	ldr r0, =number_1
        ldr r0, [r0]
        ldr r1, =number_2
        ldr r1, [r1]
  	
	/*Calculating ...*/
	
	add r2, r0, r1
        ldr r3, =sum
        str r2, [r3]

        sub r2, r1, r0
        ldr r3, =difference
        str r2, [r3]

        mul r2, r0, r1
        ldr r3, =product
        str r2, [r3]	
	
	/*Print out result*/
	
	ldr r0, =sum_out
        ldr r1, =number_1
        ldr r1, [r1]
        ldr r2, =number_2
        ldr r2, [r2]
        ldr r3, =sum
        ldr r3, [r3]
        bl printf

        ldr r0, =dif_out
        ldr r1, =number_2
        ldr r1, [r1]
        ldr r2, =number_1
        ldr r2, [r2]
        ldr r3, =difference
        ldr r3, [r3]
        bl printf
	
	ldr r0, =mul_out
        ldr r1, =number_1
        ldr r1, [r1]
        ldr r2, =number_2
        ldr r2, [r2]
        ldr r3, =product
        ldr r3, [r3]
        bl printf
	
	/*Done*/

	mov r0, #0 // return code for your program (must be 8 bits)
	pop {pc}

