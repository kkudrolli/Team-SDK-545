#include "backprop.h"

vector_t evaluate_net (tile_t tile, vector_t input, weightfile_t weights) {
  vector_t v = Vector(tile->num_neurons);
  for (uint32_t i = 0; i < tile->num_neurons; i++) {
    v->data[i] = vmad(input, getWeights(weights, tile->tile_index, i));
  }
  return v;  
}

vector_t evaluate_activation (vector_t input, uint32_t (*activation_fn)(uint32_t)) {
  vector_t v = Vector(input->length);
  for (uint32_t i = 0; i < input->length; i++) {
    v->data[i] = activation_fn(input->data[i]);
  }
  return v;
}

vector_t *evaluate_weight_change (vector_t delta, vector_t prev_output) {
  //smult(delta, 1 << 14);
  return vouter(prev_output, delta);
}

void backpropogate (network_t network, vector_t image, vector_t ideal) {
  assert(network->tiles[0]->num_inputs == image->length && 
	 network->tiles[network->num_layers - 1]->num_neurons == ideal->length);

  // We need num_layers+1 for num_layers neurons and an extra for 
  // the input layer. 
  // Neural outputs before activation (net)
  vector_t nets[network->num_layers+1];
  // Neural outputs after activation (Y)
  vector_t outputs[network->num_layers+1];

  // First net vector is undefined
  //nets[0] = image;  

  // Image is 0th output
  outputs[0] = image;

  // Calculate net values for first propogation
  nets[1] = evaluate_net(network->tiles[0], image, network->weights);
  // Calculate outputs (Y) for first propogation
  outputs[1] = evaluate_activation(nets[1], network->activation_fn);

  // Calculate rest of net and f'(net) values
  for (uint32_t i = 1; i < network->num_layers; i++) {
    nets[i+1] = evaluate_net(network->tiles[i], outputs[i], network->weights);
    outputs[i+1] = evaluate_activation(nets[i+1], network->activation_fn);
  }

  vector_t delta = vsub(ideal, outputs[network->num_layers]);

  for (uint32_t i = network->num_layers - 1; i > 0; i--) {
    vector_t *matrix = evaluate_weight_change(delta, outputs[i]);
    updateWeightfile(network->weights, i, matrix);
    
    for (uint32_t j = 0; j < delta->length; j++) {
      vector_destroy(matrix[j]);
    }
    Free(matrix);
    
    vector_t weight_t_del = Vector(network->tiles[i-1]->num_neurons);
    for (uint32_t j = 0; j < weight_t_del->length; j++) {
      vector_t weights = getWeightsFromSrc(network->weights, i-1, j);
      weight_t_del->data[j] = vmad(weights, delta);
      vector_destroy(weights);
    }

    vector_destroy(delta);
    vector_t fnet = evaluate_activation(nets[i], network->activation_fn_drv);
    vector_t err = vmult(weight_t_del, fnet);
    delta = vmult(err, outputs[i]);
    vector_destroy(err);
    vector_destroy(fnet);
    vector_destroy(weight_t_del);
  }

  vector_t *matrix = evaluate_weight_change(delta, outputs[0]);
  updateWeightfile(network->weights, 0, matrix);
  for (uint32_t j = 0; j < delta->length; j++) {
    vector_destroy(matrix[j]);
  }
  Free(matrix);

  vector_destroy(delta);
  for (uint32_t i = 1; i <= network->num_layers; i++) {
    vector_destroy(nets[i]);
    vector_destroy(outputs[i]);
  }
}
