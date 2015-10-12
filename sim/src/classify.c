/*
 * Author: Kais Kudrolli
 *
 * Description: Contains functions to classify outputs from a neural network
 * to a digit. Uses a softmax classifier.
 *
 */

#include "classify.h"

/*
 * softmax: Does softmax classification, whose formula is
 *          S_i = (e^(B * o_i)) / (sum over n e^(B * o_n))
 * 
 * Parameters:
 *  - data: array of output data
 *  - length: length of data (should be 10)
 *  - i: which index in the array to operate on
 */
float softmax(uint32_t* data, size_t length, size_t i)
{
    float denom = 0.0;
    // Get the bottom sum first
    for (size_t x = 0; x < length; x++) {
        denom += expf(BETA * (float) data[x]);
    }

    return (expf(BETA * (float) data[i])) / denom;
}

/*
 * classify: Classifies an output vector as one of 10 digits.
 *
 * Paramters:
 *  - net_out: vector output of network
 *
 * Return value:
 *  - prediction
 */
uint32_t classify(vector_t net_out) 
{
    uint32_t prediction = 0;
    float conf = 0;

    size_t length = net_out->length;
    uint32_t* data = net_out->data;

    // Prints out the confidence in each digit
    printf("CLASSIFICATION: \n");
    printf("# Conf    Digit\n");
    printf("- ------- -----\n");
    for (size_t i = 0; i < length; i++) {
        // Get the confidence of this digit using softmax
        float new_conf = softmax(data, length, i);
        // The high confidence is the predicted value
        if (new_conf > conf) {
            prediction = i;
            conf = new_conf;
        }
        printf("%zu %-7.5f %d\n", i, new_conf, data[i]);
    }
    printf("Prediction: %d\n", prediction);

    return prediction;
}

/*int main() 
{
    vector_t vec = Vector((size_t) 3);
    vec->data[0] = 1;
    vec->data[1] = 3;
    vec->data[2] = 2;
    classify(vec);
    return 0;
}*/



