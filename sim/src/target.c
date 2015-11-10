
#include "target.h"

mnist_labels_t load_labels(uint32_t train)
{
    return read_labels(train);
}

vector_t get_label(mnist_labels_t labels, size_t i)
{
    // Grab the correct label
    uint32_t *data = labels->labels->data;
    uint32_t target = data[i];
    
    return gen_target(target);
}

/*
 * gen_target: Make and fill target vector, the index corresponding
 * to the target digit is set to fixed point 1. The rest are set to 0.
 *
 * Parameters:
 *  - target: the value to train on
 *
 * Return value:
 *  - target vector
 */
vector_t gen_target(uint32_t target) 
{
    assert(target < TARGET_SIZE);
    vector_t target_vec = Vector(TARGET_SIZE);

    // difference[target][compare_val] : how similar target is to compare
    // Higher numbers are less similar
    // Range from 0 - 15            
    //                              0   1   2   3   4   5   6   7   8   9
    uint8_t difference[10][10] = {{ 0, 13, 10, 12, 13, 10,  8, 12,  6,  8}, // 0
				  {13,  0, 14, 14, 10, 14, 14, 10, 14, 14}, // 1
				  {10, 14,  0, 10, 14, 10, 11, 12, 13, 12}, // 2
				  {12, 14, 10,  0, 12, 11, 13, 14,  6, 12}, // 3
				  {13, 10, 14, 12,  0, 13, 14, 14, 14,  4}, // 4
				  {10, 14, 10, 11, 13,  0,  7,  9,  7,  8}, // 5
				  { 8, 14, 11, 13, 14,  7,  0, 12,  9, 12}, // 6
				  {12, 10, 12, 14, 14,  9, 12,  0, 13,  7}, // 7
				  { 6, 14, 13,  6, 14,  7,  9, 13,  0,  6}, // 8
				  { 8, 14, 12, 12,  4,  8, 12,  7,  6,  0}};// 9
    
    for (uint32_t x = 0; x < TARGET_SIZE; x++) {
      if (x == target) {
	target_vec->data[x] = FX_PT_1;
      } else {
#ifdef ENABLE_TARGET_BIAS
	target_vec->data[x] = FX_PT_1 >> (difference[target][x] - TARGET_BIAS_OFFSET);
#else
	target_vec->data[x] = 1;
#endif
      }
    }

    return target_vec;
}
