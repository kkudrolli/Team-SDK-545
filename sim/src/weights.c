/*
 * Author: DJ Park
 *
 * Description: Implements a function that initialize 3-d weight array and a function
 * that frees the weight array.
 */
#include "weights.h"

/**
 * NOTE: Remember to free returned weightfile.
 *
 * ex) initWeights(4, 100, 1024, 512, 256) when image size is 10x10
 * 4: the number of layers + 1, think this number as the number of arguments after it.
 * 100 : the number of pixels
 */
weightfile_t initWeights(uint32_t numLayersPlusOne, ...){

    va_list arguments;
    uint32_t i,j,k,numNeurons_prevLayer,numNeurons_currLayer,numPixels,numLayers;
    time_t t;
    srand((unsigned) time(&t));

    va_start (arguments, numLayersPlusOne); // start receiving arguments
    numPixels = va_arg (arguments, uint32_t); // number of pixels of the image
    assert(numPixels>0);
    numLayers = numLayersPlusOne-1;
    //printf("numPixels=%d\n",numPixels);

    numNeurons_prevLayer = 0;

    weightfile_t weightfile = (weightfile_t) Malloc(sizeof(vector_t*)*(numLayers));
    for (i=0 ; i<numLayers; i++){
        numNeurons_currLayer = va_arg(arguments, uint32_t);
        assert(numNeurons_currLayer>0);
        //printf("numNeurons_currLayer=%d\n",numNeurons_currLayer);
        weightfile[i] = (vector_t*) Malloc(sizeof(vector_t)*numNeurons_currLayer);
        for(j=0 ; j<numNeurons_currLayer; j++){
            if(i==0){ // if it's 0th layer
                weightfile[i][j] = Vector(numPixels);
                for(k = 0; k < numPixels; k++){
                    weightfile[i][j]->data[k] = rand()%50; // random value between 0,50
                }
            }
            else{
                weightfile[i][j] = Vector(numNeurons_prevLayer);
                for(k = 0; k < numNeurons_prevLayer; k++){
                    weightfile[i][j]->data[k] = rand()%50; // random value between 0,50
                }
            }
        }
        numNeurons_prevLayer = numNeurons_currLayer;
    }

    va_end (arguments); // end receiving arguments
    return weightfile;
}

/**
 * Returns weight vector for dest_neuron.
 */
vector_t getWeights(weightfile_t weightfile, uint32_t layer, uint32_t dest_neuron){
    return weightfile[layer][dest_neuron];
}

/**
 * Sets weights for dest_neuron.
 */
void setWeights(weightfile_t weightfile, uint32_t layer, uint32_t dest_neuron, vector_t weights){
    assert(weightfile[layer][dest_neuron]->length==weights->length);

    for(size_t i = 0; i < weights->length; i++){
        weightfile[layer][dest_neuron]->data[i] = weights->data[i];
    }
    weightfile[layer][dest_neuron]->length = weights->length;
}

/**
 * ex) freeWeightfile(weightfile, 4, 100, 1024, 512, 256) when image size is 10x10
 * 4: the number of layers + 1, think this number as the number of arguments after it.
 * 100: the number of pixels
 */
void freeWeightfile(weightfile_t weightfile, uint32_t numLayersPlusOne, ...){
    va_list arguments;
    uint32_t i,j,numNeurons_currLayer,numPixels,numLayers;

    va_start (arguments, numLayersPlusOne);
    numPixels = va_arg (arguments, uint32_t); // number of pixels of the image
    assert(numPixels>0);
    numLayers = numLayersPlusOne-1;
    //printf("numPixels=%d, numLayers=%d\n",numPixels,numLayers);

    for (i=0; i < numLayers; i++){
        numNeurons_currLayer = va_arg (arguments, uint32_t);
        for(j=0; j<numNeurons_currLayer; j++){
            vector_destroy(weightfile[i][j]); // free neurons in current layer
        }
        Free(weightfile[i]); // free current layer
    }
    va_end (arguments);
    Free(weightfile); // free node
}


/**
 * TEST
 */
/*
int main(){
    weightfile_t weightfile = initWeights(4,100,1024,512,256);

    printf("getWeights(weightfile,0,0)->data[0]=%d\n",getWeights(weightfile,0,0)->data[0]);
    printf("getWeights(weightfile,0,0)->data[99]=%d\n",getWeights(weightfile,0,0)->data[99]);
   
    printf("getWeights(weightfile,0,1023)->data[0]=%d\n",getWeights(weightfile,0,1023)->data[0]);
    printf("getWeights(weightfile,2,0)->data[0]=%d\n",getWeights(weightfile,2,0)->data[0]);
    vector_t weights = Vector(100);
    weights->data[0] = 100;
    weights->data[1] = 101;
    weights->data[2] = 102;
    setWeights(weightfile,0,1023,weights);
    setWeights(weightfile,0,1022,weights);
    setWeights(weightfile,0,1021,weights);

    printf("getWeights(weightfile,0,1023)->data[0]=%d\n",getWeights(weightfile,0,1023)->data[0]);
    printf("getWeights(weightfile,0,1023)->data[1]=%d\n",getWeights(weightfile,0,1023)->data[1]);
 
    vector_destroy(weights);

    freeWeightfile(weightfile,4,100,1024,512,256);
   
    return 0;
}
*/
