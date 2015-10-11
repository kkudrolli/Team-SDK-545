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

uint32_t linear_interpolation(uint32_t input) {
  return input;
}

vector_t evaluate_image (vector_t image) {
  tile_t tile_in = Tile(NEURONS_PER_TILE, image->length, &linear_interpolation, 0);
  tile_t tile_h1 = Tile(NEURONS_PER_TILE, NEURONS_PER_TILE, &linear_interpolation, 1);
  tile_t tile_h2 = Tile(NEURONS_PER_TILE, NEURONS_PER_TILE, &linear_interpolation, 2);
  tile_t tile_out = Tile(10, NEURONS_PER_TILE, &linear_interpolation, 3);

  weightfile_t weights = initWeights(5, image->length, NEURONS_PER_TILE, NEURONS_PER_TILE, 
				     NEURONS_PER_TILE, NEURONS_PER_TILE);

  printf("Propogating tile 1...");
  vector_t data = evaluate_tile(tile_in, image, weights);
  printf("done!\nPropogating tile 2...");
  vector_t data1 = evaluate_tile(tile_h1, data, weights);
  printf("done!\nPropogating tile 3...");
  vector_t data2 = evaluate_tile(tile_h2, data1, weights);
  printf("done!\nPropogating tile 4...");
  vector_t data3 = evaluate_tile(tile_out, data2, weights);
  printf("done!\n\nAll tiles propogated!\n\n");

  vector_destroy(data);
  vector_destroy(data1);
  vector_destroy(data2);
  tile_destroy(tile_in);
  tile_destroy(tile_h1);
  tile_destroy(tile_h2);
  tile_destroy(tile_out);
  freeWeightfile(weights, 5, image->length, NEURONS_PER_TILE, NEURONS_PER_TILE, NEURONS_PER_TILE, 
		 NEURONS_PER_TILE);

  return data3;
}
