###################################################################
### Variables
###################################################################
SRC := src
VSOURCES := $(wildcard ../src/*.sv)
CSOURCES := $(wildcard src/*.cpp)
VERILATOR = verilator/bin/verilator
VFLAGS = --top-module deep -Wall 
ROOT = $(CURDIR)

###################################################################
### Targets
###################################################################
all: Vdeep

Vdeep: obj_dir
	$(MAKE) -C obj_dir -j -f $@.mk $@
	cp obj_dir/Vdeep .

obj_dir: 
	LD_LIBRARY_PATH=/usr/lib VERILATOR_ROOT=$(ROOT)/verilator $(VERILATOR) $(VFLAGS) --cc $(VSOURCES) --exe $(CSOURCES)

ver:
	cd verilator ; autoconf ; ./configure 
	$(MAKE) -C verilator

clean:
	rm -rf Vdeep obj_dir
