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
 * parameter->data[0]=10
 * parameter->data[1]=9, 0th layer
 * parameter->data[2]=10, 1st layer
 * parameter->length=3
 * 10 : the number of pixels
 */
weightfile_t initWeights(vector_t parameter){
    uint32_t i,j,k,numNeurons_prevLayer,numNeurons_currLayer,numLayers,numPixels;
    time_t t;
    srand((unsigned) time(&t));

    numLayers = parameter->length-1; // 2
    numPixels = parameter->data[0];
    assert(numPixels>0);
    //printf("numPixels=%d\n",numPixels);

    numNeurons_prevLayer = 0;

    weightfile_t weightfile = (weightfile_t) Malloc(sizeof(struct weightfile));
    weightfile->param = parameter; // holds the number of layer, how many neurons exist for each layer
    weightfile->weights = (vector_t**) Malloc(sizeof(vector_t*)*(numLayers)); // malloc weights part, in this case 2 layers

    for (i=0 ; i<numLayers; i++){
        numNeurons_currLayer = parameter->data[i+1]; // NOTE that this is i+1
        assert(numNeurons_currLayer>0);
        //printf("numNeurons_currLayer=%d\n",numNeurons_currLayer);
        weightfile->weights[i] = (vector_t*) Malloc(sizeof(vector_t)*numNeurons_currLayer);
        for(j=0 ; j<numNeurons_currLayer; j++){
            if(i==0){ // if it's 0th layer
                weightfile->weights[i][j] = Vector(numPixels);
                for(k = 0; k < numPixels; k++){
                    weightfile->weights[i][j]->data[k] = k*numNeurons_currLayer + j; // 0
#ifdef RAND 
                    weightfile->weights[i][j]->data[k] = (rand()%(1 << 15)) / INPUT_SIZE;
#endif
                }
            }
            else{
                weightfile->weights[i][j] = Vector(numNeurons_prevLayer);
                for(k = 0; k < numNeurons_prevLayer; k++){
                    weightfile->weights[i][j]->data[k] = k*numNeurons_currLayer + j; // 0
#ifdef RAND
                    weightfile->weights[i][j]->data[k] = (rand()%(1 << 15)) / sqrt(NEURONS_PER_TILE);
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
    for(i=0; i<destNeuronLength; i++){
        weights->data[i] = weightfile->weights[src_layer+1][i]->data[src_neuron];
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
      //      if (layer == 0 && j == 7) vprint(weights);
      setWeights(weightfile,layer,j,newWeights);
      //     if (layer == 0 && j == 7) vprint(weights);
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



    vector_t parameter = Vector(3);
    parameter->data[0] = 10;
    parameter->data[1] = 9;
    parameter->data[2] = 10;
    parameter->length = 3; // ONLY TWO LAYERS

    weightfile_t weightfile = initWeights(parameter);
 
    printf("getWeights(weightfile,1,0)->length)=%d\n",getWeights(weightfile,1,0)->length);
    // TEST 0
    printf("getWeights(weightfile,1,0)->data[0]=%d\n",getWeights(weightfile,1,0)->data[0]); // last layer's 1st neuron
    printf("getWeights(weightfile,1,0)->data[8]=%d\n",getWeights(weightfile,1,0)->data[8]); // last layer's 1st neuron
    printf("getWeights(weightfile,1,9)->data[0]=%d\n",getWeights(weightfile,1,9)->data[0]); // last layer's 9th neuron
    printf("getWeights(weightfile,1,9)->data[8]=%d\n",getWeights(weightfile,1,9)->data[8]); // last layer's 9th neuron

    printf("getWeightsFromSrc(weightfile,0,0)->data[0]=%d\n",getWeightsFromSrc(weightfile,0,0)->data[0]); 
    printf("getWeightsFromSrc(weightfile,0,8)->data[0]=%d\n",getWeightsFromSrc(weightfile,0,8)->data[0]);
    printf("getWeightsFromSrc(weightfile,0,0)->data[9]=%d\n",getWeightsFromSrc(weightfile,0,0)->data[9]);
    printf("getWeightsFromSrc(weightfile,0,8)->data[9]=%d\n",getWeightsFromSrc(weightfile,0,8)->data[9]);

    vector_t weights = Vector(9);
    weights->data[0] = 100;
    weights->data[1] = 101;
    weights->data[2] = 102;
    weights->data[3] = 103;
    weights->data[4] = 104;
    weights->data[5] = 105;
    weights->data[6] = 106;
    weights->data[7] = 107;
    weights->data[8] = 108;
 
    setWeights(weightfile,1,0,weights); // TEST 1
    printf("set weights - 0 DONE\n");
    printf("getWeights(weightfile,1,0)->data[0]=%d\n",getWeights(weightfile,1,0)->data[0]); // 100
    printf("getWeights(weightfile,1,0)->data[8]=%d\n",getWeights(weightfile,1,0)->data[8]); // 108
    printf("getWeights(weightfile,1,9)->data[0]=%d\n",getWeights(weightfile,1,9)->data[0]); // 0
    printf("getWeights(weightfile,1,9)->data[8]=%d\n",getWeights(weightfile,1,9)->data[8]); // 0

    printf("getWeightsFromSrc(weightfile,0,0)->data[0]=%d\n",getWeightsFromSrc(weightfile,0,0)->data[0]); // 100
    printf("getWeightsFromSrc(weightfile,0,8)->data[0]=%d\n",getWeightsFromSrc(weightfile,0,8)->data[0]); // 108
    printf("getWeightsFromSrc(weightfile,0,0)->data[9]=%d\n",getWeightsFromSrc(weightfile,0,0)->data[9]); // 0
    printf("getWeightsFromSrc(weightfile,0,8)->data[9]=%d\n",getWeightsFromSrc(weightfile,0,8)->data[9]); // 0

    setWeights(weightfile,1,9,weights); // TEST 2
    printf("set weights - 1 DONE\n");
    printf("getWeights(weightfile,1,0)->data[0]=%d\n",getWeights(weightfile,1,0)->data[0]); // 100
    printf("getWeights(weightfile,1,0)->data[8]=%d\n",getWeights(weightfile,1,0)->data[8]); // 108
    printf("getWeights(weightfile,1,9)->data[0]=%d\n",getWeights(weightfile,1,9)->data[0]); // 100
    printf("getWeights(weightfile,1,9)->data[8]=%d\n",getWeights(weightfile,1,9)->data[8]); // 108

    printf("getWeightsFromSrc(weightfile,0,0)->data[0]=%d\n",getWeightsFromSrc(weightfile,0,0)->data[0]); // 100
    printf("getWeightsFromSrc(weightfile,0,8)->data[0]=%d\n",getWeightsFromSrc(weightfile,0,8)->data[0]); // 108
    printf("getWeightsFromSrc(weightfile,0,0)->data[9]=%d\n",getWeightsFromSrc(weightfile,0,0)->data[9]); // 100
    printf("getWeightsFromSrc(weightfile,0,8)->data[9]=%d\n",getWeightsFromSrc(weightfile,0,8)->data[9]); // 108

    vector_t add = Vector(9);
    add->data[0] = 10;
    add->data[1] = 10;
    add->data[2] = 10;
    add->data[3] = 10;
    add->data[4] = 10;
    add->data[5] = 10;
    add->data[6] = 10;
    add->data[7] = 10;
    add->data[8] = 10;
    vector_t add2 = Vector(9);
    add2->data[0] = 20;
    add2->data[1] = 20;
    add2->data[2] = 20;
    add2->data[3] = 20;
    add2->data[4] = 20;
    add2->data[5] = 20;
    add2->data[6] = 20;
    add2->data[7] = 20;
    add2->data[8] = 20;
 
    vector_t* deltaWeights_l;
    deltaWeights_l = (vector_t*) Malloc(sizeof(vector_t)*10); // update last layer
    uint32_t i;
    for(i=0; i<10; i++){
        if(i==0) deltaWeights_l[i] = add;
        else deltaWeights_l[i] = add2;
    }

    updateWeightfile(weightfile, 1, deltaWeights_l);

    printf("updated weights for layer \n");
    printf("getWeights(weightfile,1,0)->data[0]=%d\n",getWeights(weightfile,1,0)->data[0]); // 110
    printf("getWeights(weightfile,1,0)->data[8]=%d\n",getWeights(weightfile,1,0)->data[8]); // 118
    printf("getWeights(weightfile,1,9)->data[0]=%d\n",getWeights(weightfile,1,9)->data[0]); // 120
    printf("getWeights(weightfile,1,9)->data[8]=%d\n",getWeights(weightfile,1,9)->data[8]); // 128

    printf("getWeightsFromSrc(weightfile,0,0)->data[0]=%d\n",getWeightsFromSrc(weightfile,0,0)->data[0]);
    printf("getWeightsFromSrc(weightfile,0,8)->data[0]=%d\n",getWeightsFromSrc(weightfile,0,8)->data[0]);
    printf("getWeightsFromSrc(weightfile,0,0)->data[9]=%d\n",getWeightsFromSrc(weightfile,0,0)->data[9]);
    printf("getWeightsFromSrc(weightfile,0,8)->data[9]=%d\n",getWeightsFromSrc(weightfile,0,8)->data[9]);

    // FREE

    vector_destroy(weights);
    vector_destroy(add);
    vector_destroy(add2);
    freeWeightfile(weightfile);

    vector_destroy(parameter);

    Free(deltaWeights_l); // deltaWeights_l is not fully freed but anyway..
 
    return 0;
}
*/
