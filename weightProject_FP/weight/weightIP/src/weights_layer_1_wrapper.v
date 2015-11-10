//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
//Date        : Tue Nov 10 17:19:02 2015
//Host        : savage.andrew.cmu.edu running 64-bit Red Hat Enterprise Linux Server release 7.1 (Maipo)
//Command     : generate_target weights_layer_1_wrapper.bd
//Design      : weights_layer_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module weights_layer_1_wrapper
   (BRAM_PORTA1_addr,
    BRAM_PORTA1_clk,
    BRAM_PORTA1_din,
    BRAM_PORTA1_dout,
    BRAM_PORTA1_we,
    BRAM_PORTA2_addr,
    BRAM_PORTA2_clk,
    BRAM_PORTA2_din,
    BRAM_PORTA2_dout,
    BRAM_PORTA2_we,
    BRAM_PORTA3_addr,
    BRAM_PORTA3_clk,
    BRAM_PORTA3_din,
    BRAM_PORTA3_dout,
    BRAM_PORTA3_we,
    BRAM_PORTA4_addr,
    BRAM_PORTA4_clk,
    BRAM_PORTA4_din,
    BRAM_PORTA4_dout,
    BRAM_PORTA4_we,
    BRAM_PORTA5_addr,
    BRAM_PORTA5_clk,
    BRAM_PORTA5_din,
    BRAM_PORTA5_dout,
    BRAM_PORTA5_we,
    BRAM_PORTA6_addr,
    BRAM_PORTA6_clk,
    BRAM_PORTA6_din,
    BRAM_PORTA6_dout,
    BRAM_PORTA6_we,
    BRAM_PORTA7_addr,
    BRAM_PORTA7_clk,
    BRAM_PORTA7_din,
    BRAM_PORTA7_dout,
    BRAM_PORTA7_we,
    BRAM_PORTA8_addr,
    BRAM_PORTA8_clk,
    BRAM_PORTA8_din,
    BRAM_PORTA8_dout,
    BRAM_PORTA8_we,
    BRAM_PORTA9_addr,
    BRAM_PORTA9_clk,
    BRAM_PORTA9_din,
    BRAM_PORTA9_dout,
    BRAM_PORTA9_we,
    BRAM_PORTA_addr,
    BRAM_PORTA_clk,
    BRAM_PORTA_din,
    BRAM_PORTA_dout,
    BRAM_PORTA_we);
  input [6:0]BRAM_PORTA1_addr;
  input BRAM_PORTA1_clk;
  input [31:0]BRAM_PORTA1_din;
  output [31:0]BRAM_PORTA1_dout;
  input [0:0]BRAM_PORTA1_we;
  input [6:0]BRAM_PORTA2_addr;
  input BRAM_PORTA2_clk;
  input [31:0]BRAM_PORTA2_din;
  output [31:0]BRAM_PORTA2_dout;
  input [0:0]BRAM_PORTA2_we;
  input [6:0]BRAM_PORTA3_addr;
  input BRAM_PORTA3_clk;
  input [31:0]BRAM_PORTA3_din;
  output [31:0]BRAM_PORTA3_dout;
  input [0:0]BRAM_PORTA3_we;
  input [6:0]BRAM_PORTA4_addr;
  input BRAM_PORTA4_clk;
  input [31:0]BRAM_PORTA4_din;
  output [31:0]BRAM_PORTA4_dout;
  input [0:0]BRAM_PORTA4_we;
  input [6:0]BRAM_PORTA5_addr;
  input BRAM_PORTA5_clk;
  input [31:0]BRAM_PORTA5_din;
  output [31:0]BRAM_PORTA5_dout;
  input [0:0]BRAM_PORTA5_we;
  input [6:0]BRAM_PORTA6_addr;
  input BRAM_PORTA6_clk;
  input [31:0]BRAM_PORTA6_din;
  output [31:0]BRAM_PORTA6_dout;
  input [0:0]BRAM_PORTA6_we;
  input [6:0]BRAM_PORTA7_addr;
  input BRAM_PORTA7_clk;
  input [31:0]BRAM_PORTA7_din;
  output [31:0]BRAM_PORTA7_dout;
  input [0:0]BRAM_PORTA7_we;
  input [6:0]BRAM_PORTA8_addr;
  input BRAM_PORTA8_clk;
  input [31:0]BRAM_PORTA8_din;
  output [31:0]BRAM_PORTA8_dout;
  input [0:0]BRAM_PORTA8_we;
  input [6:0]BRAM_PORTA9_addr;
  input BRAM_PORTA9_clk;
  input [31:0]BRAM_PORTA9_din;
  output [31:0]BRAM_PORTA9_dout;
  input [0:0]BRAM_PORTA9_we;
  input [6:0]BRAM_PORTA_addr;
  input BRAM_PORTA_clk;
  input [31:0]BRAM_PORTA_din;
  output [31:0]BRAM_PORTA_dout;
  input [0:0]BRAM_PORTA_we;

  wire [6:0]BRAM_PORTA1_addr;
  wire BRAM_PORTA1_clk;
  wire [31:0]BRAM_PORTA1_din;
  wire [31:0]BRAM_PORTA1_dout;
  wire [0:0]BRAM_PORTA1_we;
  wire [6:0]BRAM_PORTA2_addr;
  wire BRAM_PORTA2_clk;
  wire [31:0]BRAM_PORTA2_din;
  wire [31:0]BRAM_PORTA2_dout;
  wire [0:0]BRAM_PORTA2_we;
  wire [6:0]BRAM_PORTA3_addr;
  wire BRAM_PORTA3_clk;
  wire [31:0]BRAM_PORTA3_din;
  wire [31:0]BRAM_PORTA3_dout;
  wire [0:0]BRAM_PORTA3_we;
  wire [6:0]BRAM_PORTA4_addr;
  wire BRAM_PORTA4_clk;
  wire [31:0]BRAM_PORTA4_din;
  wire [31:0]BRAM_PORTA4_dout;
  wire [0:0]BRAM_PORTA4_we;
  wire [6:0]BRAM_PORTA5_addr;
  wire BRAM_PORTA5_clk;
  wire [31:0]BRAM_PORTA5_din;
  wire [31:0]BRAM_PORTA5_dout;
  wire [0:0]BRAM_PORTA5_we;
  wire [6:0]BRAM_PORTA6_addr;
  wire BRAM_PORTA6_clk;
  wire [31:0]BRAM_PORTA6_din;
  wire [31:0]BRAM_PORTA6_dout;
  wire [0:0]BRAM_PORTA6_we;
  wire [6:0]BRAM_PORTA7_addr;
  wire BRAM_PORTA7_clk;
  wire [31:0]BRAM_PORTA7_din;
  wire [31:0]BRAM_PORTA7_dout;
  wire [0:0]BRAM_PORTA7_we;
  wire [6:0]BRAM_PORTA8_addr;
  wire BRAM_PORTA8_clk;
  wire [31:0]BRAM_PORTA8_din;
  wire [31:0]BRAM_PORTA8_dout;
  wire [0:0]BRAM_PORTA8_we;
  wire [6:0]BRAM_PORTA9_addr;
  wire BRAM_PORTA9_clk;
  wire [31:0]BRAM_PORTA9_din;
  wire [31:0]BRAM_PORTA9_dout;
  wire [0:0]BRAM_PORTA9_we;
  wire [6:0]BRAM_PORTA_addr;
  wire BRAM_PORTA_clk;
  wire [31:0]BRAM_PORTA_din;
  wire [31:0]BRAM_PORTA_dout;
  wire [0:0]BRAM_PORTA_we;

  weights_layer_1 weights_layer_1_i
       (.BRAM_PORTA1_addr(BRAM_PORTA1_addr),
        .BRAM_PORTA1_clk(BRAM_PORTA1_clk),
        .BRAM_PORTA1_din(BRAM_PORTA1_din),
        .BRAM_PORTA1_dout(BRAM_PORTA1_dout),
        .BRAM_PORTA1_we(BRAM_PORTA1_we),
        .BRAM_PORTA2_addr(BRAM_PORTA2_addr),
        .BRAM_PORTA2_clk(BRAM_PORTA2_clk),
        .BRAM_PORTA2_din(BRAM_PORTA2_din),
        .BRAM_PORTA2_dout(BRAM_PORTA2_dout),
        .BRAM_PORTA2_we(BRAM_PORTA2_we),
        .BRAM_PORTA3_addr(BRAM_PORTA3_addr),
        .BRAM_PORTA3_clk(BRAM_PORTA3_clk),
        .BRAM_PORTA3_din(BRAM_PORTA3_din),
        .BRAM_PORTA3_dout(BRAM_PORTA3_dout),
        .BRAM_PORTA3_we(BRAM_PORTA3_we),
        .BRAM_PORTA4_addr(BRAM_PORTA4_addr),
        .BRAM_PORTA4_clk(BRAM_PORTA4_clk),
        .BRAM_PORTA4_din(BRAM_PORTA4_din),
        .BRAM_PORTA4_dout(BRAM_PORTA4_dout),
        .BRAM_PORTA4_we(BRAM_PORTA4_we),
        .BRAM_PORTA5_addr(BRAM_PORTA5_addr),
        .BRAM_PORTA5_clk(BRAM_PORTA5_clk),
        .BRAM_PORTA5_din(BRAM_PORTA5_din),
        .BRAM_PORTA5_dout(BRAM_PORTA5_dout),
        .BRAM_PORTA5_we(BRAM_PORTA5_we),
        .BRAM_PORTA6_addr(BRAM_PORTA6_addr),
        .BRAM_PORTA6_clk(BRAM_PORTA6_clk),
        .BRAM_PORTA6_din(BRAM_PORTA6_din),
        .BRAM_PORTA6_dout(BRAM_PORTA6_dout),
        .BRAM_PORTA6_we(BRAM_PORTA6_we),
        .BRAM_PORTA7_addr(BRAM_PORTA7_addr),
        .BRAM_PORTA7_clk(BRAM_PORTA7_clk),
        .BRAM_PORTA7_din(BRAM_PORTA7_din),
        .BRAM_PORTA7_dout(BRAM_PORTA7_dout),
        .BRAM_PORTA7_we(BRAM_PORTA7_we),
        .BRAM_PORTA8_addr(BRAM_PORTA8_addr),
        .BRAM_PORTA8_clk(BRAM_PORTA8_clk),
        .BRAM_PORTA8_din(BRAM_PORTA8_din),
        .BRAM_PORTA8_dout(BRAM_PORTA8_dout),
        .BRAM_PORTA8_we(BRAM_PORTA8_we),
        .BRAM_PORTA9_addr(BRAM_PORTA9_addr),
        .BRAM_PORTA9_clk(BRAM_PORTA9_clk),
        .BRAM_PORTA9_din(BRAM_PORTA9_din),
        .BRAM_PORTA9_dout(BRAM_PORTA9_dout),
        .BRAM_PORTA9_we(BRAM_PORTA9_we),
        .BRAM_PORTA_addr(BRAM_PORTA_addr),
        .BRAM_PORTA_clk(BRAM_PORTA_clk),
        .BRAM_PORTA_din(BRAM_PORTA_din),
        .BRAM_PORTA_dout(BRAM_PORTA_dout),
        .BRAM_PORTA_we(BRAM_PORTA_we));
endmodule
