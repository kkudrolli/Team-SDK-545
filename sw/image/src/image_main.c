#include <stdio.h>
#include "uart.h"
#include "image_io.h"
#include "mnist.h"

#define IMAGE_DIM 28
#define TRANSFER

void print_usage(void); 
void print_image(vector_t img);

int main(int argc, char *argv[])
{
    printf("At start!\n");
#ifdef TRANSFER
    // Open and set up serial port 
    int port = configure_port();
#endif

    // Parse command line arguments
    if (argc != 4) {
        printf("Not enough commandline arguments! Number of args: %d\n", argc);
        return 0;
    }

    char option = argv[1][1]; // Gets second argument's second character
    char *train_test = argv[2];  

    // CAMERA images
    if (option == 'i') { // Option for camera image
        char *filename = argv[3]; // Assume filename is relative path
        /*vector_t img = Vector(784);
        int c;
        int byte_count = 0;
        int i = 0;
        while (EOF != (c = fgetc(stdin)) && (byte_count < (784*3))) {
            printf("%u ",byte_count);
            printf("%u ", c);
            if (byte_count % 3 == 0) {
                img->data[i] = (uint32_t) c;
                i++;
            }
            byte_count++;
        }*/
        vector_t img = read_bitmap(filename); 
        uint32_t label = 0;
        size_t num_imgs = 1; // Only ever send one image from camera

        if (strncmp(train_test, "train", 5) == 0) { // train
            printf("Sending camera train!\n");
            //print_image(img);
#ifdef TRANSFER
            transfer(&img, &label, port, 1, num_imgs);
            transfer(&img, &label, port, 1, num_imgs);
#endif
        } else if (strncmp(train_test, "test", 4) == 0) { // test 
            printf("Sending camera test!\n");
            print_image(img);
#ifdef TRANSFER
            transfer(&img, &label, port, 0, num_imgs);
            transfer(&img, &label, port, 0, num_imgs);
#endif
        } else {
            printf("Invalid train or test option: %s\n", train_test);
            print_usage();
        }
        vector_destroy(img);
        
    // MNIST images
    } else if (option == 'm') { 
        int num_imgs = atoi(argv[3]);

        if (strncmp(train_test, "train", 5) == 0) { // train
            mnist_images_t m_imgs = read_images(TRAIN);
            mnist_labels_t m_lbls = read_labels(TRAIN);

            if ((ssize_t) num_imgs >= (ssize_t) (m_imgs->size)) {
                printf("Number of images option is too high: %d\n", num_imgs);
                return 0;
            }
            printf("Sending MNIST train!\n");
#ifdef TRANSFER
            transfer(m_imgs->imgs, m_lbls->labels->data, port, 1, num_imgs);
#endif
        
        } else if (strncmp(train_test, "test", 4) == 0) { // test 
            mnist_images_t m_imgs = read_images(TEST);
            mnist_labels_t m_lbls = read_labels(TEST);
            if ((ssize_t) num_imgs >= (ssize_t) (m_imgs->size)) {
                printf("Number of images option is too high: %d\n", num_imgs);
                return 0;
            }
            printf("Sending MNIST test!\n");
#ifdef TRANSFER
            transfer(m_imgs->imgs, m_lbls->labels->data, port, 0, num_imgs);
#endif

        } else {
            printf("Invalid train or test option: %s\n", train_test);
            print_usage();
        }

    } else { // Invalid option
        printf("Invalid option '-%c'...\n", option);
        print_usage();
    }

#ifdef TRANSFER 
    // Clean up serial port
    close_port(port);
#endif
    return 0;
} 

void print_usage(void) 
{
    printf("Usage:\n./send_image -[i/m] [train/test] [filename/num images]\n");
    return;
}

void print_image(vector_t img)
{
    uint32_t *data = img->data;
    printf("Camera image:\n");
    for (size_t i = 0; i < img->length; i++) {
        if (i % IMAGE_DIM == 0) {
            printf("\n");
        }
        printf("%02x ", data[i]);
    }
    printf("\n");

    return;
}

