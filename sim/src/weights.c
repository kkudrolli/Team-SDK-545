/*
 * Author: DJ Park
 *
 * Description: Implements a function that initialize 3-d weight array.
 */
#include "weights.h"

/**
 * NOTE: Remember to free returned array.
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
