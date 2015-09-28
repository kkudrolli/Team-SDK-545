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
#include "tile.h"
#include "activation_fns.h"

#define NEURONS_PER_TILE (1<<10)

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
    if (filename[0] != '.') {
#ifdef DEBUG
      printf("Filename: %s\n", filename);
      printf("After setting filename\n");
#endif
      size_t path_len = strlen(filename) + strlen(TEST_PICS_DIR) + 1;
#ifdef DEBUG
      printf("Path Length: %zu\n", path_len);
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
      vector_t image_data = read_bitmap(full_path);
      // TODO: call network here...
#ifdef DEBUG 
      printf("After read bitmap\n");
#endif
      vector_destroy(image_data);
    }
  }

  Closedir(dir_ptr);


  return 0;
}


vector_t evaluate_image (vector_t image) {
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
}
