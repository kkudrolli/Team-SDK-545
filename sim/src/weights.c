/*
 * Author: DJ Park
 *
 * Description: Implements a function that initialize 3-d weight array and a function
 * that frees the weight array.
 */
#include "weights.h"

/**
 * NOTE: Remember to free returned weightfile. The number of arguments for this function
 * should be numLayers+1.
 */
weightfile_t initWeights(uint32_t numLayers, ...){

    va_list arguments;
    uint32_t i,j,numNeurons_prevLayer, numNeurons_currLayer;

    va_start (arguments, numLayers);
    weightfile_t weightfile = (weightfile_t) Malloc(sizeof(vector_t*)*(numLayers-1));
    for ( i=0; i < numLayers; i++ ){
        numNeurons_currLayer = va_arg (arguments, uint32_t);
        if(i!=0){
            weightfile[i-1] = (vector_t*) Malloc(sizeof(vector_t)*numNeurons_currLayer);
            for(j=0; j<numNeurons_currLayer; j++){
               weightfile[i-1][j] = Vector(numNeurons_prevLayer);
            }
        }
        numNeurons_prevLayer = numNeurons_currLayer;
    }
    va_end (arguments);
    return weightfile;
}

/**
 * REQUIRES layer > 0
 */
vector_t getWeights(weightfile_t weightfile, uint32_t layer, uint32_t dest_neuron){
    assert(layer>0);

    return weightfile[layer-1][dest_neuron];
}

/**
 * REQUIRES layer > 0
 */
void setWeights(weightfile_t weightfile, uint32_t layer, uint32_t dest_neuron, vector_t weights){
    assert(layer>0);
    assert(sizeof(weightfile[layer-1][dest_neuron])==sizeof(weights));

    for(size_t i = 0; i < weights->length; i++){
        weightfile[layer-1][dest_neuron]->data[i] = weights->data[i];
    }
    weightfile[layer-1][dest_neuron]->length = weights->length;
}

/**
 * NOTE: The number of arguments for this function should be numLayers+2 because
 * the first argument is weightfile, second one is the number of layers, and the
 * rest of them are the number of neurons for each layer.
 */
void freeWeightfile(weightfile_t weightfile, uint32_t numLayers, ...){
    va_list arguments;
    uint32_t i,j,numNeurons_currLayer;

    va_start (arguments, numLayers);
    for (i=0; i < numLayers; i++){
        numNeurons_currLayer = va_arg (arguments, uint32_t);
        if(i!=0){
            for(j=0; j<numNeurons_currLayer; j++){
               vector_destroy(weightfile[i-1][j]); // free neurons in current layer
            }
            Free(weightfile[i-1]); // free current layer
        }
    }
    va_end (arguments);
    Free(weightfile); // free node
}
