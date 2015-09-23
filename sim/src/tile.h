/*
 * Author: Sohil Shah
 *
 * Description: This is the header file for tile.c. Contains definitions of 
 * structures and constants relevant to the tiles. 
 *
 */


struct vector {
  size_t length;
  size_t elem_size;
  void *data;
};
typedef struct vector* vector_t;

struct tile {
  uint32_t num_neurons;
  uint32_t num_inputs;
  uint32_t num_outputs;
  vector_t neurons;
};
typedef struct tile* tile_t;

struct neuron {
  uint32_t input_len;
  uint32_t (*activation_fn)(uint32_t);
};
typedef struct neuron* neuron_t;

tile_t Tile(uint32_t num_neurons, uint32_t num_inputs, uint32_t num_outputs, 
	    uint32_t (*activation_fn)(uint32_t));
void tile_destroy(tile_t tile);

neuron_t Neuron(uint32_t input_len, uint32_t (*activation_fn)(uint32_t));
uint32_t evaluate_neuron(neuron_t neuron, vector_t input, vector_t weights);
void neuron_destroy(neuron_t neuron);

vector_t Vector(size_t length, size_t elem_size);
vector_t vmult(vector_t v1, vector_t v2);
vector_t vadd(vector_t v1, vector_t v2);
void vector_destroy(vector_t vector);
