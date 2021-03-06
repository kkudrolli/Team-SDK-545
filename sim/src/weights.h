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
#include <math.h>
#include "err_wrappers.h"
#include "vector.h"
#include "params.h"

struct weightfile {
  vector_t param;
  vector_t **weights;
}; 
typedef struct weightfile* weightfile_t;

weightfile_t initWeights(vector_t param);

/**
 * Returns wegiht vector for dest_neuron.
 */
vector_t getWeights(weightfile_t weightfile, uint32_t layer, uint32_t dest_neuron);

/**
 * Returns wegiht vector for dest_neuron.
 */
vector_t getWeightsFromSrc(weightfile_t weightfile, uint32_t src_layer, uint32_t src_neuron);


/**
 * Sets weights for dest_neuron.
 */
void setWeights(weightfile_t weightfile, uint32_t layer, uint32_t dest_neuron, vector_t weights);

/**
 * Free weightfile
 */
void freeWeightfile(weightfile_t weightfile);

/**
 * Update weightfile wigh a given delta weights
 */
void updateWeightfile(weightfile_t weightfile, uint32_t layer, vector_t* deltaWeights_l);
#endif
