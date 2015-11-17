###################################################################
### Variables
###################################################################
SRC := src
SOURCES := $(wildcard src/*.c)
OBJS := $(patsubst src/%,build/%,$(SOURCES:.c=.o))
CC = gcc
CFLAGS = -Wall -Wextra -O2 -std=c99 -lm 


###################################################################
### Targets
###################################################################
all: send_image 

send_image: $(OBJS)
	$(CC) $(CFLAGS) -o send_image $(OBJS) 

build/%.o: $(SRC)/%.c build
	$(CC) $(CFLAGS) -c $< -o $@

build: 
	mkdir -p $@

clean:
	rm -rf send_image *.o *~ src/*~ build
