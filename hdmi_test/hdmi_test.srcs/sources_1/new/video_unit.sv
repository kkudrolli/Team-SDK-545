`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2015 11:34:45 AM
// Design Name: 
// Module Name: video_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module video_unit
  (input logic 	       clk, 
   input logic 	       de,
   input logic [3:0]   we,
   input logic [18:0]  addr_w,
   input logic [18:0]  addr_r,
   output logic [35:0] data,
   input logic [31:0]  data_in 
   );
   
   logic [31:0]        dout;
   framebuffer_wrapper fb(.addra (addr_w), .addrb (addr_r), .clka (clk), .clkb (clk), .dina (data_in), 
                          .doutb (dout), .wea (we), .enb (de));
   
   assign data = {{dout[23:16], 4'h0}, {dout[15:8], 4'h0}, {dout[7:0], 4'h0}};
   
endmodule
