#include "tile.h"

vector_t evaluate_net (tile_t tile, vector_t input, weightfile_t weights);
vector_t evaluate_activation (vector_t input, uint32_t (*activation_fn)(uint32_t));

vector_t *evaluate_weight_change ();

void backpropogate (network_t network, vector_t image, vector_t ideal);
