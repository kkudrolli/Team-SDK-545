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
    Fread(header, sizeof(uint32_t), BMP_HEADER_SIZE, image);
   
#ifdef IMAGE_IO_DBG
    printf("Bitmap header: \n")
    for (int i = 0; i < BMP_HEADER_SIZE; i++) {
        printf("%d ", header[i]);
    }
#endif
   
    uint8_t width = header[WIDTH_OFFSET-1];
    uint8_t height = header[HEIGHT_OFFSET-1];
    
}
