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
all: deep_sim

deep_sim: $(OBJS)
	$(CC) $(CFLAGS) -o deep_sim $(OBJS)

build/%.o: $(SRC)/%.c build
	$(CC) $(CFLAGS) -c $< -o $@

build: 
	mkdir -p $@

clean:
	rm -rf deep_sim *.o *~ src/*~ build
