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

  mnist_images_t mnist_data = read_images(0);

  mnist_labels_t mnist_labels = read_labels(0);

  int time = 0;

  top->clk = 1;
  top->rst = 0;
  top->eval();
  top->rst = 1;
  top->eval();
  top->rst = 0;


  // Initialize weights file
  FILE *weight_vals;
  char weight_init[] = "networks/ideal.deep";
  
  weight_vals = fopen(weight_init,"rb");

  for (uint32_t i = 0; i < 128; i++)
    for (uint32_t j = 0; j < 784; j++)
      fread(&(top->v->wf->douta_0[i + 128*j]), sizeof(uint32_t), 1, weight_vals); // initialize weight_0
  
  for (uint32_t i = 0; i < 10; i++)
    for (uint32_t j = 0; j < 128; j++)
      fread(&(top->v->wf->douta_1[i + 10*j]), sizeof(uint32_t), 1, weight_vals); // initialize weight_1

  fclose(weight_vals);
  

  
  while () {

    time+=5;

    top->clk = !(top->clk);
    top->eval();    

    if (time == 20) {
      top->start = 1;
      for (int i = 0; i < 784; i++) {	
	top->image_in[i] = mnist_data->imgs[0]->data[i];
      }
    }
    
    if (top->done || time == 1000000) break;
  }
  
  printf("Finished at time %d!\n", time);
  
  delete top;
  exit(0);
}
