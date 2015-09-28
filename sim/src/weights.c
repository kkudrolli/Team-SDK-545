/*
 * Author: DJ Park
 *
 * Description: Implements a function that initialize 3-d weight array and a function
 * that frees the weight array.
 */
#include "weights.h"

/**
 * NOTE: Remember to free returned array. The number of arguments for this function
 * should be numLayers+1.
 */
int*** initWeights (int numLayers, ... ){
    va_list arguments;
    int i,j,k,numNeurons_prevLayer, numNeurons_currLayer;

    va_start ( arguments, numLayers);
    int *** array = (int***) Malloc(sizeof(int**)*(numLayers-1));
    for (i=0; i<numLayers; i++){
        numNeurons_currLayer = va_arg (arguments, int);
        if(i!=0){ // there are total numLayers-1 2-d array
            array[i-1] = (int**) Malloc(sizeof(int*)*numNeurons_prevLayer);
            for(j=0; j<numNeurons_prevLayer; j++){
               array[i-1][j] = (int*) Malloc(sizeof(int)*numNeurons_currLayer);
               for(k=0; k<numNeurons_currLayer; k++){
                   array[i-1][j][k] = 1; // initialize as 1
               }
            }
        }
        numNeurons_prevLayer = numNeurons_currLayer;
    }
    va_end (arguments);

    return array;
}

/**
 * NOTE: The number of arguments for this function should be numLayers+2 because
 * the first argument is the weight array, second one is number of layers, and the
 * rest of them are the number of neurons for each layer.
 */
void freeWeightsArray(int*** array, int numLayers, ...){
    va_list arguments;
    int i,j,k,numNeurons_prevLayer,numNeurons_currLayer;

    va_start (arguments, numLayers);
    for (i=0; i < numLayers; i++){
        numNeurons_currLayer = va_arg (arguments, int);
        if(i!=0){
            for(j=0; j<numNeurons_prevLayer; j++){
               free(array[i-1][j]); // free each neuron
            }
            free(array[i-1]); // free each layer
        }
        numNeurons_prevLayer = numNeurons_currLayer;
    }
    va_end ( arguments );
    free(array); // free the root
}
