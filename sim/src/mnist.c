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

/*
 * read_word: A function to read a data word from a byte array and
 *            return it as an integer.
 *
 * Parameters:
 *  - arr: byte array
 *  - offset: offset into byte array
 *
 * Return value:
 *  - data word 
 */
uint32_t read_word(uint8_t *arr, uint32_t offset)
{
    // Get the first byte
    uint32_t word = (uint32_t) arr[offset];

    // Get the rest of the bytes
    for (uint32_t i = 0; i < WORD_BYTES; i++) {
        word = (word << BYTE_SIZE) + arr[offset + i];
    }

    return word;
}

/*
 * concat_fname: Creates a full filename path out of a directory name
 *               and filename.
 *
 * Parameters:
 *  - dir_name: directory name
 *  - fname: filename
 *
 * Return value:
 *  - full path name string
 */
char *concat_fname(const char *dir_name, const char *fname)
{
    size_t path_len = strlen(dir_name) + strlen(fname) + 1;
    char *full_path = (char*) Calloc(path_len, sizeof(char));
    // use snprintf to concatenate fname to dir_name
    snprintf(full_path, path_len, "%s%s", dir_name, fname);
    return full_path;
}

/*********************
 * Library Functions *
 *********************/

/*
 * read_images: Reads the images from and mnist image db file and puts the
 *              images into and array of vectors.
 *
 * Parameters:
 *  - train: boolean value, read from training db if 0, test db if 1
 *
 * Return value:
 *  - array of vectors containing mnist images
 */ 
mnist_images_t read_images(uint32_t train)
{
    // Set the filename based the mode (train or test)
    char *full_path;
    if (train) {
        full_path = concat_fname(mnist_path, train_image_fname);
    } else {
        full_path = concat_fname(mnist_path, test_image_fname);
    }

    // Open the file for reading
    char *mode = FILE_MODE;
    FILE *fp = Fopen(full_path, mode); 

    // Read the header of the file
    uint8_t header[IMAGE_HEADER_SIZE];
    Fread(header, sizeof(uint8_t), IMAGE_HEADER_SIZE, fp);

    // Extract size info from mnist db header
    uint32_t num_images = read_word(header, NUM_ITEMS_OFFSET);
    uint32_t rows = read_word(header, ROW_OFFSET);
    uint32_t cols = read_word(header, COL_OFFSET);
    uint32_t img_size = rows * cols;

    // Create array of mnist image vectors
    vector_t *mnist_data = (vector_t*) Calloc(num_images, sizeof(vector_t));
    
    // Populate vectors with one image each
    for (uint32_t i = 0; i < num_images; i++) {
        mnist_data[i] = Vector((size_t) img_size);

        uint8_t *image_bytes = (uint8_t*) Calloc(img_size, sizeof(uint8_t));
        uint32_t actual_size;
        // Read img_size bytes from the db file into the byte array
        if ((actual_size = fread(image_bytes, sizeof(uint8_t), img_size, fp)) < img_size) {
            Free(image_bytes);
            for (uint32_t i = 0; i < num_images; i++) vector_destroy(mnist_data[i]);
            return NULL;
        }

        // Move 8 bit data to 32 bit integer for more precision
        //uint32_t *vector_data = (uint32_t*) Calloc(img_size, sizeof(uint32_t));
        assert(image_bytes);
        assert(mnist_data);
        for (uint32_t j = 0; j < img_size; j++) {
            mnist_data[i]->data[j] = (uint32_t) image_bytes[j];
        }
        Free(image_bytes);
    }

    // Create the mnist_images_t pointer and populate the struct it points to
    mnist_images_t mnist_imgs = Mnist_images((size_t) num_images); 
    mnist_imgs->imgs = mnist_data;

    Free(full_path);
    Fclose(fp);
    return mnist_imgs;
}

mnist_labels_t read_labels(uint32_t train)
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

    vector_t lbls = Vector((size_t) num_labels);

    uint8_t *label_bytes = (uint8_t*) Calloc(num_labels, sizeof(uint8_t));
    uint32_t actual_size;
    if ((actual_size = fread(label_bytes, sizeof(uint8_t), num_labels, fp)) < num_labels) {
        Free(label_bytes);
        vector_destroy(lbls);
        return NULL;
    }

    uint32_t *vector_data = (uint32_t*) Calloc(num_labels, sizeof(uint32_t));
    for (uint32_t i = 0; i < num_labels; i++) {
        vector_data[i] = (uint32_t) label_bytes[i];
    }
    lbls->data = vector_data;

    mnist_labels_t mnist_lbls = Mnist_labels((size_t) num_labels);
    mnist_lbls->labels = lbls;

    Free(full_path);
    Free(label_bytes);
    Fclose(fp);
    return mnist_lbls;
}

mnist_images_t Mnist_images(size_t size) 
{
    mnist_images_t mnist_imgs = Malloc(sizeof(struct mnist_images *)); 
    mnist_imgs->size = size;
    return mnist_imgs;
}
void mnist_images_destroy(mnist_images_t images) 
{
    assert(images);
    for (size_t i = 0; i < images->size; i++) {
        vector_destroy(images->imgs[i]);
    }
    Free(images);
}

mnist_labels_t Mnist_labels(size_t size)
{
    mnist_labels_t mnist_lbls = Malloc(sizeof(struct mnist_labels *));
    mnist_lbls->size = size;
    return mnist_lbls;
}

void mnist_labels_destroy(mnist_labels_t labels)
{
    assert(labels);
    vector_destroy(labels->labels);
    Free(labels);
}



