
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
    
    // Make and fill target vector, the index corresponding
    // to the target digit is set to fixed point 1. The rest
    // are set to 0.
    vector_t target_vec = Vector(TARGET_SIZE);
    for (uint32_t x = 0; x < TARGET_SIZE; x++) {
        if (x == target) {
            target_vec->data[x] = FX_PT_1;
        } else {
            target_vec->data[x] = 0;
        }
    }
    return target_vec;
}
