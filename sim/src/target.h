/*
 * Author: Kais Kudrolli
 *
 * Description: Header file for target.c. 
 */

#ifndef _TARGET_H_
#define _TARGET_H_

#include <assert.h>
#include "mnist.h"
#include "params.h"

#define TARGET_SIZE 10
#define FX_PT       16
#define FX_PT_1     (1 << FX_PT)

mnist_labels_t load_labels(uint32_t train);
vector_t get_label(mnist_labels_t labels, size_t i);
vector_t gen_target(uint32_t target);

#endif
