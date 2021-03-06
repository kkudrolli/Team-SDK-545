//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
//Date        : Mon Dec  7 15:25:56 2015
//Host        : horizon.andrew.cmu.edu running 64-bit Red Hat Enterprise Linux Server release 7.2 (Maipo)
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
    BRAM_PORTA_we,
    BRAM_PORTB_addr,
    BRAM_PORTB_clk,
    BRAM_PORTB_din,
    BRAM_PORTB_dout,
    BRAM_PORTB_we);
  input [6:0]BRAM_PORTA_addr;
  input BRAM_PORTA_clk;
  input [319:0]BRAM_PORTA_din;
  output [319:0]BRAM_PORTA_dout;
  input [0:0]BRAM_PORTA_we;
  input [6:0]BRAM_PORTB_addr;
  input BRAM_PORTB_clk;
  input [319:0]BRAM_PORTB_din;
  output [319:0]BRAM_PORTB_dout;
  input [0:0]BRAM_PORTB_we;

  wire [6:0]BRAM_PORTA_addr;
  wire BRAM_PORTA_clk;
  wire [319:0]BRAM_PORTA_din;
  wire [319:0]BRAM_PORTA_dout;
  wire [0:0]BRAM_PORTA_we;
  wire [6:0]BRAM_PORTB_addr;
  wire BRAM_PORTB_clk;
  wire [319:0]BRAM_PORTB_din;
  wire [319:0]BRAM_PORTB_dout;
  wire [0:0]BRAM_PORTB_we;

  weights_1 weights_1_i
       (.BRAM_PORTA_addr(BRAM_PORTA_addr),
        .BRAM_PORTA_clk(BRAM_PORTA_clk),
        .BRAM_PORTA_din(BRAM_PORTA_din),
        .BRAM_PORTA_dout(BRAM_PORTA_dout),
        .BRAM_PORTA_we(BRAM_PORTA_we),
        .BRAM_PORTB_addr(BRAM_PORTB_addr),
        .BRAM_PORTB_clk(BRAM_PORTB_clk),
        .BRAM_PORTB_din(BRAM_PORTB_din),
        .BRAM_PORTB_dout(BRAM_PORTB_dout),
        .BRAM_PORTB_we(BRAM_PORTB_we));
endmodule
