/*
 * Author: Kais Kudrolli
 *
 * Description: Header file for classify.h.
 *
 */

#ifndef _CLASSIFY_H_
#define _CLASSIFY_H_

#include <stdint.h>
#include <math.h>
#include "vector.h"
#include "params.h"


#define BETA 5 // Can play around with this
                        // to handle larger numbers

/* 
 * Classifies output of neural network to a handwritten digit.
 */
uint32_t classify(vector_t net_out, uint32_t quiet);

#endif
