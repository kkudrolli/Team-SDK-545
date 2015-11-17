//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
//Date        : Mon Nov 16 21:27:41 2015
//Host        : horizon.andrew.cmu.edu running 64-bit Red Hat Enterprise Linux Server release 7.1 (Maipo)
//Command     : generate_target weights_0.bd
//Design      : weights_0
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "weights_0,IP_Integrator,{x_ipProduct=Vivado 2015.2,x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=weights_0,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,synth_mode=Global}" *) (* HW_HANDOFF = "weights_0.hwdef" *) 
module weights_0
   (BRAM_PORTA_addr,
    BRAM_PORTA_clk,
    BRAM_PORTA_din,
    BRAM_PORTA_dout,
    BRAM_PORTA_we);
  input [9:0]BRAM_PORTA_addr;
  input BRAM_PORTA_clk;
  input [4095:0]BRAM_PORTA_din;
  output [4095:0]BRAM_PORTA_dout;
  input [0:0]BRAM_PORTA_we;

  wire [9:0]BRAM_PORTA_1_ADDR;
  wire BRAM_PORTA_1_CLK;
  wire [4095:0]BRAM_PORTA_1_DIN;
  wire [4095:0]BRAM_PORTA_1_DOUT;
  wire [0:0]BRAM_PORTA_1_WE;

  assign BRAM_PORTA_1_ADDR = BRAM_PORTA_addr[9:0];
  assign BRAM_PORTA_1_CLK = BRAM_PORTA_clk;
  assign BRAM_PORTA_1_DIN = BRAM_PORTA_din[4095:0];
  assign BRAM_PORTA_1_WE = BRAM_PORTA_we[0];
  assign BRAM_PORTA_dout[4095:0] = BRAM_PORTA_1_DOUT;
  weights_0_blk_mem_gen_0_0 blk_mem_gen_0
       (.addra(BRAM_PORTA_1_ADDR),
        .clka(BRAM_PORTA_1_CLK),
        .dina(BRAM_PORTA_1_DIN),
        .douta(BRAM_PORTA_1_DOUT),
        .wea(BRAM_PORTA_1_WE));
endmodule
