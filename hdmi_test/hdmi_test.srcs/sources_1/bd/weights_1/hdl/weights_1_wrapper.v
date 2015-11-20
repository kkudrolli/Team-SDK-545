//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
//Date        : Wed Nov 18 10:43:14 2015
//Host        : savage.andrew.cmu.edu running 64-bit Red Hat Enterprise Linux Server release 7.1 (Maipo)
//Command     : generate_target weights_1_wrapper.bd
//Design      : weights_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module weights_1_wrapper
   (BRAM_PORTA_addr,
    BRAM_PORTA_clk,
    BRAM_PORTA_din,
    BRAM_PORTA_dout,
    BRAM_PORTA_we);
  input [6:0]BRAM_PORTA_addr;
  input BRAM_PORTA_clk;
  input [319:0]BRAM_PORTA_din;
  output [319:0]BRAM_PORTA_dout;
  input [0:0]BRAM_PORTA_we;

  wire [6:0]BRAM_PORTA_addr;
  wire BRAM_PORTA_clk;
  wire [319:0]BRAM_PORTA_din;
  wire [319:0]BRAM_PORTA_dout;
  wire [0:0]BRAM_PORTA_we;

  weights_1 weights_1_i
       (.BRAM_PORTA_addr(BRAM_PORTA_addr),
        .BRAM_PORTA_clk(BRAM_PORTA_clk),
        .BRAM_PORTA_din(BRAM_PORTA_din),
        .BRAM_PORTA_dout(BRAM_PORTA_dout),
        .BRAM_PORTA_we(BRAM_PORTA_we));
endmodule
