###################################################################
### Constants
###################################################################

# Text effects: normal, bold, underline
n=\e[0m
b=\e[1m
u=\e[4m

# Bold and green
g=\e[1;32m

# Bold and red
r=\e[1;31m

# Debug message
m=$g$uProjectDeep Makefile:$n 


###################################################################
### Help Screen
###################################################################

default:
	@echo -e "$mHELP SCREEN"
	@echo -e ""
	@echo -e "$bUSAGE:$n"
	@echo -e "\tmake $uTARGET$n [$uVARIABLE$n]..."
	@echo -e ""
	@echo -e ""
	@echo -e "$bTARGETS:$n"
	@echo -e "\t$bsim$n"
	@echo -e "\t    compiles simulator in $bsim/$n directory and generates" 
	@echo -e "\t    executable $bdeep_sim$n in $bsim/$n directory"
	@echo -e ""
	@echo -e "\t$bverilog$n"
	@echo -e "\t    compiles verilog code in $brtl/$n directory and generates"
	@echo -e "\t    executable $bsimv$n in $brtl/$n directory"
	@echo -e "\t"
	@echo -e "\t$bclean$n"
	@echo -e "\t    deletes temporary files and cleans all output files in "
	@echo -e "\t    $bsim/$n and $brtl/$n"
	@echo -e "\t"
	@exit 0


.PHONY: sim
sim: 
	@echo -e "$gCompiling software simulator: deep_sim$n"
	$(MAKE) -C sim/
	cp sim/deep_sim .
	@echo -e "\n$bDone! Simulator can be found as: ./deep_sim$n\n"

.PHONY: rtl
rtl: 
	@echo -e "$gCompiling verilog rtl simulator: deep_sim$n"
	$(MAKE) -C rtl/
	@echo -e "\n$bDone! Simulator can be found as: ./simv$n\n"

clean:
	@echo -e "$gCleaning all directries!$n"
	rm -f *~
	$(MAKE) -C sim/ clean
	$(MAKE) -C rtl/ clean
	@echo -e "\n$bDone!$n\n"
