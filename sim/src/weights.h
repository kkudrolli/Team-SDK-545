/*
 * Author: DJ Park
 *
 * Description: This is the header file for weights.c.
 *
 */

#ifndef _WEIGHTS_H_
#define _WEIGHTS_H_

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include "err_wrappers.h"

/**
 * Initialize 3-d weight array when given the number of layers and
 * the number of neurons for each layer. The first argument is the
 * number of layers, and the rest of the arguments are the number of 
 * neurons for each layer. For instance, when there are
 * three layers and each has 2,4,3 neurons respectively, the command
 * for this function would be
 * int*** weightsArray = initWeights(3,2,4,3).
 *
 * weightsArray[1][0][2] accesses the 1st layer's 0th neuron's weight 
 * value to next layer's 2nd neuron.
 *
 * 0th layer to 1st layer, 2x4 array
 * [ - - - -   
 *   - - - - ] 
 * 1st layer to 2nd layer, 4x3 array
 * [ - - *
 *   - - -
 *   - - -
 *   - - - ]
 *
 */
int*** initWeights (int numLayers, ...);

/**
 * This function frees the weight array.
 * freeWeightsArray(weightsArray,3,2,4,3)
 * would free the memory allocated for weightsArray.
 */
void freeWeightsArray(int*** array, int numLayers, ...);
#endif
