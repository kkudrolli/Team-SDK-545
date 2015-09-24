/*
 * Author: Sohil Shah
 *
 * Description: Implements the tile unit of the neural net as well as 
 * its associated neurons
 *
 */

#include "tile.h"
#include "err_wrappers.h"

/**
 * Constructor for a tile: allocates space for tile, sets parameters, and 
 * creates neurons associated with tile. 
 */
tile_t Tile(uint32_t num_neurons, uint32_t num_inputs, uint32_t num_outputs, 
	    uint32_t (*activation_fn)(uint32_t)) {
  tile_t tile = Malloc(sizeof(struct tile));

  tile->num_neurons = num_neurons;
  tile->num_inputs = num_inputs;
  tile->num_outputs = num_outputs;
  tile->neurons = Calloc(num_neurons, sizeof(neuron_t));

  for (uint32_t i = 0; i < num_neurons; ++i) {
    neuron_t neuron = Neuron(num_inputs, activation_fn);    
    tile->neurons[i] = neuron;
  }

  return tile;
}

/**
 * Destructor for a tile: destroys neurons accociated with tile and frees
 * data structures allocated to tile. 
 */
void tile_destroy(tile_t tile) {
  for (uint32_t i = 0; i < tile->num_neurons; ++i) {
    neuron_destroy(tile->neurons[i]);
  }

  Free(tile->neurons);
  Free(tile);
}

/**
 * Constructor for a neuron: allocates space for the neuron and sets parameters
 * relevent to the neuron. 
 */
neuron_t Neuron(uint32_t input_len, uint32_t (*activation_fn)(uint32_t)) {
  neuron_t neuron = Malloc(sizeof(struct neuron));

  neuron->input_len = input_len;
  neuron->activation_fn = activation_fn;
  
  return neuron;
}

/**
 * Computes the output of a neuron given its activation function by performing a 
 * vector dot product of the input and weights. This is then summed and 
 * passed through the activation function. 
 */
uint32_t evaluate_neuron(neuron_t neuron, vector_t input, vector_t weights) {
  uint32_t sum = vmad(input, weights);  
  return (neuron->activation_fn)(sum);
}

void neuron_destroy(neuron_t neuron) {
  Free(neuron);
}
