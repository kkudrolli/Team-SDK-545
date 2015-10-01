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
#include "vector.h"

typedef vector_t** weightfile_t;

/**
 * Initializes weightfile when given the number of layers and
 * the number of neurons for each layer. The first argument is the
 * number of layers, and the rest of the arguments are the number of 
 * neurons for each layer. For instance, when there are
 * three layers and each has 2,4,3 neurons respectively, the command
 * for this function would be
 * weightfile_t weightfile = initWeights(3,2,4,3).
 *
 * getWeights(weightfile,1,0)->data accesses all the weight values to the 1st layer's 0th neuron.
 * getWeights(weightfile,1,0)->length should be same as the number of neurons in 0th layer
 *
 */
weightfile_t initWeights(uint32_t numLayers, ...);

/**
 * Returns wegiht vector for dest_neuron.
 */
vector_t getWeights(weightfile_t weightfile, uint32_t layer, uint32_t dest_neuron);

/**
 * Sets weights for dest_neuron.
 */
void setWeights(weightfile_t weightfile, uint32_t layer, uint32_t dest_neuron, vector_t weights);

/**
 * This function frees the weightfile.
 * freeWeightfile(weightfile,3,2,4,3)
 * would free the memory allocated for weightfile.
 */
void freeWeightfile(weightfile_t weightfile, uint32_t numLayers, ...);
#endif
