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
#include <time.h>
#include "err_wrappers.h"
#include "vector.h"

typedef vector_t** weightfile_t;

weightfile_t initWeights(uint32_t numLayersPlusOne, ...);

/**
 * Returns wegiht vector for dest_neuron.
 */
vector_t getWeights(weightfile_t weightfile, uint32_t layer, uint32_t dest_neuron);

/**
 * Sets weights for dest_neuron.
 */
void setWeights(weightfile_t weightfile, uint32_t layer, uint32_t dest_neuron, vector_t weights);

void freeWeightfile(weightfile_t weightfile, uint32_t numLayersPlusOne, ...);
#endif
