/*
 * Author: Kais Kudrolli
 *
 * Description: This file contains the C code that implements functions to
 * input test images into the simulator.
 *
 */

#include "image_io.h"

uint8_t *read_bitmap(char *filename)
{
    uint32_t *array;
    char *mode = FILE_MODE;

    /* Read in the bitmap file */
    FILE *image = Fopen(filename, mode);

    /* Extract header bytes */
    uint8_t header[BMP_HEADER_SIZE];
    
}
