###################################################################
### Variables
###################################################################
SRC := src
SOURCES := $(wildcard src/*.c)
OBJS := $(patsubst src/%,build/%,$(SOURCES:.c=.o))
CC = gcc
CFLAGS = -Wall -Wextra -O2 -std=c99
LINK_FLAGS_OSX = -L/usr/local/Cellar/libusb/1.0.19/lib 
USB_LIB = -lusb-1.0


###################################################################
### Targets
###################################################################
all: exec_usb

exec_usb: $(OBJS)
	$(CC) $(CFLAGS) $(LINK_FLAGS_OSX) -o exec_usb $(OBJS) $(USB_LIB) 

build/%.o: $(SRC)/%.c build
	$(CC) $(CFLAGS) -c $< -o $@

build: 
	mkdir -p $@

clean:
	rm -rf exec_usb *.o *~ src/*~ build
