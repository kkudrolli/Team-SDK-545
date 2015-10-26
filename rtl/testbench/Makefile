###################################################################
### Variables
###################################################################
SRC := src
VSOURCES := $(wildcard ../src/*.sv)
CSOURCES := $(wildcard src/*.cpp)
VERILATOR = verilator/bin/verilator
VFLAGS = -Wall 
ROOT = $(CURDIR)

###################################################################
### Targets
###################################################################
all: Vdeep

Vdeep: obj_dir
	$(MAKE) -C obj_dir -j -f $@.mk $@
	cp obj_dir/Vdeep .

obj_dir: 
	VERILATOR_ROOT=$(ROOT)/verilator $(VERILATOR) $(VFLAGS) --cc $(VSOURCES) --exe $(CSOURCES)

clean:
	rm -rf Vdeep obj_dir
