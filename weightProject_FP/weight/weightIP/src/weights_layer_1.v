//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
//Date        : Tue Nov 10 17:19:02 2015
//Host        : savage.andrew.cmu.edu running 64-bit Red Hat Enterprise Linux Server release 7.1 (Maipo)
//Command     : generate_target weights_layer_1.bd
//Design      : weights_layer_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "weights_layer_1,IP_Integrator,{x_ipProduct=Vivado 2015.2,x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=weights_layer_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=10,numReposBlks=10,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,synth_mode=Global}" *) (* HW_HANDOFF = "weights_layer_1.hwdef" *) 
module weights_layer_1
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

  wire [6:0]BRAM_PORTA_10_ADDR;
  wire BRAM_PORTA_10_CLK;
  wire [31:0]BRAM_PORTA_10_DIN;
  wire [31:0]BRAM_PORTA_10_DOUT;
  wire [0:0]BRAM_PORTA_10_WE;
  wire [6:0]BRAM_PORTA_1_ADDR;
  wire BRAM_PORTA_1_CLK;
  wire [31:0]BRAM_PORTA_1_DIN;
  wire [31:0]BRAM_PORTA_1_DOUT;
  wire [0:0]BRAM_PORTA_1_WE;
  wire [6:0]BRAM_PORTA_2_ADDR;
  wire BRAM_PORTA_2_CLK;
  wire [31:0]BRAM_PORTA_2_DIN;
  wire [31:0]BRAM_PORTA_2_DOUT;
  wire [0:0]BRAM_PORTA_2_WE;
  wire [6:0]BRAM_PORTA_3_ADDR;
  wire BRAM_PORTA_3_CLK;
  wire [31:0]BRAM_PORTA_3_DIN;
  wire [31:0]BRAM_PORTA_3_DOUT;
  wire [0:0]BRAM_PORTA_3_WE;
  wire [6:0]BRAM_PORTA_4_ADDR;
  wire BRAM_PORTA_4_CLK;
  wire [31:0]BRAM_PORTA_4_DIN;
  wire [31:0]BRAM_PORTA_4_DOUT;
  wire [0:0]BRAM_PORTA_4_WE;
  wire [6:0]BRAM_PORTA_5_ADDR;
  wire BRAM_PORTA_5_CLK;
  wire [31:0]BRAM_PORTA_5_DIN;
  wire [31:0]BRAM_PORTA_5_DOUT;
  wire [0:0]BRAM_PORTA_5_WE;
  wire [6:0]BRAM_PORTA_6_ADDR;
  wire BRAM_PORTA_6_CLK;
  wire [31:0]BRAM_PORTA_6_DIN;
  wire [31:0]BRAM_PORTA_6_DOUT;
  wire [0:0]BRAM_PORTA_6_WE;
  wire [6:0]BRAM_PORTA_7_ADDR;
  wire BRAM_PORTA_7_CLK;
  wire [31:0]BRAM_PORTA_7_DIN;
  wire [31:0]BRAM_PORTA_7_DOUT;
  wire [0:0]BRAM_PORTA_7_WE;
  wire [6:0]BRAM_PORTA_8_ADDR;
  wire BRAM_PORTA_8_CLK;
  wire [31:0]BRAM_PORTA_8_DIN;
  wire [31:0]BRAM_PORTA_8_DOUT;
  wire [0:0]BRAM_PORTA_8_WE;
  wire [6:0]BRAM_PORTA_9_ADDR;
  wire BRAM_PORTA_9_CLK;
  wire [31:0]BRAM_PORTA_9_DIN;
  wire [31:0]BRAM_PORTA_9_DOUT;
  wire [0:0]BRAM_PORTA_9_WE;

  assign BRAM_PORTA1_dout[31:0] = BRAM_PORTA_2_DOUT;
  assign BRAM_PORTA2_dout[31:0] = BRAM_PORTA_3_DOUT;
  assign BRAM_PORTA3_dout[31:0] = BRAM_PORTA_4_DOUT;
  assign BRAM_PORTA4_dout[31:0] = BRAM_PORTA_5_DOUT;
  assign BRAM_PORTA5_dout[31:0] = BRAM_PORTA_6_DOUT;
  assign BRAM_PORTA6_dout[31:0] = BRAM_PORTA_7_DOUT;
  assign BRAM_PORTA7_dout[31:0] = BRAM_PORTA_8_DOUT;
  assign BRAM_PORTA8_dout[31:0] = BRAM_PORTA_9_DOUT;
  assign BRAM_PORTA9_dout[31:0] = BRAM_PORTA_10_DOUT;
  assign BRAM_PORTA_10_ADDR = BRAM_PORTA9_addr[6:0];
  assign BRAM_PORTA_10_CLK = BRAM_PORTA9_clk;
  assign BRAM_PORTA_10_DIN = BRAM_PORTA9_din[31:0];
  assign BRAM_PORTA_10_WE = BRAM_PORTA9_we[0];
  assign BRAM_PORTA_1_ADDR = BRAM_PORTA_addr[6:0];
  assign BRAM_PORTA_1_CLK = BRAM_PORTA_clk;
  assign BRAM_PORTA_1_DIN = BRAM_PORTA_din[31:0];
  assign BRAM_PORTA_1_WE = BRAM_PORTA_we[0];
  assign BRAM_PORTA_2_ADDR = BRAM_PORTA1_addr[6:0];
  assign BRAM_PORTA_2_CLK = BRAM_PORTA1_clk;
  assign BRAM_PORTA_2_DIN = BRAM_PORTA1_din[31:0];
  assign BRAM_PORTA_2_WE = BRAM_PORTA1_we[0];
  assign BRAM_PORTA_3_ADDR = BRAM_PORTA2_addr[6:0];
  assign BRAM_PORTA_3_CLK = BRAM_PORTA2_clk;
  assign BRAM_PORTA_3_DIN = BRAM_PORTA2_din[31:0];
  assign BRAM_PORTA_3_WE = BRAM_PORTA2_we[0];
  assign BRAM_PORTA_4_ADDR = BRAM_PORTA3_addr[6:0];
  assign BRAM_PORTA_4_CLK = BRAM_PORTA3_clk;
  assign BRAM_PORTA_4_DIN = BRAM_PORTA3_din[31:0];
  assign BRAM_PORTA_4_WE = BRAM_PORTA3_we[0];
  assign BRAM_PORTA_5_ADDR = BRAM_PORTA4_addr[6:0];
  assign BRAM_PORTA_5_CLK = BRAM_PORTA4_clk;
  assign BRAM_PORTA_5_DIN = BRAM_PORTA4_din[31:0];
  assign BRAM_PORTA_5_WE = BRAM_PORTA4_we[0];
  assign BRAM_PORTA_6_ADDR = BRAM_PORTA5_addr[6:0];
  assign BRAM_PORTA_6_CLK = BRAM_PORTA5_clk;
  assign BRAM_PORTA_6_DIN = BRAM_PORTA5_din[31:0];
  assign BRAM_PORTA_6_WE = BRAM_PORTA5_we[0];
  assign BRAM_PORTA_7_ADDR = BRAM_PORTA6_addr[6:0];
  assign BRAM_PORTA_7_CLK = BRAM_PORTA6_clk;
  assign BRAM_PORTA_7_DIN = BRAM_PORTA6_din[31:0];
  assign BRAM_PORTA_7_WE = BRAM_PORTA6_we[0];
  assign BRAM_PORTA_8_ADDR = BRAM_PORTA7_addr[6:0];
  assign BRAM_PORTA_8_CLK = BRAM_PORTA7_clk;
  assign BRAM_PORTA_8_DIN = BRAM_PORTA7_din[31:0];
  assign BRAM_PORTA_8_WE = BRAM_PORTA7_we[0];
  assign BRAM_PORTA_9_ADDR = BRAM_PORTA8_addr[6:0];
  assign BRAM_PORTA_9_CLK = BRAM_PORTA8_clk;
  assign BRAM_PORTA_9_DIN = BRAM_PORTA8_din[31:0];
  assign BRAM_PORTA_9_WE = BRAM_PORTA8_we[0];
  assign BRAM_PORTA_dout[31:0] = BRAM_PORTA_1_DOUT;
  weights_layer_1_blk_mem_gen_0_0 blk_mem_gen_0
       (.addra(BRAM_PORTA_1_ADDR),
        .clka(BRAM_PORTA_1_CLK),
        .dina(BRAM_PORTA_1_DIN),
        .douta(BRAM_PORTA_1_DOUT),
        .wea(BRAM_PORTA_1_WE));
  weights_layer_1_blk_mem_gen_0_1 blk_mem_gen_1
       (.addra(BRAM_PORTA_2_ADDR),
        .clka(BRAM_PORTA_2_CLK),
        .dina(BRAM_PORTA_2_DIN),
        .douta(BRAM_PORTA_2_DOUT),
        .wea(BRAM_PORTA_2_WE));
  weights_layer_1_blk_mem_gen_0_2 blk_mem_gen_2
       (.addra(BRAM_PORTA_3_ADDR),
        .clka(BRAM_PORTA_3_CLK),
        .dina(BRAM_PORTA_3_DIN),
        .douta(BRAM_PORTA_3_DOUT),
        .wea(BRAM_PORTA_3_WE));
  weights_layer_1_blk_mem_gen_0_3 blk_mem_gen_3
       (.addra(BRAM_PORTA_4_ADDR),
        .clka(BRAM_PORTA_4_CLK),
        .dina(BRAM_PORTA_4_DIN),
        .douta(BRAM_PORTA_4_DOUT),
        .wea(BRAM_PORTA_4_WE));
  weights_layer_1_blk_mem_gen_0_4 blk_mem_gen_4
       (.addra(BRAM_PORTA_5_ADDR),
        .clka(BRAM_PORTA_5_CLK),
        .dina(BRAM_PORTA_5_DIN),
        .douta(BRAM_PORTA_5_DOUT),
        .wea(BRAM_PORTA_5_WE));
  weights_layer_1_blk_mem_gen_0_5 blk_mem_gen_5
       (.addra(BRAM_PORTA_6_ADDR),
        .clka(BRAM_PORTA_6_CLK),
        .dina(BRAM_PORTA_6_DIN),
        .douta(BRAM_PORTA_6_DOUT),
        .wea(BRAM_PORTA_6_WE));
  weights_layer_1_blk_mem_gen_0_6 blk_mem_gen_6
       (.addra(BRAM_PORTA_7_ADDR),
        .clka(BRAM_PORTA_7_CLK),
        .dina(BRAM_PORTA_7_DIN),
        .douta(BRAM_PORTA_7_DOUT),
        .wea(BRAM_PORTA_7_WE));
  weights_layer_1_blk_mem_gen_0_7 blk_mem_gen_7
       (.addra(BRAM_PORTA_8_ADDR),
        .clka(BRAM_PORTA_8_CLK),
        .dina(BRAM_PORTA_8_DIN),
        .douta(BRAM_PORTA_8_DOUT),
        .wea(BRAM_PORTA_8_WE));
  weights_layer_1_blk_mem_gen_0_8 blk_mem_gen_8
       (.addra(BRAM_PORTA_9_ADDR),
        .clka(BRAM_PORTA_9_CLK),
        .dina(BRAM_PORTA_9_DIN),
        .douta(BRAM_PORTA_9_DOUT),
        .wea(BRAM_PORTA_9_WE));
  weights_layer_1_blk_mem_gen_0_9 blk_mem_gen_9
       (.addra(BRAM_PORTA_10_ADDR),
        .clka(BRAM_PORTA_10_CLK),
        .dina(BRAM_PORTA_10_DIN),
        .douta(BRAM_PORTA_10_DOUT),
        .wea(BRAM_PORTA_10_WE));
endmodule
