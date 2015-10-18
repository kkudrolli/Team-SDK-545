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
    denom += expf(BETA * fixed_to_float(data[x]));
  }
  
  return (expf(BETA * fixed_to_float(data[i]))) / denom;
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
uint32_t classify(vector_t net_out, uint32_t quiet) 
{
    uint32_t prediction = 0;
    float conf = 0;

    size_t length = net_out->length;
    uint32_t* data = net_out->data;

    // Prints out the confidence in each digit
    printf(BOLD UNDERLINE "\nClassification:\n" NORMAL);
    if (!quiet) {
      printf(BOLD "# Confidence   Neuron Output\n" NORMAL);
      printf(BOLD "- ----------   -------------\n" NORMAL);
    }
    for (size_t i = 0; i < length; i++) {
        // Get the confidence of this digit using softmax
        float new_conf = softmax(data, length, i);
        // The high confidence is the predicted value
        if (new_conf > conf) {
            prediction = i;
            conf = new_conf;
        }
	if (!quiet)
	  printf("%zu %-7.5f      %u\n", i, new_conf, data[i]);
    }
    printf(BOLD "Prediction: %d with %2.1f%% confidence \n\n" NORMAL, prediction, conf * 100);

    return prediction;
}
