/*
 * Author: Kais Kudrolli
 *
 * Description: This is the header file for mnist.c, which can be used to read
 * images from the mnist database.
 *
 */

#ifndef _MNIST_H_
#define _MNIST_H_

#include <stdint.h>
#include <string.h>
#include <assert.h>
#include "vector.h"
#include "err_wrappers.h"

#define MNIST_DBG
#define FILE_MODE         "rb"
#define BYTE_SIZE         8
#define WORD_BYTES        4
#define IMAGE_HEADER_SIZE 16
#define LABEL_HEADER_SIZE 8
#define NUM_ITEMS_OFFSET  4
#define ROW_OFFSET        8
#define COL_OFFSET        12

/* Filenames and paths defined as static constant strings */
static const char *mnist_path = "../sw/camera/mnist/";
static const char *train_image_fname = "train-images-idx3-ubyte";
static const char *train_label_fname = "train-labels-idx1-ubyte";
static const char *test_image_fname = "t10k-images-idx3-ubyte";
static const char *test_label_fname = "t10k-labels-idx1-ubyte";

/* Function definitions */
vector_t *read_images(uint32_t train);
vector_t read_labels(uint32_t train);

#endif
