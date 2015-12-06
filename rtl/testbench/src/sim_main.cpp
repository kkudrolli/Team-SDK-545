#include "Vdeep.h"
#include "Vdeep_deep.h"
#include "Vdeep_weights.h"
#include "mnist.h"
#include "image_io.h"
#include "err_wrappers.h"
#include "classify.h"
#include "center.h"

int main (int argc, char **argv) {

  Verilated::commandArgs(argc, argv);
  Vdeep* top = new Vdeep;

  mnist_images_t mnist_data = read_images(0);

  mnist_labels_t mnist_labels = read_labels(0);

  int time = 0;

  top->clk = 1;
  top->rst = 0;
  top->eval();
  top->rst = 1;
  top->eval();
  top->rst = 0;
  top->eval();


  // Initialize weights file
  FILE *weight_vals;
  
  weight_vals = fopen(IMPORT_FILE, "rb");

  for (uint32_t i = 0; i < 128; i++)
    for (uint32_t j = 0; j < 784; j++)
      fread(&(top->v->wf->douta_0[i + 128*j]), sizeof(uint32_t), 1, weight_vals); // initialize weight_0
  
  for (uint32_t i = 0; i < 10; i++)
    for (uint32_t j = 0; j < 128; j++)
      fread(&(top->v->wf->douta_1[i + 10*j]), sizeof(uint32_t), 1, weight_vals); // initialize weight_1

  fclose(weight_vals);
  

  vector_t result = Vector(10);

#ifdef MODE_MNIST
  int correct = 0;
  int mistakes[10][10];
  for (int i = 0; i < 10; i++)
    for(int j = 0; j < 10; j++)
      mistakes[i][j] = 0;
  
  for (int k = 0; k < MNIST_TEST_IMAGES; k++) {
    top->start = 1;
    for (int i = 0; i < 784; i++) {	
      top->image_in[i] = mnist_data->imgs[k]->data[i];
    }

    for (uint32_t j = 0; j < 28; j++) {
      for (uint32_t i = 0; i < 28; i++) {
	if (top->image_in[i+28*j] >> 9 > 20) printf(GREEN BOLD "%02x " NORMAL, top->image_in[i+28*j] >> 9);
	else printf("%02x ", top->image_in[i+28*j] >> 9);
      }
      printf("\n");
    }

    while (true) {

      time += 5;

      top->clk = !(top->clk);
      top->eval();

      if (top->done) {
	top->start = 0;
	for (int i = 0; i < 10; i++) result->data[i] = top->result[i];
	printf(BOLD "\nTesting image of %d:\n" NORMAL, mnist_labels->labels->data[k]);
	int classification = classify(result, 0);
	if (classification == mnist_labels->labels->data[k]) correct++;
	else mistakes[mnist_labels->labels->data[k]][classification]++;
	break;
      }
    }

    top->clk = !(top->clk);
    top->eval();    
  }

  int err_actual = 0;
  int err_predic = 0;
  int max_err = 0;
  for (int i = 0; i < 10; i++)
    for (int j = 0; j < 10; j++)
      if (mistakes[i][j] > max_err) {
	err_actual = i;
	err_predic = j;
	max_err = mistakes[i][j];
      }

  
  printf(BOLD UNDERLINE "\nError counts: (col: predicted, row: actual)\n" NORMAL);
  printf(BOLD "[0] [1] [2] [3] [4] [5] [6] [7] [8] [9]\n" NORMAL);
  for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++)
      printf("%-3d ", mistakes[i][j]);
    printf(BOLD " [%d]\n" NORMAL, i);
  }

  printf(BOLD UNDERLINE "\n\nFINAL RESULTS: Success rate: %2.1f%% (%d correct, %d incorrect)" NORMAL, 
	 (float)correct*100 / (float)MNIST_TEST_IMAGES, correct, MNIST_TEST_IMAGES - correct);
  printf(BOLD "\n\nMost common mistake: %d mistaken for a %d (%d times)\n\n" NORMAL, err_actual, 
	 err_predic, max_err);

#else

  DIR *dir_ptr = Opendir(TEST_DIR);
  struct dirent *entry_ptr = NULL;
  if (!dir_ptr) {
    error_print(BOLD RED "Directory error" NORMAL);
  }

  
  while ((entry_ptr = readdir(dir_ptr))) {
    // Get name of file and append it to directory name
    char *filename = entry_ptr->d_name;
    if (filename[0] != '.') {
      size_t path_len = strlen(filename) + strlen(TEST_DIR) + 1;
      char full_path[path_len];
      snprintf(full_path, path_len, "%s%s", TEST_DIR, filename);
      
      // Read bitmap data 
      vector_t image_data = read_bitmap(full_path);
      image_data = center(image_data);
	  
      top->start = 1;
      for (int i = 0; i < 784; i++) {	
	top->image_in[i] = image_data->data[i];
      }
    
      while (true) {
	time += 5;

	top->clk = !(top->clk);
	top->eval();

	if (top->done) {
	  top->start = 0;
	  for (int i = 0; i < 10; i++) result->data[i] = top->result[i];
	  printf(BOLD "\nTesting centered image of %s:\n" NORMAL, full_path);
	  for (uint32_t j = 0; j < 28; j++) {
	    for (uint32_t i = 0; i < 28; i++) {
	      if (image_data->data[i+28*j] >> 9 > 20) printf(GREEN BOLD "%02x " NORMAL, image_data->data[i+28*j] >> 9);
	      else printf("%02x ", image_data->data[i+28*j] >> 9);
	    }
	    printf("\n");
	  }
	  int classification = classify(result, 0);
	  break;
	}
      }

      vector_destroy(image_data);
    }
  }
  Closedir(dir_ptr);  
  
#endif

  printf("Finished at time %d!\n", time);
  
  delete top;
  exit(0);
}
