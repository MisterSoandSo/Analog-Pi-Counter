//Andrew So

.global main

.section .rodata

prompt:     .asciz "Hello, welcome to Two Integers.\n\n"
prompt_1:   .asciz "Enter an integer for first number: "
prompt_2:   .asciz "Enter an integer for second number: "
int_in:     .asciz "%d"
sum_out:    .asciz "\nThe sum of %d and %d is %d\n"
dif_out:    .asciz "\nThe difference of %d and %d is %d\n"
mul_out:    .asciz "\nThe product of %d and %d is %d\n"

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
	/*Load input values into R0 and R1*/
	
	ldr r0, =number_1	/*Load address of num_1*/
        ldr r0, [r0]		/*Store value of num_1 on r0*/
        ldr r1, =number_2	/*Load address of num_*/	
        ldr r1, [r1]		/*Store value of num_2 on r1*/
  	
	/*Calculating ...*/
	
	add r2, r0, r1
        ldr r3, =sum		/*Load address of sum*/
        str r2, [r3]		/*Store value of sum from r2 to r3*/

        sub r2, r0, r1
        ldr r3, =difference	/*Load address of difference*/
        str r2, [r3]		/*Store value of difference from r2 to r3*/

        mul r2, r0, r1
        ldr r3, =product	/*Load address of product*/
        str r2, [r3]		/*Store value of product from r2 to r3*/
	
	/*Print out result*/
	
	ldr r0, =sum_out	/*Load Sum msg into R0*/
        ldr r1, =number_1	/*Load address of num_1*/
        ldr r1, [r1]		/*Store value of num_1 on r1*/
        ldr r2, =number_2	/*Load address of num_2*/	
        ldr r2, [r2]		/*Store value of num_2 on r2*/
        ldr r3, =sum		/*Load address of sum*/
        ldr r3, [r3]		/*Store value of sum on r3*/
        bl printf		/*Print Sum msg*/

        ldr r0, =dif_out	/*Load Difference msg into R0*/
    	ldr r1, =number_1	/*Load address of num_1*/
        ldr r1, [r1]		/*Store value of num_1 on r1*/
        ldr r2, =number_2	/*Load address of num_2*/	
        ldr r2, [r2]		/*Store value of num_2 on r2*/
        ldr r3, =difference	/*Load address of Difference*/
        ldr r3, [r3]		/*Store value of Difference on r3*/	
        bl printf		/*Print Diffence msg*/
	
	ldr r0, =mul_out	/*Load Product msg into R0*/
        ldr r1, =number_1	/*Load address of num_1*/
        ldr r1, [r1]		/*Store value of num_1 on r1*/
        ldr r2, =number_2	/*Load address of num_2*/	
        ldr r2, [r2]		/*Store value of num_2 on r2*/
        ldr r3, =product	/*Load address of Product*/
        ldr r3, [r3]		/*Store value of Product on r3*/
        bl printf		/*Print Product Msg*/
	
	/*Done*/

	mov r0, #0 // return code for your program (must be 8 bits)
	pop {pc}


