/*        
	printf("Enter an integer for first number: ");
        scanf("%d", &number_1);

        printf("Enter an integer for second number: ");
        scanf("%d", &number_2);

        sum = number_1 + number_2;
        difference = number_2 - number_1;
        product = number_1 * number_2;

        printf("The sum of %d and %d is %d\n\n",number_1,number_2,sum);
        printf("The difference of %d and %d is %d\n\n",number_1,number_2,difference);
        printf("The product of %d and %d is %d\n\n",number_1,number_2,product);
*/
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

