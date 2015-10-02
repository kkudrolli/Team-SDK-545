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
#include "activation_fns.h"

#define NEURONS_PER_TILE (1<<10)

#define DEBUG
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

    vector_t *mnist_data = read_images(0);
#ifdef DEBUG
    printf("MNIST IMAGE:\n[ ");
    for (size_t i = 0; i < mnist_data[0]->length; i++) {
        printf("%x ", mnist_data[0]->data[i]);
    }
    printf("]\n");
#endif

    vector_t mnist_labels = read_labels(0);
#ifdef DEBUG
    printf("MNIST LABEL:\n[ ");
    for (size_t i = 0; i < mnist_labels->length; i++) {
        printf("%x ", mnist_labels->data[i]);
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


/*vector_t evaluate_image (vector_t image) {
  tile_t tile_in = Tile(NEURONS_PER_TILE, NEURONS_PER_TILE, NEURONS_PER_TILE, &linear_interpolation);
  tile_t tile_h1 = Tile(NEURONS_PER_TILE, NEURONS_PER_TILE, NEURONS_PER_TILE, &linear_interpolation);
  tile_t tile_h2 = Tile(NEURONS_PER_TILE, NEURONS_PER_TILE, NEURONS_PER_TILE, &linear_interpolation);
  tile_t tile_out = Tile(NEURONS_PER_TILE, NEURONS_PER_TILE, NEURONS_PER_TILE, &linear_interpolation);

  vector_t input = Vector(NEURONS_PER_TILE);
  vector_t weights = Vector(NEURONS_PER_TILE);
  vector_t weights1 = Vector(NEURONS_PER_TILE);
  vector_t weights2 = Vector(NEURONS_PER_TILE);
  vector_t weights3 = Vector(NEURONS_PER_TILE);

  for (uint32_t i = 0; i < NEURONS_PER_TILE; ++i) {
    input->data[i] = i;
    weights->data[i] = NEURONS_PER_TILE - i;
  }

  vector_t data = evaluate_tile(tile_in, input, weights);
  vector_t data1 = evaluate_tile(tile_h1, data, weights);
  vector_t data2 = evaluate_tile(tile_h2, data1, weights);
  vector_t data3 = evaluate_tile(tile_out, data2, weights);

  vector_destroy(data);
  vector_destroy(data1);
  vector_destroy(data2);
  vector_destroy(data3);
  vector_destroy(input);
  vector_destroy(weights);
  vector_destroy(weights1);
  vector_destroy(weights2);
  vector_destroy(weights3);
  tile_destroy(tile_in);
  tile_destroy(tile_h1);
  tile_destroy(tile_h2);
  tile_destroy(tile_out);
}*/
