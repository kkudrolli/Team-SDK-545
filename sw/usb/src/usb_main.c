#include <stdio.h>
#include <stdlib.h>
#include <libusb-1.0/libusb.h>

void print_dev(libusb_device *dev);

int main() 
{
    // Pointer to pointer of devices, used to get device list
    libusb_device **devs;
    // A libusb sesssion
    libusb_context *ctx = NULL;
    // A device handle
    libusb_device_handle *dev_handle;

    ssize_t num_devices;
    int ret_val;

    // Initialize a lirary sessio 
    ret_val = libusb_init(&ctx);

    if (ret_val < 0) {
        printf("Error in libusb_init\n");
        exit(1);
    }

    // Set verbosity level to 3, as per documentation
    libusb_set_debug(ctx, 3);

    // Get the device list
    num_devices = libusb_get_device_list(ctx, &devs);

    if (num_devices < 0) {
        printf("Get Device Error\n");
        exit(1);
    }

    for (ssize_t i = 0; i < num_devices; i++) {
        print_dev(devs[i]);
    }

    printf("There are %zd devices found\n", num_devices);

    // TODO: get vid and pid here
    //vid, pid = ...;
    // Open device with vendor ID and product ID
    dev_handle = libusb_open_device_with_vid_pid(ctx, 1, 0);
    if (!dev_handle) {
        printf("Cannot open device\n");
    } else {
        printf("Device Opened\n");
    }

    // Free the list, unreference the devices in it
    libusb_free_device_list(devs, 1);

    // TODO: get mnist data here
    unsigned char data[4] = {1, 2, 3, 4};

    // If kernel is attached, detach it
    if (libusb_kernel_driver_active(dev_handle, 1) == 1) {
        printf("Kernel Driver Active\n");
        if (libusb_detach_kernel_driver(dev_handle, 0) == 0) {
            printf("Kernel Driver Active\n");
        }
    }

    // Claim interface 0 (the first) of the device
    int r = libusb_claim_interface(dev_handle, 0); 
    if (r < 0) {
        printf("Cannot claim interface\n");
        exit(1);
    }
    printf("Claimed interface\n");

    printf("Writing Data...\n");
    int actual;
    // TODO: get dev endpoint (don't know it's 2) 
    // TODO: write correct number of bytes, not 4
    r = libusb_bulk_transfer(dev_handle, 
                              (2 | LIBUSB_ENDPOINT_OUT), 
                              data, 4, &actual, 0);

    // Check that we wrote n bytes successfully
    if (r == 0 && actual == 4) {
        printf("Write successful\n");
    } else { 
        printf("Write error\n");
    }

    // Release the claimed interface
    r = libusb_release_interface(dev_handle, 0);
    if (r) {
        printf("Cannot release interface\n");
        exit(1);
    }
    printf("Released interface\n");

    // Close the open device
    libusb_close(dev_handle);
    // End the usb session
    libusb_exit(ctx);
    // TODO: free data...
    return 0;
}

void print_dev(libusb_device *dev)
{
    struct libusb_device_descriptor desc;
    int r = libusb_get_device_descriptor(dev, &desc);
    if (r < 0) {
        printf("Failed to get device descriptor\n");
        return;
    }

    printf("Device class: %d\n", desc.bDeviceClass);
    printf("VendorID: %d\n", desc.idVendor);
    printf("ProductID: %d\n", desc.idProduct);
}
