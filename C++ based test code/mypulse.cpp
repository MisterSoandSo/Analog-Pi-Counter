
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define IN  0
#define OUT 1

#define LOW  0
#define HIGH 1


static int
GPIOExport(int pin)
{
#define BUFFER_MAX 3
	char buffer[BUFFER_MAX];
	ssize_t bytes_written;
	int fd;

	fd = open("/sys/class/gpio/export", O_WRONLY);
	if (-1 == fd) {
		fprintf(stderr, "Failed to open export for writing!\n");
		return(-1);
	}

	bytes_written = snprintf(buffer, BUFFER_MAX, "%d", pin);
	write(fd, buffer, bytes_written);
	close(fd);
	return(0);
}

static int
GPIOUnexport(int pin)
{
	char buffer[BUFFER_MAX];
	ssize_t bytes_written;
	int fd;

	fd = open("/sys/class/gpio/unexport", O_WRONLY);
	if (-1 == fd) {
		fprintf(stderr, "Failed to open unexport for writing!\n");
		return(-1);
	}

	bytes_written = snprintf(buffer, BUFFER_MAX, "%d", pin);
	write(fd, buffer, bytes_written);
	close(fd);
	return(0);
}

static int
GPIODirection(int pin, int dir)
{
	static const char s_directions_str[]  = "in\0out";

#define DIRECTION_MAX 35
	char path[DIRECTION_MAX];
	int fd;

	snprintf(path, DIRECTION_MAX, "/sys/class/gpio/gpio%d/direction", pin);
	fd = open(path, O_WRONLY);
	if (-1 == fd) {
		fprintf(stderr, "Failed to open gpio direction for writing!\n");
		return(-1);
	}

	if (-1 == write(fd, &s_directions_str[IN == dir ? 0 : 3], IN == dir ? 2 : 3)) {
		fprintf(stderr, "Failed to set direction!\n");
		return(-1);
	}

	close(fd);
	return(0);
}

static int
GPIORead(int pin)
{
#define VALUE_MAX 30
	char path[VALUE_MAX];
	char value_str[3];
	int fd;

	snprintf(path, VALUE_MAX, "/sys/class/gpio/gpio%d/value", pin);
	fd = open(path, O_RDONLY);
	if (-1 == fd) {
		fprintf(stderr, "Failed to open gpio value for reading!\n");
		return(-1);
	}

	if (-1 == read(fd, value_str, 3)) {
		fprintf(stderr, "Failed to read value!\n");
		return(-1);
	}

	close(fd);

	return(atoi(value_str));
}

static int
GPIOWrite(int pin, int value)
{
	static const char s_values_str[] = "01";

	char path[VALUE_MAX];
	int fd;

	snprintf(path, VALUE_MAX, "/sys/class/gpio/gpio%d/value", pin);
	fd = open(path, O_WRONLY);
	if (-1 == fd) {
		fprintf(stderr, "Failed to open gpio value for writing!\n");
		return(-1);
	}

	if (1 != write(fd, &s_values_str[LOW == value ? 0 : 1], 1)) {
		fprintf(stderr, "Failed to write value!\n");
		return(-1);
	}

	close(fd);
	return(0);
}

void reset_pulse()
{
	GPIOWrite(13, 1);  /*reset pulse level=high*/
	usleep(100);
	GPIOWrite(13, 0);  /*reset pulse level=low */
	usleep(100);
}

void pin22_clock_pulse()
{
	GPIOWrite(22, 1);  /* clock pulse level=low*/
	GPIOWrite(22, 0);  /* clock pulse level=high*/
}

void pin12_clock_pulse()
{
	GPIOWrite(12, 1);  /* clock pulse level=low*/
	GPIOWrite(12, 0);  /* clock pulse level=high*/
}

void send_N_pulses( int n)
{
	reset_pulse();
	if(n>0)
	{
		do
		{

			//pin22_clock_pulse();
			pin12_clock_pulse();

			n--;
		}
		while(n>0);
	}
}

int main(int argc, char *argv[])
{

	bool in_process;

	/*
	 * Enable GPIO pins
	 */
	if (-1 == GPIOExport(12) ||-1 == GPIOExport(13) ||
		-1 == GPIOExport(22) || -1 == GPIOExport(17) ||-1 == GPIOExport(27))
		return(1);

	/*
	 * Set GPIO directions
	 */
	if (-1 == GPIODirection(12, OUT))		//yellow
		return(2);
    if (-1 == GPIODirection(13, OUT))		//green
		return(2);
	if (-1 == GPIODirection(22, OUT))		//blue
		return(2);
    if (-1 == GPIODirection(17, IN))		//right
		return(2);
	if ( -1 == GPIODirection(27, IN))		//left
		return(2);
		/*
		 * Write GPIO value
		 */


	//fprintf(stderr,"\nBefore sending pulses...");
	int i = 0;
	send_N_pulses(i);
	in_process=false;
	while(1)
	{
		//send_N_pulses(i);
		if(in_process==false && GPIORead(17) == 0 && GPIORead(27) == 1)
		{
			in_process=true;
			//fprintf(stderr,"\nPins 17 activated");
			i++;
			send_N_pulses(i);


		}

		if(in_process==false && GPIORead(17) == 1 && GPIORead(27) == 0)
		{
			in_process=true;
			//fprintf(stderr,"\nPins 27 activated");
			i--;
			send_N_pulses(i);
		}
		if(in_process==true && GPIORead(17) == 0 && GPIORead(27) == 0)
		{
			break;
		}
		if(in_process==true && GPIORead(17) == 1 && GPIORead(27) == 1)
		{
				in_process =false;
		}
	}
	return(0);
}

