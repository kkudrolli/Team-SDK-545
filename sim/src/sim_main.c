#include <stdio.h> 

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
    return 0;
    
}
