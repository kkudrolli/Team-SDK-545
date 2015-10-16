/*
 * Author: Sohil Shah
 *
 * Description: This is the header file for tile.c. Contains definitions of 
 * structures and constants relevant to the tiles. 
 *
 */

#ifndef _TILE_H
#define _TILE_H

#include "vector.h"
#include "err_wrappers.h"
#include "weights.h"
#include "params.h"

/**
 * Basic structure of a neuron. Contains the following parameters:
 *     -> input_len: size of the vector being input to this particular neuron. 
 *     -> activation_fn: the function that defines how a particular input
 *                       value is mapped to a particular output value by 
 *                       this neuron
 *     
 * The neuron sub unit represents an individual neuron in a tile. This unit is
 * responsible for computing an activation dependent on the input vector and
 * a weight file. 
 */
struct neuron {
  uint32_t input_len;
  uint32_t (*activation_fn)(uint32_t);
};
typedef struct neuron* neuron_t;

/**
 * Basic structure of a tile. Contains the following parameters:
 *     -> num_neurons: number of neurons associated with this layer
 *     -> num_inputs: number of inputs from previous tile to this layer
 *     -> num_outputs: number of outputs from this layer to next tile
 *     -> neurons: array of neuron objects that perform the computation
 *                 for this layer
 * 
 * The tile major unit represents a computational layer in the neural network. 
 * A tile contains neurons fully connected to the inputs and outputs a 
 * vector of every neuron's evaluated activation function. 
 */
struct tile {
  uint32_t num_neurons;
  uint32_t num_inputs;
  uint32_t tile_index;
  neuron_t *neurons;
};
typedef struct tile* tile_t;

struct network {
  uint32_t num_layers;
  uint32_t (*activation_fn)(uint32_t);
  uint32_t (*activation_fn_drv)(uint32_t);
  weightfile_t weights;
  tile_t *tiles;
}; 
typedef struct network* network_t;


/**
 * Constructor and destructor for a tile. Allocates space for neurons and sets
 * parameters. tile_destroy is used to free allocated space and destroy 
 * tile and its neurons. 
 */
tile_t Tile(uint32_t num_neurons, uint32_t num_inputs,
	    uint32_t (*activation_fn)(uint32_t), uint32_t tile_index);
vector_t evaluate_tile(tile_t tile, vector_t input, weightfile_t weights);
void tile_destroy(tile_t tile);


/**
 * Constructor and destructor for a neuron. Allocates space for neuron and sets
 * parameters. neuron_destroy is used to free allocated space of neuron. 
 */
neuron_t Neuron(uint32_t input_len, uint32_t (*activation_fn)(uint32_t));
void neuron_destroy(neuron_t neuron);

network_t Network(uint32_t num_layers, uint32_t num_inputs, uint32_t num_outputs, 
		  uint32_t (*activation_fn)(uint32_t), uint32_t (*activation_fn_drv)(uint32_t));
void network_destroy(network_t network);

/**
 * Evaluates the activation function for a neuron on the weighted sum of 
 * its given inputs. 
 */
uint32_t evaluate_neuron(neuron_t neuron, vector_t input, vector_t weights);
vector_t evaluate_image (network_t network, vector_t image);

#endif
