/*
 * Authors: Kais Kudrolli, DJ Park, Sohil Shah
 *
 * Description: Main file for C-level simulator of our neural network. This 
 * file sets up the test image I/O, neural network tiles, and weight memory.
 * It also simulates training by gradient descent (backpropagation) of the NN.
 * The simulator has been made modular to allow us to experiment with different
 * system and neural network configurations before implementing the system on an
 * FPGA. This project is for our capstone design project 18-545 at Carnegie 
 * Mellon University.
 *
 */

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "image_io.h"
#include "err_wrappers.h"

#define DEBUG
// TODO: is directory name correct
#define TEST_PICS_DIR "../sw/camera/pics/"
 
int main(int argc, char **argv) 
{
    /*
     * Some pseudocode:
     *
     * init I/O
     * init memory
     * init T1, T2
     * get all test image file names
     *
     * while (there are test images in the test directory) {
     *    read in an image using I/O
     *    send the image into the nn (T1, T2, memory)
     *    classify the output
     * }
     *
     * free all the things
     */

    DIR *dir_ptr;
    struct dirent *entry_ptr = NULL;

    /* Open directory */
    dir_ptr = Opendir(TEST_PICS_DIR);
    if (!dir_ptr) {
        error_print("Directory error");
    }

    /* 
     * Loop over entries in directory, read each bitmap file,  and 
     * launch a neural network call for each bitmap image.
     */
#ifdef DEBUG
    printf("Before while loop\n");
#endif
    while ((entry_ptr = readdir(dir_ptr))) {
        /* Get name of file and append it to directory name */
#ifdef DEBUG
        printf("In while loop\n");
#endif
        char *filename = entry_ptr->d_name;
        printf("Filename: %s\n", filename);
#ifdef DEBUG
        if (filename[0] != '.') {
            printf("After setting filename\n");
#endif
            size_t path_len = strlen(filename) + strlen(TEST_PICS_DIR) + 1;
            printf("Path Length: %zu\n", path_len);
#ifdef DEBUG
            printf("After set path len\n");
#endif
            char full_path[path_len];
#ifdef DEBUG
            printf("After initialize full path\n");
#endif
            snprintf(full_path, path_len, "%s%s", TEST_PICS_DIR, filename);
#ifdef DEBUG 
            printf("Full path: %s\n", full_path);
#endif

            /* Read bitmap data */
            uint8_t *image_data = read_bitmap(full_path);
            // TODO: call network here...
            Free(image_data);
        }
    }

    Closedir(dir_ptr);
    return 0;
}
