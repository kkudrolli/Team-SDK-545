//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
//Date        : Mon Nov 16 23:24:28 2015
//Host        : savage.andrew.cmu.edu running 64-bit Red Hat Enterprise Linux Server release 7.1 (Maipo)
//Command     : generate_target framebuffer_wrapper.bd
//Design      : framebuffer_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module framebuffer_wrapper
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

  wire [18:0]addra;
  wire [18:0]addrb;
  wire clka;
  wire clkb;
  wire [23:0]dina;
  wire [23:0]doutb;
  wire enb;
  wire [0:0]wea;

  framebuffer framebuffer_i
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dina(dina),
        .doutb(doutb),
        .enb(enb),
        .wea(wea));
endmodule
