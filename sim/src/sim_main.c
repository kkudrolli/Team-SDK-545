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
#include "mnist.h"
#include "image_io.h"
#include "err_wrappers.h"
#include "tile.h"

//#define DEBUG
#define TEST_PICS_DIR "../sw/camera/pics/"

int main() 
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

    mnist_images_t mnist_data = read_images(0);
#ifdef DEBUG
    printf("MNIST IMAGE:\n[ ");
    for (size_t i = 0; i < mnist_data->imgs[0]->length; i++) {
        printf("%x ", mnist_data->imgs[0]->data[i]);
    }
    printf("]\n");
#endif

    mnist_labels_t mnist_labels = read_labels(0);
#ifdef DEBUG
    printf("MNIST LABEL:\n[ ");
    for (size_t i = 0; i < mnist_labels->labels->length; i++) {
        printf("%x ", mnist_labels->labels->data[i]);
    }
    printf("]\n");
#endif


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
    while ((entry_ptr = readdir(dir_ptr))) {
        /* Get name of file and append it to directory name */
        char *filename = entry_ptr->d_name;
        if (filename[0] != '.') {
            size_t path_len = strlen(filename) + strlen(TEST_PICS_DIR) + 1;
            char full_path[path_len];
            snprintf(full_path, path_len, "%s%s", TEST_PICS_DIR, filename);

            /* Read bitmap data */
            vector_t image_data = read_bitmap(full_path);
            // TODO: call network here...
            vector_destroy(image_data);
        }
    }

    Closedir(dir_ptr);
    return 0;
}

