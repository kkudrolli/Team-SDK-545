//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
//Date        : Sun Dec  6 17:18:10 2015
//Host        : savage.andrew.cmu.edu running 64-bit Red Hat Enterprise Linux Server release 7.2 (Maipo)
//Command     : generate_target framebuffer.bd
//Design      : framebuffer
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "framebuffer,IP_Integrator,{x_ipProduct=Vivado 2015.2,x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=framebuffer,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,synth_mode=Global}" *) (* HW_HANDOFF = "framebuffer.hwdef" *) 
module framebuffer
   (addra,
    addrb,
    clka,
    clkb,
    dina,
    doutb,
    enb,
    wea);
  input [18:0]addra;
  input [18:0]addrb;
  input clka;
  input clkb;
  input [23:0]dina;
  output [23:0]doutb;
  input enb;
  input [0:0]wea;

  wire [18:0]addra_1;
  wire [18:0]addrb_1;
  wire [23:0]blk_mem_gen_1_doutb;
  wire clka_1;
  wire clkb_1;
  wire [23:0]dina_1;
  wire enb_1;
  wire [0:0]wea_1;

  assign addra_1 = addra[18:0];
  assign addrb_1 = addrb[18:0];
  assign clka_1 = clka;
  assign clkb_1 = clkb;
  assign dina_1 = dina[23:0];
  assign doutb[23:0] = blk_mem_gen_1_doutb;
  assign enb_1 = enb;
  assign wea_1 = wea[0];
  framebuffer_blk_mem_gen_1_0 blk_mem_gen_1
       (.addra(addra_1),
        .addrb(addrb_1),
        .clka(clka_1),
        .clkb(clkb_1),
        .dina(dina_1),
        .doutb(blk_mem_gen_1_doutb),
        .enb(enb_1),
        .wea(wea_1));
endmodule
