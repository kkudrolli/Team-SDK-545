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

#define BETA 0.00000001

/* 
 * Classifies output of neural network to a handwritten digit.
 */
uint32_t classify(vector_t net_out);

#endif
