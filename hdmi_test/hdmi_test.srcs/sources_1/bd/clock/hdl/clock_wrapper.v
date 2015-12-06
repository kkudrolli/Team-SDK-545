//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
//Date        : Mon Nov 30 15:22:29 2015
//Host        : horizon.andrew.cmu.edu running 64-bit Red Hat Enterprise Linux Server release 7.2 (Maipo)
//Command     : generate_target clock_wrapper.bd
//Design      : clock_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module clock_wrapper
   (clk_in1,
    clk_out1,
    clk_out2,
    clk_out3,
    clk_out4,
    reset);
  input clk_in1;
  output clk_out1;
  output clk_out2;
  output clk_out3;
  output clk_out4;
  input reset;

  wire clk_in1;
  wire clk_out1;
  wire clk_out2;
  wire clk_out3;
  wire clk_out4;
  wire reset;

  clock clock_i
       (.clk_in1(clk_in1),
        .clk_out1(clk_out1),
        .clk_out2(clk_out2),
        .clk_out3(clk_out3),
        .clk_out4(clk_out4),
        .reset(reset));
endmodule
