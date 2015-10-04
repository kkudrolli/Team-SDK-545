###################################################################
### Variables
###################################################################
SRC := src
SOURCES := $(wildcard src/*.c)
OBJS := $(patsubst src/%,build/%,$(SOURCES:.c=.o))
CC = gcc
CFLAGS = -Wall -Wextra -O2 -std=c99


###################################################################
### Targets
###################################################################
all: exec_uart 

exec_uart: $(OBJS)
	$(CC) $(CFLAGS) -o exec_uart $(OBJS) 

build/%.o: $(SRC)/%.c build
	$(CC) $(CFLAGS) -c $< -o $@

build: 
	mkdir -p $@

clean:
	rm -rf exec_uart *.o *~ src/*~ build
