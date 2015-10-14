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
#include "activation_fns.h"
#include "backprop.h"
//#include "mnist.h"
#include "image_io.h"
#include "err_wrappers.h"
#include "tile.h"
#include "classify.h"
#include "target.h"

//#define DEBUG
//#define TEST_PICS_DIR "../sw/camera/pics/"
#include "params.h"

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
  /*
  
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

  */
  DIR *dir_ptr;
  struct dirent *entry_ptr = NULL;

  /* Open directory */
  /*    dir_ptr = Opendir(TEST_PICS_DIR);
	if (!dir_ptr) {
        error_print("Directory error");
	}*/

  network_t network = Network(NUM_LAYERS, 5625, 10, linear_fn, linear_drv);
    
  /*network_t network = Network(4, 2, 2, linear_fn, linear_drv);
    
    vector_t image = Vector(2);
    image->data[0] = 1 << 16;
    image->data[1] = 2 << 16;
    vector_t ideal = Vector(2);
    ideal->data[0] = 0 << 16;
    ideal->data[1] = 1 << 16;
    for (uint32_t i = 0; i < 5; i++) {
    printf("Beginning backpropogation iteration %d...\n", i); 
    vector_t results = evaluate_image(network, image);
    printf("Evaluate image done!\n"); 
    classify(results);
    backpropogate (network, image, ideal);
    printf("Backpropogation done!\n"); 
    vector_destroy(results);
    }
    vector_destroy(ideal);
    vector_destroy(image);
    
    /*image = gen_target(4);
    ideal = gen_target(2);
    for (uint32_t i = 0; i < 300; i++) {
    printf("Beginning backpropogation iteration %d...\n", i); 
    vector_t results = evaluate_image(network, image);
    printf("Evaluate image done!\n"); 
    classify(results);
    backpropogate (network, image, ideal);
    printf("Backpropogation done!\n"); 
    vector_destroy(results);
    }
    vector_destroy(ideal);
    vector_destroy(image);

    image = gen_target(6);
    ideal = gen_target(3);
    for (uint32_t i = 0; i < 300; i++) {
    printf("Beginning backpropogation iteration %d...\n", i); 
    vector_t results = evaluate_image(network, image);
    printf("Evaluate image done!\n"); 
    classify(results);
    backpropogate (network, image, ideal);
    printf("Backpropogation done!\n"); 
    vector_destroy(results);
    }
    vector_destroy(ideal);
    vector_destroy(image);

    image = gen_target(9);
    ideal = gen_target(0);
    for (uint32_t i = 0; i < 300; i++) {
    printf("Beginning backpropogation iteration %d...\n", i); 
    vector_t results = evaluate_image(network, image);
    printf("Evaluate image done!\n"); 
    classify(results);
    backpropogate (network, image, ideal);
    printf("Backpropogation done!\n"); 
    vector_destroy(results);
    }
    vector_destroy(ideal);
    vector_destroy(image);
    
    image = gen_target(7);
    image->data[5] = 300;
    image->data[2] = 200;
    vector_t results = evaluate_image(network, image);

    classify(results);
    
    image = gen_target(4);    
    image->data[8] = 300;
    image->data[1] = 200;
    results = evaluate_image(network, image);
    classify(results);

    image = gen_target(6);    
    image->data[3] = 300;
    image->data[9] = 200;
    results = evaluate_image(network, image);
    classify(results);

    image = gen_target(9);    
    image->data[1] = 800;
    image->data[0] = 100;
    results = evaluate_image(network, image);
    classify(results);
  */
  //return;    

  /* 
   * Loop over entries in directory, read each bitmap file,  and 
   * launch a neural network call for each bitmap image.
   */

  dir_ptr = Opendir(TEST_PICS_DIR);
  if (!dir_ptr) {
    error_print(BOLD RED "Directory error" NORMAL);
  }
  int i = 0;
  vector_t image_data[NUM_IMAGES];
  vector_t ideal[NUM_IMAGES];
  while ((entry_ptr = readdir(dir_ptr))) {
    /* Get name of file and append it to directory name */
    char *filename = entry_ptr->d_name;
    if (filename[0] != '.') {
      size_t path_len = strlen(filename) + strlen(TEST_PICS_DIR) + 1;
      char full_path[path_len];
      snprintf(full_path, path_len, "%s%s", TEST_PICS_DIR, filename);
	
      /* Read bitmap data */
      image_data[i] = read_bitmap(full_path);
      ideal[i] = gen_target(i);      	
      i++;
    }
  }
  Closedir(dir_ptr);

  time_t t;
  srand((unsigned) time(&t));

  printf(BOLD UNDERLINE "\nBeginning backpropogation...\n" NORMAL);

  int progress = 0;
  uint32_t epsilon = 0;
  for (int j = 0; j < OUTER_ITER; j++) {
    //printf("-------------------------------------\n");
    //printf("Evaluating file: %s\n\n", filename);

    printf(GREEN "Progress: \u2551");
    for (int i = 0; i < progress; i++) printf(YELLOW "\u2588");
    for (int i = 0; i < 29-progress; i++) printf(" ");
    printf(GREEN "\u2551");

    printf(GREEN " %d%%", ((j+1)*100 / (OUTER_ITER)));

    printf(KILL_LINE "\r" NORMAL);
    fflush(stdout);

    if (!((j+1) % (OUTER_ITER/30))) progress++;

    vector_t results = 0;
    uint32_t i = rand() % NUM_IMAGES;
    for (uint32_t k = 0; k < INNER_ITER; k++) {
      //if (results) vector_destroy(results);
      //printf("Beginning backpropogation iteration %d...\n", i); 
      //results = evaluate_image(network, image_data);
      //classify(results);
      //printf("Evaluate image done!\n"); 
      epsilon = backpropogate (network, image_data[i], ideal[i]);
      //printf("Backpropogation done!\n"); 
    }
    //classify(results);
    /*
      char output_file[64];
      sprintf(output_file, "results_%s.txt", filename);

      FILE *f = Fopen(output_file, "w");
	    
      printf("Results of neural propogation stored in %s\n", output_file);

      for (uint32_t i = 0; i < results->length; i++) {
      char string[64];
      sprintf(string, "Data[%d]: %u\n", i, results->data[i]);
      fputs(string, f);
      }
	
      Fclose(f);

      vector_destroy(results);*/
  }

  printf("\nBackpropogation complete! Testing image 0.bmp:\n");
  vector_t image = read_bitmap("digits/0.bmp");
  vector_t result = evaluate_image(network, image);
  classify(result);
  vector_destroy(result);
  vector_destroy(image);

  printf("\nBackpropogation complete! Testing image 4.bmp:\n");
  image = read_bitmap("digits/4.bmp");
  result = evaluate_image(network, image);
  classify(result);
  vector_destroy(result);
  vector_destroy(image);

  printf("\nBackpropogation complete! Testing image 2.bmp:\n");
  image = read_bitmap("digits/2.bmp");
  result = evaluate_image(network, image);
  classify(result);
  vector_destroy(result);
  vector_destroy(image);

  printf("\nBackpropogation complete! Testing image 9.bmp:\n");
  image = read_bitmap("digits/9.bmp");
  result = evaluate_image(network, image);
  classify(result);
  vector_destroy(result);
  vector_destroy(image);

  printf("\nBackpropogation complete! Testing image 8.bmp:\n");
  image = read_bitmap("digits/8.bmp");
  result = evaluate_image(network, image);
  classify(result);
  vector_destroy(result);
  vector_destroy(image);

  printf("\nBackpropogation complete! Testing image 3.bmp:\n");
  image = read_bitmap("digits/3.bmp");
  result = evaluate_image(network, image);
  classify(result);
  vector_destroy(result);
  vector_destroy(image);

  printf("\nBackpropogation complete! Testing image 1.bmp:\n");
  image = read_bitmap("digits/1.bmp");
  result = evaluate_image(network, image);
  classify(result);
  vector_destroy(result);
  vector_destroy(image);

  printf("\nBackpropogation complete! Testing image 5.bmp:\n");
  image = read_bitmap("digits/5.bmp");
  result = evaluate_image(network, image);
  classify(result);
  vector_destroy(result);
  vector_destroy(image);

  printf("\nBackpropogation complete! Testing image 7.bmp:\n");
  image = read_bitmap("digits/7.bmp");
  result = evaluate_image(network, image);
  classify(result);
  vector_destroy(result);
  vector_destroy(image);

  printf("\nBackpropogation complete! Testing image 6.bmp:\n");
  image = read_bitmap("digits/6.bmp");
  result = evaluate_image(network, image);
  classify(result);
  vector_destroy(result);
  vector_destroy(image);

  network_destroy(network);/*
			     mnist_labels_destroy(mnist_labels);
			     mnist_images_destroy(mnist_data);
			   */
  return 0;
}

