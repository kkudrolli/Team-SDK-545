#include "uart.h"

int configure_port(void)
{
    int port;
    int ret;

    // termios - structure contains options for port manipulation
    struct termios specs; // For setting baud rate 

    // Setup part
    port = open_port();
    if ((ret = tcgetattr(port, &specs)) == -1) {
        perror("tcgetattr error");
    }

    // Now the specs points to the opened port's specifications

    //specs.c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP 
    //                 | INLCR | IGNCR | ICRNL | IXON);
    specs.c_iflag |= IGNBRK; // Ignore breaks
    specs.c_iflag |= IGNPAR; // Ignore parity and frame errors
    //specs.c_iflag |= IXON;
    specs.c_iflag |= IXOFF; // Turn sw handshaking off

    specs.c_cflag = (CLOCAL | CREAD); //control flags
    specs.c_cflag &= ~CSIZE;
    specs.c_cflag |= CS8;
    //specs.c_cflag |= CSTOPB;    

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

    return port;
}

void close_port(int port) 
{
    // Clean up the port 
    tcflush(0, TCIOFLUSH);
    close(port);
    return;
} 

void transfer(vector_t *images, uint32_t *labels, int port, int train, size_t num_images) 
{
#ifdef SLOW
    printf("Press ENTER to send image\n");
    getchar();
#endif

    size_t i = 0;
    uint32_t resent = 0;
    while (i < num_images) {
        
        uint8_t checksum = 0;
    
        vector_t img = images[i];
        img = center(img);
        size_t length = img->length;
        uint32_t *data = img->data; 
        uint32_t label = labels[i];

        printf("Iteration %zu (num: %d)...\n", i, label);

        uint8_t *bytes = (uint8_t*) Calloc(length, sizeof(uint8_t));
	        
        // Put 32-bit data in 8-bit data type
        for (size_t j = 0; j < length; j++) {
            bytes[j] = (uint8_t) data[j];
        }
        
        // Write bytes to serial port byte by byte as per the defined UART protocol:
        // START-TRAIN/TEST-LABEL-DATA-...-DATA-CHECKSUM

        // START
#ifdef SLOW
        printf("Press ENTER to send start\n");
        getchar();
#endif
        printf("START\n");
        write_byte(port, PSTART);

#ifdef SLOW
        printf("Press ENTER to send train/test\n");
        getchar();
#endif
        if (train) {
            // TRAIN
            printf("TRAIN\n");
            write_byte(port, PTRAIN);
        } else {
            // TEST
            printf("TEST\n");
            write_byte(port, PTEST);
        }

#ifdef SLOW
        printf("Press ENTER to send label: %x\n", label);
        getchar();
#endif
        // LABEL
        printf("LABEL\n");
        write_byte(port, label);
        checksum = ones_comp_add(checksum, label);

        // DATA 784 times        
#ifdef SLOW
        printf("Press ENTER to send data\n");
        getchar();
#endif
 
        printf("DATA\n");
        for (size_t j = 0; j < length; j++) {
            if (bytes[j] == 0xff) bytes[j] -= 1; // Enforce unique start byte
#ifdef UART_DBG
            printf("Press ENTER to send data %zu, byte: %x\n", j, bytes[j]);
            getchar();
#endif
            write_byte(port, bytes[j]);
            // Add up bytes with 1's complement addition to get checksum
            checksum = ones_comp_add(checksum, bytes[j]);
        }
  
#ifdef SLOW
        printf("Press ENTER to send checksum: %x\n", checksum);
        getchar();
#endif
        // CHECKSUM
        printf("CHECKSUM\n");
        write_byte(port, checksum);

        printf("Before RESEND check\n");
        // Check for resend
        // TODO: may miss, check more than once?
        /*printf("WAT...\n");
        uint8_t rd = read_byte(port);
        printf("After read\n");
        if (!resent && rd == PRESEND) {
            resent = 1; // Only resend once
            printf("Before continue\n");
            continue;   // Skips the rest of the loop so don't update i or resent
        }*/

        // STOP
/*
#ifdef SLOW
        printf("Press ENTER to send stop\n");
        getchar();
#endif
        printf("STOP\n");
        write_byte(port, PSTOP);
*/
        // Wait for an ACK
        /*printf("Waiting for an ACK...");
        uint32_t ack_buf = 0;
        while (ack_buf != PACK) {
            ack_buf = read_byte(port);
        }
        printf("got the ACK!\n");*/

        //Free(bytes);
        resent = 0;
        i++;
        usleep(11000); // Needs a tinyyyy bit of sleep
                       // 11000 experimentally determined
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
    ssize_t n;
    if ((n = write(port, &buf, 1)) < 0) { 
#ifdef UART_DBG
        printf("\nError writing bytes to serial port!\n");
#endif
    }
}

// Read one byte from a port
uint8_t read_byte(int port) 
{
    printf("In read byte\n");
    uint8_t buf;
    printf("After buf creation\n");
    int n;
    printf("Before the read...\n");
    if ((n = read(port, &buf, 1)) < 0) { 
        printf("\nError reading bytes from serial port!\n");
    }
    printf("after the read\n");
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

