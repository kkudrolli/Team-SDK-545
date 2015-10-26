#include "Vdeep.h"

int main (int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  Vdeep* top = new Vdeep;

  while (!Verilated::gotFinish()) {
    top->a = 1;
    top->b = 2;
    top->eval();
    printf("a: %d, b: %d | c: %d\n", top->a, top->b, top->c);
    top->a = 3;
    top->b = 4;

    top->eval();
    printf("a: %d, b: %d | c: %d\n", top->a, top->b, top->c);
    top->a = 7;
    top->b = 12;

    top->eval();
    printf("a: %d, b: %d | c: %d\n", top->a, top->b, top->c);
    top->a = 33;
    top->b = 94;

    top->eval();   
    printf("a: %d, b: %d | c: %d\n", top->a, top->b, top->c);
    
    break;
  }
  delete top;
  exit(0);
}
