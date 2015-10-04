// Code from: http://yengal-marumugam.blogspot.com/2011/07/serial-port-manipulation-in-c-linux.html

#include <stdio.h>     // Standard input/output definitions
#include <string.h>    // String function definitions
#include <unistd.h>   // UNIX standard function definitions
#include <fcntl.h>      // File control definitions
#include <errno.h>     // Error number definitions
#include <termios.h>  // POSIX terminal control definitions 
#include <string.h>
#include "mnist.h"

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
    specs.c_cflag = (CLOCAL | CREAD);// | CS8); //control flags

    // Output flags
    // CR3 - delay of 150ms after transmitting every line
    specs.c_oflag = (OPOST | CR3);

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

    // Get the mnist data
    mnist_images_t m_imgs = read_images(TRAIN);
    size_t size = 1; // TODO: m_imgs->size
    for (size_t i = 0; i < size; i++) {
        printf("In loop\n");
    
        vector_t img = m_imgs->imgs[i];
        size_t length = img->length;
        uint32_t *data = img->data; 

        /*
        for (size_t j = 0; j < length; j++) {
            printf("%x ", data[j]);
        }*/
        
        if ((n = write(port, data, length)) < 0) { // n = no of bytes written
            printf("\nError");
        }
        printf("n: %d\n", n);
        /*
        for (size_t j = 0; j < length; j++) {
            char buf[1];
            //printf("Length: %zu\n", length);
            //printf("DATA: %x\n", data[j]);
            snprintf(buf, 1, "%x", data[j]);
            // Execution part
            if ((n = write(port, buf, 1)) < 0) { // n = no of bytes written
                printf("\nError");
            }
            printf("%c ", buf[0]);
            //n = 1;
            //printf("What was written: %s\n", buf);
            //printf("Number of bytes written: %d\n", n);
        }*/
    }

    // Close the port
    close(port);
    return 0;
} 

