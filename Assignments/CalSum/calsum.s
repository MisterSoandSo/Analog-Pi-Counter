//Andrew So

.global main

.section .rodata
    prompt_1:               .asciz "Enter a positive interger value: "
    prompt_out_sum:         .asciz "The sum of the numbers is %d.\n\n"
    prompt_out_sqz:         .asciz "The sum of the squares is %d.\n\n"
    int_in:                 .asciz "%d"
    new_line:               .asciz "\n"

.section .data
    sum_numbers:            .word 0    // the sum of the numbers 
    sum_squares:            .word 0    // the sum of the squares 
    number:                 .word 0    // user input value

    main:

        push {lr}                     // move link register to stack

    num_check:
    
        ldr r0, =prompt_1             // load prompt_1 into r0
        bl printf                     // print prompt_1

        ldr r0, =int_in               // load int_in into r0
        ldr r1, =number               // load pointer to number into r1
        bl scanf                      // read input

        ldr r0, =new_line             // load new_line into r0
        bl printf                     // print new_line

        ldr r4, =number               // load pointer to number into r4
        ldr r4, [r4]                  // load value of number into r4
        
        cmp r4, #1                    // compare number to the value 1
        blt num_check                 // if r4<1 redo loop if not the continue
        mov r0, #1                    // move the value 1 into r0

    cal_data:

        cmp r0, r4                    // setup counter with r0 and r4
        bgt output_data               // branch to output_data if the value in r0 > r4
        add r5, r0                    // add value in r5
        mul r6, r0, r0                // store squared sum in r6
        add r7,r6                     // store value into r7 to prevent overwrite of data
        add r0, #1                    // increment r0
        bal cal_data                  // always branch to cal_data

    output_data:

        ldr r0, =prompt_out_sum       // load prompt_out_sum into r0
        mov r1, r5                    // move value of r5 into r1
        bl printf                     // print message with sum of numbers

        ldr r0, =prompt_out_sqz       // load prompt_out_sqz into r0
        mov r1, r7                    // move value of r7 into r1
        bl printf                     // print message with sum of squares

        mov r0, #0                    // return code for your program (must be 8 bits)
        pop {pc}                      
