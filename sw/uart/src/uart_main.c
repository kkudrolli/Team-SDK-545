// Code from: http://yengal-marumugam.blogspot.com/2011/07/serial-port-manipulation-in-c-linux.html

#include <stdio.h>    // Standard input/output definitions
#include <string.h>   // String function definitions
#include <unistd.h>   // UNIX standard function definitions
#include <fcntl.h>    // File control definitions
#include <errno.h>    // Error number definitions
#include <termios.h>  // POSIX terminal control definitions 
#include <string.h>
#include "mnist.h"
#include "image_io.h"

// UART Protocol Bytes
#define START  0xff
#define TRAIN  0xf0
#define TEST   0x0f
#define STOP   0xbb
#define ACK    0xaa
#define RESEND 0xcc

static const char *serial_port =  "/dev/ttyUSB0";

void transfer(vector_t *images, uint32_t *labels, int port, size_t num_images); 
uint8_t ones_comp_add(uint8_t a, uint8_t b);
void write_byte(int port, uint8_t buf); 
uint8_t read_byte(int port);
int open_port(void);

int main()
{
    int port;
    int ret;

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

    // Set Baud Rate to 921600 bps
    if ((ret = cfsetospeed(&specs, B921600)) == -1){
        printf("Error in setting baud rate\n");
    }

    // Our custom specifications set to the port
    // TCSANOW - constant that prompts the system to set
    // Specifications immediately.
    if ((ret = tcsetattr(port, TCSANOW, &specs)) == -1) {
        perror("Error in setting attribute:");
    }
    

    printf("Press ENTER to send image\n");
    getchar();

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

    // Get typeset data
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
    uint32_t typeset_lbls[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

    transfer(m_imgs->imgs, m_lbls->labels->data, port, 1, 1);
    //transfer(typeset_imgs, typeset_lbls, port, 1, 10);

    // MNIST TEST END

    // Close the port
    tcflush(0, TCIOFLUSH);
    close(port);
    return 0;
} 

void transfer(vector_t *images, uint32_t *labels, int port, int train, size_t num_images) 
{
    size_t i = 0;
    uint32_t resent = 0;
    while (i < num_images) {
        
        ssize_t n;
        uint8_t checksum = 0;
    
        vector_t img = images[i];
        size_t length = img->length;
        uint32_t *data = img->data; 
	    uint32_t label = labels[i];

        printf("Iteration %d (num: %d)...\n", i, label);

        uint8_t *bytes = (uint8_t*) Calloc(length, sizeof(uint8_t));
	        
        // Put 32-bit data in 8-bit data type
        for (size_t j = 0; j < length; j++) {
            bytes[j] = (uint8_t) data[j];
        }
        
        // Write bytes to serial port byte by byte as per the defined UART protocol:
        // START-TRAIN/TEST-DATA-...-DATA-LABEL-CHECKSUM-STOP

        // START
        write_byte(port, START);

        if (train) {
            // TRAIN
            write_byte(port, TRAIN);
        } else {
            // TEST
            write_byte(port, TEST);
        }

        // DATA 784 times
        for (size_t j = 0; j < length; j++) {
            write_byte(port, bytes[j]);
            // Add up bytes with 1's complement addition to get checksum
            checksum = ones_comp_add(checksum, bytes[j]);
        }

        // LABEL
        write_byte(port, label);
        checksum = ones_comp_add(checksum, label);

        // CHECKSUM
        write_byte(port, checksum);

        // Check for resend
        // TODO: may miss, check more than once?
        if (!resent && read_byte(port) == RESEND) {
            resent = 1; // Only resend once
            continue;   // Skips the rest of the loop so don't update i or resent
        }

        // STOP
        write_byte(port, STOP);

        // Wait for an ACK
        printf("Waiting for an ACK...");
        uint32_t ack_buf = 0;
        while (ack_buf != ACK) {
            ack_buf = read_byte(port);
        }
        printf("got the ACK!\n");

        //Free(bytes);
        resent = 0;
        i++;
    }

    return;
}

// Does 8-bit 1's complement addition
uint8_t ones_comp_add(uint8_t a, uint8_t b)
{
    // Increase position
    uint16_t a16 = (uint16_t) a;
    uint16_t b16 = (uint16_t) b;

    // Add with increased precision
    uint8_t c16 = a16 + b16;

    // Extract the carry bit (9th bit)
    uint8_t carry = (uint8_t) ((c16 >> 8) & 0x1);
    // Reduce precision of c back to 8 bit
    uint8_t c = (uint8_t) c16;

    // Add carry back to result
    return c + carry;
}

// Write one byte to a port
void write_byte(int port, uint8_t buf) 
{
    if ((n = write(port, &buf, 1)) < 0) { 
        printf("\nError writing bytes to serial port!\n");
    }
}

// Read one byte from a port
uint8_t read_byte(int port) 
{
    uint8_t buf;
    if ((n = read(port, &buf, 1)) < 0) { 
        printf("\nError reading bytes from serial port!\n");
    }
    return buf;
}

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

