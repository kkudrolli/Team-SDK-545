################################################################################

# This XDC is used only for OOC mode of synthesis, implementation
# This constraints file contains default clock frequencies to be used during
# out-of-context flows such as OOC Synthesis and Hierarchical Designs.
# This constraints file is not used in normal top-down synthesis (default flow
# of Vivado)
################################################################################
create_clock -name BRAM_PORTA_clk -period 10 [get_ports BRAM_PORTA_clk]
create_clock -name BRAM_PORTA1_clk -period 10 [get_ports BRAM_PORTA1_clk]
create_clock -name BRAM_PORTA2_clk -period 10 [get_ports BRAM_PORTA2_clk]
create_clock -name BRAM_PORTA3_clk -period 10 [get_ports BRAM_PORTA3_clk]
create_clock -name BRAM_PORTA4_clk -period 10 [get_ports BRAM_PORTA4_clk]
create_clock -name BRAM_PORTA5_clk -period 10 [get_ports BRAM_PORTA5_clk]
create_clock -name BRAM_PORTA6_clk -period 10 [get_ports BRAM_PORTA6_clk]
create_clock -name BRAM_PORTA7_clk -period 10 [get_ports BRAM_PORTA7_clk]
create_clock -name BRAM_PORTA8_clk -period 10 [get_ports BRAM_PORTA8_clk]
create_clock -name BRAM_PORTA9_clk -period 10 [get_ports BRAM_PORTA9_clk]

################################################################################