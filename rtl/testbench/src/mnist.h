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

//#define MNIST_DBG
#define FILE_MODE         "rb"
#define BYTE_SIZE         8
#define WORD_BYTES        4
#define IMAGE_HEADER_SIZE 16
#define LABEL_HEADER_SIZE 8
#define NUM_ITEMS_OFFSET  4
#define ROW_OFFSET        8
#define COL_OFFSET        12

/* Struct for a set of MNIST images */
struct mnist_images {
    size_t size;
    vector_t *imgs;
};
typedef struct mnist_images * mnist_images_t;

/* Struct for MNIST labels */
struct mnist_labels {
    size_t size;
    vector_t labels;
};
typedef struct mnist_labels * mnist_labels_t;


/* Filenames and paths defined as static constant strings */
static const char *mnist_path = "../../sw/camera/mnist/";
static const char *train_image_fname = "train-images-idx3-ubyte";
static const char *train_label_fname = "train-labels-idx1-ubyte";
static const char *test_image_fname = "t10k-images-idx3-ubyte";
static const char *test_label_fname = "t10k-labels-idx1-ubyte";

/* Function definitions */
mnist_images_t read_images(uint32_t train);
mnist_labels_t read_labels(uint32_t train);

mnist_images_t Mnist_images(size_t size);
void mnist_images_destroy(mnist_images_t images);
mnist_labels_t Mnist_labels(size_t size);
void mnist_labels_destroy(mnist_labels_t labels);

#endif
