// Code from: http://yengal-marumugam.blogspot.com/2011/07/serial-port-manipulation-in-c-linux.html

#include <stdio.h>     // Standard input/output definitions
#include <string.h>    // String function definitions
#include <unistd.h>   // UNIX standard function definitions
#include <fcntl.h>      // File control definitions
#include <errno.h>     // Error number definitions
#include <termios.h>  // POSIX terminal control definitions 
#include <string.h>
#include "mnist.h"
#include "image_io.h"

static const char *serial_port =  "/dev/tty.SLAB_USBtoUART";

// Function to open the port
int open_port(void)
{
    int port;
    // Open the port and store the file descriptor in 'port'
    port = open(serial_port, O_RDWR | O_NOCTTY | O_NDELAY);
    if (port == -1) {
        // Could not open the port
        perror("open_port: Unable to open /dev/tty... - ");
    } else {
        fcntl(port, F_SETFL, 0); // Leave this
        printf("Successfully opened port\n");
    }
    return (port);
}


int main()
{
    int port;
    int n;
    int ret;
    //char str[30];

    //termios - structure contains options for port manipulation
    struct termios specs; // For setting baud rate 

    // Setup part
    port = open_port();
    if ((ret = tcgetattr(port, &specs)) == -1) {
        perror("tcgetattr error");
    }

    // Now the specs points to the opened port's specifications

    specs.c_cflag = (CLOCAL | CREAD); //control flags
    specs.c_cflag &= ~CSIZE;
    specs.c_cflag |= CS8;
    specs.c_cflag |= CSTOPB;

    // Output flags
    // CR3 - delay of 150ms after transmitting every line
    //specs.c_oflag = (OPOST | CR3);

    // Set Baud Rate to 9600bps
    if ((ret = cfsetospeed(&specs, B9600)) == -1){
        printf("Error in setting baud rate\n");
    }

    // Our custom specifications set to the port
    // TCSANOW - constant that prompts the system to set
    // Specifications immediately.
    if ((ret = tcsetattr(port, TCSANOW, &specs)) == -1) {
        perror("Error in setting attribute:");
    }
    
    //printf("\nPress SPACE to send data, q to quit\n");
    //scanf("%s", str);
    //if (str[0] == 'q') exit(0);
    printf("Press ENTER to send image\n");
    getchar();

    /*n = 20;
    char buf[20] = {0, 0x10, 0x20, 0x30, 0x40, 0x50, 0x60, 0x70, 
                    0x80, 0x90, 0xa0, 0xb0, 0xc0, 0xd0, 0xe0, 0xf0, 
                    0x1, 0x2, 0x3, 0xff};
    for (int i = 0; 1; i++) {
        if ((n = write(port, &buf[19], 1)) < 0) { // n = no of bytes written
            printf("\nError");
        }
        usleep(1000); // Sleep for 1 ms
        printf("Done sleep\n");
    }*/

    // IMAGE_IO TEST
    /*
    vector_t img = read_bitmap("../camera/pics/ezm-testpattern-03.bmp");
    size_t length = img->length;
    uint32_t *data = img->data; 

    unsigned char *bytes = (unsigned char*) Calloc(length, sizeof(unsigned char));

    for (size_t j = 0; j < length; j++) {
        bytes[j] = (unsigned char) data[j];

        printf("%x ", bytes[j]);
    }

    for (size_t j = 0; j < length; j++) {
        if ((n = write(port, &(bytes[j]), 1)) < 0) { // n = no of bytes written
            printf("\nError");
        }
        usleep(1000); // Sleep for 1 ms
    }
    // END IMAGE_IO TEST
*/
    // MNIST TEST BELOW

    // Get the mnist data
    mnist_images_t m_imgs = read_images(TRAIN);
    mnist_labels_t m_lbls = read_labels(TRAIN);
    size_t size = 300; // TODO: m_imgs->size
    vector_t typeset_imgs[10];

    typeset_imgs[0] = read_bitmap("../../sim/digits/0.bmp");
    typeset_imgs[1] = read_bitmap("../../sim/digits/1.bmp");
    typeset_imgs[2] = read_bitmap("../../sim/digits/2.bmp");
    typeset_imgs[3] = read_bitmap("../../sim/digits/3.bmp");
    typeset_imgs[4] = read_bitmap("../../sim/digits/4.bmp");
    typeset_imgs[5] = read_bitmap("../../sim/digits/5.bmp");
    typeset_imgs[6] = read_bitmap("../../sim/digits/6.bmp");
    typeset_imgs[7] = read_bitmap("../../sim/digits/7.bmp");
    typeset_imgs[8] = read_bitmap("../../sim/digits/8.bmp");
    typeset_imgs[9] = read_bitmap("../../sim/digits/9.bmp");

    for (size_t i = 0; i < size; i++) {
    
        vector_t img = m_imgs->imgs[i];
        size_t length = img->length;
        uint32_t *data = img->data; 
	uint32_t label = m_lbls->labels->data[i];

        unsigned char *bytes = (unsigned char*) Calloc(length, sizeof(unsigned char));
        
        for (size_t j = 0; j < length; j++) {
            bytes[j] = (unsigned char) data[j];
        }
        
        for (size_t j = 0; j < length; j++) {
	  if (0){//(n = write(port, &(bytes[j]), 1)) < 0) { // n = no of bytes written
                printf("\nError");
            }
        }

	img = typeset_imgs[label];
	length = img->length;
	data = img->data;
        for (size_t j = 0; j < length; j++) {
            bytes[j] = (unsigned char) data[j];
        }
        
        for (size_t j = 0; j < length; j++) {
	  if (0){//(n = write(port, &(bytes[j]), 1)) < 0) { // n = no of bytes written
                printf("\nError");
            }
        }

	printf("Iteration %d (num: %d)...\n", i, label);

	sleep(1);
    }

    // MNIST TEST END

    // Close the port
    //usleep(1000); // Sleep for 1 ms
    tcflush(0, TCIOFLUSH);
    close(port);
    return 0;
} 

