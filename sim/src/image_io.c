/*
 * Author: Kais Kudrolli
 *
 * Description: This file contains the C code that implements functions to
 * input test images into the simulator.
 *
 */

#include "image_io.h"

/********************
 * Helper Functions *
 ********************/

/*
 * read_word: Read a data word (4 bytes) from a byte array starting
 *            at a given offset.
 * 
 * Parameters:
 *  - arr: byte array
 *  - offset: offset into byte array
 *
 * Return value:
 *  - data word
 */
uint32_t read_word(uint8_t *arr, uint32_t offset)
{
    uint32_t word = (uint32_t) arr[offset];

    for (int i = 1; i < WORD_BYTES; i++) { 
        word = (word << BYTE_SIZE) + arr[offset + i]; 
    }

    return word;
}

/*********************
 * Library Functions *
 *********************/

/*
 * read_bitmap: Read in bitmap image data from .bmp file.
 *
 * Parameters:
 *  - filename: string name of bitmap file to be read
 *
 * Return value:
 *  - byte array of bitmap data
 */
uint8_t *read_bitmap(char *filename)
{
#ifdef IMAGE_IO_DBG
    printf("In read_bitmap, filename: %s\n", filename);
#endif
    char *mode = FILE_MODE;

    /* Read in the bitmap file */
    FILE *image = Fopen(filename, mode);

    /* Extract header bytes */
    uint8_t header[BMP_HEADER_SIZE];
    Fread(header, sizeof(uint8_t), BMP_HEADER_SIZE, image);
   
#ifdef IMAGE_IO_DBG
    printf("Bitmap header: \n");
    for (int i = 0; i < BMP_HEADER_SIZE; i++) {
        printf("%x ", header[i]);
    }
    printf("\n");
#endif
   
    /* Extract width, height from header */
    // TODO: data size = 0
    uint32_t data_size = read_word(header, DATA_SIZE_OFFSET);

#ifdef IMAGE_IO_DBG
    printf("Data size: %d\n", data_size);
#endif

    /* Read the image data */
    uint8_t *image_data = (uint8_t*) Calloc(data_size, sizeof(uint8_t)); 
    if (fread(image_data, data_size, sizeof(uint32_t), image) < data_size) {
#ifdef IMAGE_IO_DBG
        printf("Error: Couldn't read image data\n");
#endif
        Free(image_data);
        Fclose(image);
        return NULL;
    }

    // TODO: remove 3/4 of bits
    // TODO: typedef output or change to vector?
    
    Fclose(image);
    return image_data;
}









