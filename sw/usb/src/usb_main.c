#include <stdio.h>
#include <stdlib.h>
#include <libusb-1.0/libusb.h>

int main() 
{
    libusb_device **devs;
    libusb_context *context = NULL;

    size_t list;
    int ret;

    ret = libusb_init(&context);

    if(ret < 0)
    {
        perror("libusb_init");
        exit(1);
    }

    list = libusb_get_device_list(context, &devs);

    printf("There are %zd devices found\n", list);

    return 0;
}
