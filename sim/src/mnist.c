/*
 * Author: Kais Kudrolli
 *
 * Description: The C implementation of library to read mnist training and testing files.
 *
 */

#include "mnist.h"

/*********************
 * Helper Functions *
 *********************/

uint32_t read_word(uint8_t *arr, uint32_t offset)
{
    uint32_t word = (uint32_t) arr[offset];

    for (uint32_t i = 0; i < WORD_BYTES; i++) {
        word = (word << BYTE_SIZE) + arr[offset + i];
    }

    return word;
}

char *concat_fname(const char *dir_name, const char *fname)
{
    size_t path_len = strlen(dir_name) + strlen(fname) + 1;
    char *full_path = (char*) Calloc(path_len, sizeof(char));
    snprintf(full_path, path_len, "%s%s", dir_name, fname);
    return full_path;
}

/*********************
 * Library Functions *
 *********************/

vector_t *read_images(uint32_t train)
{
    char *full_path;
    if (train) {
        full_path = concat_fname(mnist_path, train_image_fname);
    } else {
        full_path = concat_fname(mnist_path, test_image_fname);
    }

    char *mode = FILE_MODE;

    FILE *fp = Fopen(full_path, mode); 

    uint8_t header[IMAGE_HEADER_SIZE];
    Fread(header, sizeof(uint8_t), IMAGE_HEADER_SIZE, fp);

    uint32_t num_images = read_word(header, NUM_ITEMS_OFFSET);
    uint32_t rows = read_word(header, ROW_OFFSET);
    uint32_t cols = read_word(header, COL_OFFSET);
    uint32_t img_size = rows * cols;

    vector_t *mnist_data = (vector_t*) Calloc(num_images, sizeof(vector_t));
    
    for (uint32_t i = 0; i < num_images; i++) {
        mnist_data[i] = Vector((size_t) img_size);

        uint8_t *image_bytes = (uint8_t*) Calloc(img_size, sizeof(uint8_t));
        uint32_t actual_size;
        if ((actual_size = fread(image_bytes, sizeof(uint8_t), img_size, fp)) < img_size) {
            Free(image_bytes);
            for (uint32_t i = 0; i < num_images; i++) vector_destroy(mnist_data[i]);
            return NULL;
        }

        uint32_t *vector_data = (uint32_t*) Calloc(img_size, sizeof(uint32_t));
        for (uint32_t j = 0; j < img_size; j++) {
            vector_data[j] = (uint32_t) image_bytes[j];
        }
        mnist_data[i]->data = vector_data;
        Free(image_bytes);
    }

    Free(full_path);
    Fclose(fp);
    return mnist_data;
}

vector_t read_labels(uint32_t train)
{
    char *full_path;
    if (train) {
        full_path = concat_fname(mnist_path, train_label_fname);
    } else {
        full_path = concat_fname(mnist_path, test_label_fname);
    }

    char *mode = FILE_MODE;

    FILE *fp = Fopen(full_path, mode); 

    uint8_t header[LABEL_HEADER_SIZE];
    Fread(header, sizeof(uint8_t), LABEL_HEADER_SIZE, fp);

    uint32_t num_labels = read_word(header, NUM_ITEMS_OFFSET);

    vector_t mnist_labels = Vector((size_t) num_labels);

    uint8_t *label_bytes = (uint8_t*) Calloc(num_labels, sizeof(uint8_t));
    uint32_t actual_size;
    if ((actual_size = fread(label_bytes, sizeof(uint8_t), num_labels, fp)) < num_labels) {
        Free(label_bytes);
        vector_destroy(mnist_labels);
        return NULL;
    }

    uint32_t *vector_data = (uint32_t*) Calloc(num_labels, sizeof(uint32_t));
    for (uint32_t i = 0; i < num_labels; i++) {
        vector_data[i] = (uint32_t) label_bytes[i];
    }
    mnist_labels->data = vector_data;

    Free(full_path);
    Free(label_bytes);
    Fclose(fp);
    return mnist_labels;
}



