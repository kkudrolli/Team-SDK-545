/*
 * Author: Sohil Shah
 *
 * Description: implements a vector type used to pass inputs and
 * outputs between neurons and tiles. 
 *
 */

#include "vector.h"

/**
 * Constructor for a vector. 
 */
vector_t Vector(size_t length) {
  vector_t v = (vector_t) Malloc(sizeof(struct vector));  
  v->data = (uint32_t *)Calloc(length, sizeof(uint32_t));
  v->length = length;

  for (size_t i = 0; i < length; ++i) {
    v->data[i] = 0;
  }

  return v;
}

/**
 * Destructor for a vector. 
 */
void vector_destroy(vector_t vector) {
  Free(vector->data);
  Free(vector);
}

/**
 * Multiply by a scalar
 */
void smult(vector_t v, uint32_t scale) {
  for (size_t i = 0; i < v->length; ++i) {
    v->data[i] = fmult(v->data[i], scale);
  }
}

/**
 * Elementwise multiply of two vectors. 
 * NOTE: Remember to free returned vector. 
 */
vector_t vmult(vector_t v1, vector_t v2) {
  assert(v1);
  assert(v2);
  assert(v1->length == v2->length);
  vector_t v = Vector(v1->length);
  
  for (size_t i = 0; i < v->length; ++i) {
    v->data[i] = fmult(v1->data[i], v2->data[i]);
  }
  
  return v;
}


void vdiv(vector_t v, int factor) {
  assert(v);
  
  for (size_t i = 0; i < v->length; i++) {
    v->data[i] = (uint32_t)(((int)v->data[i]) >> factor);
  }
}

/**
 * Outer product of two vectors (v1 * v2_t). 
 * NOTE: Remember to free returned vector array (and vectors it contains). 
 */
vector_t *vouter(vector_t v1, vector_t v2) {
  assert(v1);
  assert(v2);

  vector_t *matrix = (vector_t *)Calloc(v2->length, sizeof(vector_t));
  
  for (size_t i = 0; i < v2->length; i++) {
    vector_t v = Vector(v1->length);
    uint32_t scalar = v2->data[i];
    for (size_t j = 0; j < v1->length; j++) {
      v->data[j] = fmult(v1->data[j], scalar);
    }
    matrix[i] = v;
  }
  
  return matrix;
}

/**
 * Sum of elements of dot product of two vectors. 
 */
uint32_t vmad(vector_t v1, vector_t v2) {
  assert(v1);
  assert(v2);
  assert(v1->length == v2->length);
  uint32_t sum = 0;
  
  for (size_t i = 0; i < v1->length; ++i) {
    sum += fmult(v1->data[i], v2->data[i]);
  }
  
  return sum;
}

/**
 * Addition of two vectors.
 * NOTE: Remember to free returned vector.
 */
vector_t vadd(vector_t v1, vector_t v2) {
  assert(v1);
  assert(v2);
  assert(v1->length == v2->length);
  vector_t v = Vector(v1->length);
  
  for (size_t i = 0; i < v->length; ++i) {
    v->data[i] = v1->data[i] + v2->data[i];
  }
  return v;
}

/**
 * Subtraction of two vectors.
 * NOTE: Remember to free returned vector.
 */
vector_t vsub(vector_t v1, vector_t v2) {
  assert(v1);
  assert(v2);
  assert(v1->length == v2->length);
  vector_t v = Vector(v1->length);
  
  for (size_t i = 0; i < v->length; ++i) {
    v->data[i] = v1->data[i] - v2->data[i];
  }
  return v;
}

inline void vprint(vector_t v) {
  assert(v);

  for (uint32_t i = 0; i < v->length; i++) 
    printf("v[%u] = %u\n", i, v->data[i]);
}

/**
 * Fixed point multiply (Q16.16)
 */
inline uint32_t fmult(uint32_t x, uint32_t y) {
  uint32_t result;
  int64_t intermediate;

  intermediate = ((int64_t)((int32_t)x)) * ((int64_t)((int32_t)y));
  result = (uint32_t)((uint64_t)(intermediate >> 16));

  return result;
}

/**
 * Fixed point divide (Q16.16)
 */
inline uint32_t fdiv(uint32_t x, uint32_t y) {
  uint32_t result;
  uint64_t intermediate;

  intermediate = ((uint64_t)x) / ((uint64_t)y);
  result = (uint32_t)(intermediate >> 16);

  return result;
}


/** 
 * Fixed point to float
 */
inline float fixed_to_float(uint32_t x) {
  float y = (float)((int32_t)x);
  float div = (float)(1 << 16);
  return (y / div);
}
