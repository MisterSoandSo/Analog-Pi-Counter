/*
~~~~~ Assignment Objectives ~~~~~
0. Using the division algorithm introduced in class to convert between base 10 and any other number base:

1. Prompts the user to enter an unsigned integer in base 10 (decimal) from the keyboard.

2. Prompts the user a new base ( greater than or equal to 2 and less than or equal to 36** ) to convert the base 10 unsigned integer into

3. Constructs a string of digits that represents the user entered base 10 integer in the user entered new base

4. Output the constructed string
*/

#include <stdio.h>
#include <cmath>
using namespace std;

///functions
void build_string(int out_base, int in_num)     ///builds and prints output string
{
    int temp;
    temp = in_num % out_base;
    in_num /= out_base;

    if(in_num !=0) build_string(out_base,in_num);   ///print by stack ... reccursive call

    if(temp <= 9)
    {
        temp += 48;
    }
    else if (temp > 9)
    {
        temp += 55;
    }
    printf("%c",char(temp));

}
void print_newval(int &num, int &out_base)      ///setup for output string
{
	int in_num = num;
	int in_base = out_base;

	printf("%s ","New Output: ");
	build_string(in_base, in_num);
    printf("%c",char(10));
}

int main()
{
    int user_input = 0;
    int base_output = 0;

    while(true) ///while loop for testing purposes
    {
        ///get input from user
        printf ("%s ", "Please enter a base 10 number: ");
        scanf ("%d",&user_input);
        printf ("%s ", "Enter the new base: ");
        scanf ("%d",&base_output);

        if(base_output > 1 && base_output < 37)       ///valid base output range
        {
            ///process and output for new string
            print_newval(user_input, base_output);
        }
    }
    return 0;
}
