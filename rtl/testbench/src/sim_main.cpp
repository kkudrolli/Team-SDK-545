#include "Vdeep.h"
#include "mnist.h"
#include "image_io.h"
#include "err_wrappers.h"

int main (int argc, char **argv) {

  Verilated::commandArgs(argc, argv);
  Vdeep* top = new Vdeep;

  mnist_images_t mnist_data = read_images(1);
  mnist_images_t mnist_test = read_images(0);

  mnist_labels_t mnist_labels = read_labels(1);
  mnist_labels_t mnist_test_l = read_labels(0);

  int time = 0;

  top->clk = 0;
  top->rst = 0;
  top->eval();
  top->rst = 1;
  top->eval();
  top->rst = 0;
  top->eval();

  while (!Verilated::gotFinish()) {

    time+=5;

    top->clk = !(top->clk);
    top->eval();

    if (time == 20) {
      top->start = 1;
      for (int i = 0; i < 784; i++)
	top->image_in[i] = mnist_data->imgs[0]->data[i];
    }
    
    if (top->done || time == 10000) break;
  }
  
  printf("Finished at time %d! | result: [%d %d %d %d %d %d %d %d %d %d]\n", time,
	 top->result[0], top->result[1], top->result[2], top->result[3], top->result[4], 
	 top->result[5], top->result[6], top->result[7], top->result[8], top->result[9]);
  
  delete top;
  exit(0);
}
