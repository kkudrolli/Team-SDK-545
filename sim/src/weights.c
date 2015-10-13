/*
 * Author: DJ Park
 *
 * Description: Implements a function that initialize 3-d weight array and a function
 * that frees the weight array.
 */
#include "weights.h"
#define RAND

/**
 * NOTE: Remember to free returned weightfile.
 *
 * ex) initWeights(parameter)
 * parameter->data[0]=100
 * parameter->data[1]=1024, 0th layer
 * parameter->data[2]=1024, 1st layer
 * parameter->data[3]=1024, 2nd layer
 * parameter->data[4]=10, 3rd layer
 * parameter->length=5
 * 100 : the number of pixels
 */
weightfile_t initWeights(vector_t parameter){
    uint32_t i,j,k,numNeurons_prevLayer,numNeurons_currLayer,numLayers,numPixels;
    time_t t;
    srand((unsigned) time(&t));

    numLayers = parameter->length-1;
    numPixels = parameter->data[0];
    assert(numPixels>0);
    //printf("numPixels=%d\n",numPixels);

    numNeurons_prevLayer = 0;

    weightfile_t weightfile = (weightfile_t) Malloc(sizeof(struct weightfile));
    weightfile->param = parameter; // holds the number of layer, how many neurons exist for each layer
    weightfile->weights = (vector_t**) Malloc(sizeof(vector_t*)*(numLayers)); // malloc weights part

    for (i=0 ; i<numLayers; i++){
        numNeurons_currLayer = parameter->data[i+1]; // NOTE that this is i+1
        assert(numNeurons_currLayer>0);
        //printf("numNeurons_currLayer=%d\n",numNeurons_currLayer);
        weightfile->weights[i] = (vector_t*) Malloc(sizeof(vector_t)*numNeurons_currLayer);
        for(j=0 ; j<numNeurons_currLayer; j++){
            if(i==0){ // if it's 0th layer
                weightfile->weights[i][j] = Vector(numPixels);
                for(k = 0; k < numPixels; k++){
                    weightfile->weights[i][j]->data[k] = 2; // 0
#ifdef RAND 
                    weightfile->weights[i][j]->data[k] = rand(); // random value between 0,50
#endif
                  

                }
            }
            else{
                weightfile->weights[i][j] = Vector(numNeurons_prevLayer);
                for(k = 0; k < numNeurons_prevLayer; k++){
                    weightfile->weights[i][j]->data[k] = 2; // 0
#ifdef RAND
                    weightfile->weights[i][j]->data[k] = rand(); // random value between 0,50
#endif
                }
            }
        }
        numNeurons_prevLayer = numNeurons_currLayer;
    }

    return weightfile;
}

/**
 * Returns weight vector for dest_neuron.
 */
vector_t getWeights(weightfile_t weightfile, uint32_t layer, uint32_t dest_neuron){
    return weightfile->weights[layer][dest_neuron];
}

/**
 * Returns weight vector for src_neuron.
 * NOTE: Remember to free generated weights.
 */
vector_t getWeightsFromSrc(weightfile_t weightfile, uint32_t src_layer, uint32_t src_neuron){
    assert(src_layer+2 < weightfile->param->length);
    uint32_t i,destNeuronLength;
    destNeuronLength = weightfile->param->data[src_layer+2]; // 10
    vector_t weights = Vector(destNeuronLength);
    for(i=0; i<destNeuronLength; i++){ // 1024
        weights->data[i] = getWeights(weightfile,src_layer,i)->data[src_neuron];
    }
    return weights;
}

/**
 * Sets weights for dest_neuron.
 */
void setWeights(weightfile_t weightfile, uint32_t layer, uint32_t dest_neuron, vector_t weights){
    assert(weightfile->weights[layer][dest_neuron]->length==weights->length);

    for(size_t i = 0; i < weights->length; i++){
        weightfile->weights[layer][dest_neuron]->data[i] = weights->data[i];
    }
}

/**
 * Frees weightfile struct
 */
void freeWeightfile(weightfile_t weightfile){
    uint32_t i,j,numNeurons_currLayer,numPixels,numLayers;

    numLayers = weightfile->param->length-1;
    numPixels = weightfile->param->data[0]; // number of pixels of the image
    assert(numPixels>0);
    //printf("numPixels=%d, numLayers=%d\n",numPixels,numLayers);

    for (i=0; i < numLayers; i++){
        numNeurons_currLayer = weightfile->param->data[i+1]; // NOTE that this is i+1
        //printf("numNeurons_currLayer=%d\n",numNeurons_currLayer);
        for(j=0; j<numNeurons_currLayer; j++){
            vector_destroy(weightfile->weights[i][j]); // free neurons in current layer
        }
        Free(weightfile->weights[i]); // free current layer
    }
    vector_destroy(weightfile->param);
    Free(weightfile->weights); // free node
    Free(weightfile);
}

/**
 * Update weightfile for a specific layer
 */
void updateWeightfile(weightfile_t weightfile, uint32_t layer, vector_t* deltaWeights_l){
    uint32_t j,numNeurons_dest;
    vector_t weights;
    vector_t newWeights;
    numNeurons_dest  = weightfile->param->data[layer+1];

    for(j=0; j<numNeurons_dest; j++){
        weights = getWeights(weightfile,layer,j);
        newWeights = vadd(weights,deltaWeights_l[j]);
        setWeights(weightfile,layer,j,newWeights);
        vector_destroy(newWeights);
    }
}

/**
 * TEST
 */
/*
int main(){

    vector_t parameter = Vector(4);
    parameter->data[0] = 100;
    parameter->data[1] = 1024;
    parameter->data[2] = 512;
    parameter->data[3] = 256;
    parameter->length = 4;

    weightfile_t weightfile = initWeights(parameter);

    printf("getWeights(weightfile,0,0)->data[0]=%d\n",getWeights(weightfile,0,0)->data[0]);
    printf("getWeights(weightfile,0,0)->data[99]=%d\n",getWeights(weightfile,0,0)->data[99]);
   
    printf("getWeights(weightfile,0,1023)->data[0]=%d\n",getWeights(weightfile,0,1023)->data[0]);
    printf("getWeights(weightfile,2,0)->data[0]=%d\n",getWeights(weightfile,2,0)->data[0]);
    vector_t weights = Vector(100);
    weights->data[0] = 100;
    weights->data[1] = 101;
    weights->data[2] = 102;
    setWeights(weightfile,0,0,weights);
    setWeights(weightfile,0,1,weights); 
 
    setWeights(weightfile,0,1023,weights);
    setWeights(weightfile,0,1022,weights);
    setWeights(weightfile,0,1021,weights);

    printf("getWeights(weightfile,0,1023)->data[0]=%d\n",getWeights(weightfile,0,1023)->data[0]);
    printf("getWeights(weightfile,0,1023)->data[1]=%d\n",getWeights(weightfile,0,1023)->data[1]);
    printf("getWeightsFromSrc,0,0->data[0]=%d\n",getWeightsFromSrc(weightfile, 0, 0)->data[0]);
    printf("getWeightsFromSrc,0,0->data[1]=%d\n",getWeightsFromSrc(weightfile, 0, 0)->data[1]);
    printf("getWeightsFromSrc,0,0->data[99]=%d\n",getWeightsFromSrc(weightfile, 0, 0)->data[99]);
 
    printf("get here1\n");


    vector_destroy(weights);
    printf("get here2\n");
 
 
    freeWeightfile(weightfile);
    printf("get here3\n");
 
    vector_destroy(parameter);
    printf("get here4\n");

    return 0;
}
*/
