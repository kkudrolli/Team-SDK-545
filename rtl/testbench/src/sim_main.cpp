#include "Vdeep.h"
#include "Vdeep_deep.h"
#include "Vdeep_weights.h"
#include "mnist.h"
#include "image_io.h"
#include "err_wrappers.h"
#include "classify.h"

int main (int argc, char **argv) {

  Verilated::commandArgs(argc, argv);
  Vdeep* top = new Vdeep;

  mnist_images_t mnist_data = read_images(1);

  mnist_labels_t mnist_labels = read_labels(1);

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
    
    while (true) {

      time += 5;

      top->clk = !(top->clk);
      top->eval();

      if (top->done) {
	for (uint32_t i = 0; i < 10; i++) result->data[i] = top->result[i];
	printf(BOLD "\nTesting image of %d:\n" NORMAL, mnist_labels->labels->data[k]);
	int classification = classify(result, 0);
	if (classification == mnist_labels->labels->data[k]) correct++;
	else mistakes[mnist_labels->labels->data[k]][classification]++;
	break;
      }

    }

    top->rst = 1;
    top->eval();
    top->rst = 0;
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

  printf(BOLD UNDERLINE "\n\nFINAL RESULTS: Success rate: %2.1f%% (%d correct, %d incorrect)" NORMAL, 
	 (float)correct*100 / (float)MNIST_TEST_IMAGES, correct, MNIST_TEST_IMAGES - correct);
  printf(BOLD "\n\nMost common mistake: %d mistaken for a %d (%d times)\n\n" NORMAL, err_actual, 
	 err_predic, max_err);

  printf("Finished at time %d!\n", time);
  
  delete top;
  exit(0);
}
