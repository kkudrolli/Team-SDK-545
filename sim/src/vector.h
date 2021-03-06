/*
 * Author: Sohil Shah
 *
 * Description: Defines a vector type used to pass inputs and
 * outputs between neurons and tiles. Provides easy way to perform
 * operations on vectors. 
 *
 */

#ifndef _VECTOR_H
#define _VECTOR_H

#include <stdint.h>
#include <stdlib.h>
#include <assert.h>
#include "err_wrappers.h"

/**
 * Basic structure of a vector. Contains the following parameters:
 *     -> length: number of elements in vector
 *     -> data: array of vector elements
 *     
 * Provides a way to represent a vector of integers and perform 
 * operations on them.
 */
struct vector {
  size_t length;
  uint32_t *data;
};
typedef struct vector* vector_t;

/**
 * Constructor and destructor for a vector. Allocates a vector 
 * struct and buffer to hold data. vector_destroy frees allocated
 * space. 
 */
vector_t Vector(size_t length);
void vector_destroy(vector_t vector);

/**
 * Basic operations with vectors. 
 */
vector_t smult(vector_t v, uint32_t scale);
/** Vector dot product */
vector_t vmult(vector_t v1, vector_t v2);
void vdiv(vector_t v, int factor);

/** Vector multiply-add: dot product then sum values */
uint32_t vmad(vector_t v1, vector_t v2);
vector_t *vouter(vector_t v1, vector_t v2);
vector_t vsub(vector_t v1, vector_t v2);

/** Vector addition */
vector_t vadd(vector_t v1, vector_t v2);

/** Fixed point multiply and divide */
uint32_t fmult(uint32_t x, uint32_t y);
uint32_t fdiv(uint32_t x, uint32_t y);

void vprint(vector_t v);

float fixed_to_float(uint32_t x);

#endif
