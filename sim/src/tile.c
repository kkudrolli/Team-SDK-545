/*
 * Author: Sohil Shah
 *
 * Description: Implements the tile unit of the neural net as well as 
 * its associated neurons
 *
 */

#include "tile.h"

/**
 * Constructor for a tile: allocates space for tile, sets parameters, and 
 * creates neurons associated with tile. 
 */
tile_t Tile(uint32_t num_neurons, uint32_t num_inputs, 
	    uint32_t (*activation_fn)(uint32_t), uint32_t tile_index) {
  tile_t tile = Malloc(sizeof(struct tile));

  tile->num_neurons = num_neurons;
  tile->num_inputs = num_inputs;
  tile->neurons = Calloc(num_neurons, sizeof(neuron_t));
  tile->tile_index = tile_index;

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

vector_t evaluate_tile(tile_t tile, vector_t input, weightfile_t weights) {
  vector_t v = Vector(tile->num_neurons);
  for (uint32_t i = 0; i < tile->num_neurons; ++i) {
    v->data[i] = evaluate_neuron(tile->neurons[i], input, getWeights(weights, tile->tile_index, i));
  }
  return v;
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

network_t Network(uint32_t num_layers, uint32_t num_inputs, uint32_t num_outputs, 
		  uint32_t (*activation_fn)(uint32_t)) {
  assert(num_layers > 0);
  assert(num_inputs > 0);
  assert(num_outputs > 0);

  printf("Creating network...\n");
  network_t network = Malloc(sizeof(struct network));
  network->num_layers = num_layers;
  network->tiles = Calloc(sizeof(tile_t), num_layers);

  uint32_t i;

  vector_t param = Vector(num_layers+1);
  param->data[0] = num_inputs;
  printf("Allocating layer 0...\n");
  network->tiles[0] = Tile(NEURONS_PER_TILE, num_inputs, activation_fn, 0);
  for (i = 1; i < num_layers-1; i++) {
    param->data[i] = NEURONS_PER_TILE;
    printf("Allocating layer %d...\n", i);
    network->tiles[i] = Tile(NEURONS_PER_TILE, NEURONS_PER_TILE, activation_fn, i);
  }
  param->data[i] = NEURONS_PER_TILE;
  param->data[i+1] = NEURONS_PER_TILE;
  printf("Allocating layer %d...\n", i);
  network->tiles[i] = Tile(num_outputs, NEURONS_PER_TILE, activation_fn, i);

  printf("Initializing weights file...\n");
  network->weights = initWeights(param);

  return network;
}

void network_destroy(network_t network) {  
  for (uint32_t i = 0; i < network->num_layers; i++) {
    tile_destroy(network->tiles[i]);
  }
  Free(network->tiles);

  freeWeightfile(network->weights);
  Free(network);
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

vector_t evaluate_image (network_t network, vector_t image) {
  assert(network->tiles[0]->num_inputs == image->length);

  vector_t hidden, output;
  
  printf("Evaluating tile 0...\n");
  hidden = evaluate_tile(network->tiles[0], image, network->weights);
  output = hidden;
  for (uint32_t i = 1; i < network->num_layers; i++) {
    printf("Evaluating tile %d...\n", i);
    output = evaluate_tile(network->tiles[i], hidden, network->weights);
    vector_destroy(hidden);
    hidden = output;
  }

  return output;
}
