#ifndef _UART_H_
#define _UART_H_

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
#define PSTART  0xff
#define PTRAIN  0xf0
#define PTEST   0x0f
#define PSTOP   0xf0
#define PACK    0xaa
#define PRESEND 0xcc

//#define SLOW
//#define UART_DBG

static const char *serial_port =  "/dev/ttyUSB0";

int configure_port(void);
void close_port(int port); 
void transfer(vector_t *images, uint32_t *labels, int port, int train, size_t num_images); 
uint8_t ones_comp_add(uint8_t a, uint8_t b);
void write_byte(int port, uint8_t buf); 
uint8_t read_byte(int port);
int open_port(void);

#endif
