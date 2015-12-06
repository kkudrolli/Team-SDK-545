// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
// Date        : Mon Nov 16 21:41:04 2015
// Host        : horizon.andrew.cmu.edu running 64-bit Red Hat Enterprise Linux Server release 7.1 (Maipo)
// Command     : write_verilog -force -mode synth_stub
//               /afs/ece.cmu.edu/usr/sohils/Private/18545/deep/hdmi_test/hdmi_test.srcs/sources_1/bd/clock/ip/clock_clk_wiz_0_0/clock_clk_wiz_0_0_stub.v
// Design      : clock_clk_wiz_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx485tffg1761-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clock_clk_wiz_0_0(clk_in1, clk_out1, clk_out2, clk_out3, reset)
/* synthesis syn_black_box black_box_pad_pin="clk_in1,clk_out1,clk_out2,clk_out3,reset" */;
  input clk_in1;
  output clk_out1;
  output clk_out2;
  output clk_out3;
  input reset;
endmodule
