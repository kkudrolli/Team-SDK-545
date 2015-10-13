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
  vector_t v = Malloc(sizeof(struct vector));  
  v->data = Calloc(length, sizeof(uint32_t));
  v->length = length;

  for (size_t i = 0; i < length; ++i) {
    v->data[i] = 0;
  }

  return v;
}

/**
 * destructor for a vector. 
 */
void vector_destroy(vector_t vector) {
  Free(vector->data);
  Free(vector);
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
    v->data[i] = v1->data[i] * v2->data[i];
  }
  
  return v;
}

/**
 * Outer product of two vectors (v1 * v2_t). 
 * NOTE: Remember to free returned vector array (and vectors it contains). 
 */
vector_t *vouter(vector_t v1, vector_t v2) {
  assert(v1);
  assert(v2);

  vector_t *matrix = Calloc(v2->length, sizeof(vector_t));
  
  for (size_t i = 0; i < v2->length; i++) {
    vector_t v = Vector(v1->length);
    uint32_t scalar = v2->data[i];
    for (size_t j = 0; j < v1->length; j++)
      v->data[j] = v1->data[j] * scalar;
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
    sum += v1->data[i] * v2->data[i];
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
