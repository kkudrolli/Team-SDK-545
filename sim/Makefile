###################################################################
### Variables
###################################################################
SOURCES := $(wildcard src/*.c)
OBJS := $(SOURCES:.c=.o)
CC = gcc
CFLAGS = -Wall -Wextra -std=c99


###################################################################
### Targets
###################################################################
all: deep_sim

deep_sim: $(OBJS)
	$(CC) $(CFLAGS) -o deep_sim $(subst src/,, $(OBJS))

.c.o:
	$(CC) $(CFLAGS) -c $<

clean:
	rm -rf deep_sim *.o *~ src/*~
