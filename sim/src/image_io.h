/*
 * Author: Kais Kudrolli
 *
 * Description: This is the header file for image_io.c, containing all the
 * function, struct, and variable definitions for image_io.
 *
 */

#ifndef _IMAGE_IO_H_
#define _IMAGE_IO_H_

#include <stdint.h>
#include "err_wrappers.h"
#include "vector.h"
#include "assert.h"

//#define IMAGE_IO_DBG
#define FILE_MODE "rb"
#define BMP_HEADER_SIZE 54
#define DATA_SIZE_OFFSET 34
#define BYTE_SIZE 8
#define WORD_BYTES 4
#define NUM_BYTES_IN_PIX 3
#define HEIGHT_OFFSET 18
#define WIDTH_OFFSET 22

vector_t read_bitmap(char *filename);

#endif
