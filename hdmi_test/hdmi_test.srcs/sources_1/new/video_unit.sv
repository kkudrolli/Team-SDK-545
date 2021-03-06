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
  (input logic 	       clka, clkb, 
   input logic 	       de,
   input logic         we,
   input logic [18:0]  addr_w,
   input logic [18:0]  addr_r,
   output logic [35:0] data,
   input logic [23:0]  data_in 
   );
   
   logic [23:0]        dout;
   // 524888? what is this magig number in bram generator?
   framebuffer_wrapper fb(.addra (addr_w), .addrb (addr_r), .clka (clka), .clkb (clkb), .dina (data_in), 
                          .doutb (dout), .wea (we), .enb (de));

   assign data = {{dout[23:16], 4'h0}, {dout[15:8], 4'h0}, {dout[7:0], 4'h0}};
   
endmodule
/*
module test;
     logic 	       clk;
     logic            de;
     logic [3:0]   we;
     logic [20:0]  addr_w;
     logic [20:0]  addr_r;
     logic [35:0] data;
     logic [31:0]  data_in; 
     
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    integer i;
    video_unit vu(clk,de,we,addr_w,addr_r,data,data_in);
    initial begin
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        addr_r = 0;
        de = 1;
        addr_w = 0;
        we = 4'hf;
        data_in = 32'haaaaaaaa;
        @(posedge clk);
        addr_w = 2;
        we = 4'hf;
        data_in = 32'hbbbbbbbb;
        @(posedge clk);
        addr_w = 3;
        we = 4'hf;
        data_in = 32'hcccccccc;
        @(posedge clk);
        we = 4'h0;
        @(posedge clk);
        addr_r = 0;
        @(posedge clk);
        addr_r = 1;
        @(posedge clk);
        addr_r = 2;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);

        $finish;
    end

endmodule*/