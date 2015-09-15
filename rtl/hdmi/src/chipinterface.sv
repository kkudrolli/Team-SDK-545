/**************************************************************************
 *	"chipinterface.sv"
 *	GameBoy SystemVerilog reverse engineering project.
 *   Copyright (C) 2014 Sohil Shah
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.
 *	
 *	Contact Sohil Shah at sohils@cmu.edu with all questions. 
 **************************************************************************/

/* Module ChipInterface: Connects Cyclone V board ports to datapath
 *
 *	WIP
 *
 */
module ChipInterface
  /* ------------------------------------------------------------*/
  /***  CHIP PORT DECLARATIONS ***/
  /* ------------------------------------------------------------*/
  (
   // clocks
   input logic	       	SYSCLK_P, SYSCLK_N,
   input logic          rst,
   
   // hdmi
   output logic		    I2C_SCL,
   inout tri 	       	I2C_SDA,
   output logic [35:0]  HDMI_TX_D,
   output logic        	HDMI_TX_CLK,
   output logic        	HDMI_TX_DE,
   output logic        	HDMI_TX_HS,
   output logic        	HDMI_TX_VS
   );
   
   /* ------------------------------------------------------------*/
   /***  Xilinx PLL CLOCKS ***/
   /* ------------------------------------------------------------*/

   logic clk, sysclk;  
   logic rst;

   IBUFDS #(.DIFF_TERM("TRUE"), .IBUF_LOW_PWR("TRUE"), .IOSTANDARD("DEFAULT"))
            clk_ibufds (.O(sysclk), .I(SYSCLK_P), .IB(SYSCLK_N));
            
   clock ck (.clk_in1 (sysclk), .clk_out1 (HDMI_TX_CLK), .clk_out2 (clk), .reset (rst));
    

   hdmi encoder (.clk (HDMI_TX_CLK), .rst (rst), .hsync (HDMI_TX_HS), .vsync (HDMI_TX_VS), 
                 .data (HDMI_TX_D), .de (HDMI_TX_DE));
   
   /* ------------------------------------------------------------*/
   /***  HDMI I2C INSTANTIATION ***/
   /* ------------------------------------------------------------*/
   reg [7:0] outA;
   reg 	     stop;

   reg [4:0] counter;
   reg 	     clk_reduced;
   reg 	     ack;
   // Divide 5 MHz clk by 20 to give 250 kHz I2C logic driver. 
   always @(posedge clk) begin
      counter = (counter == 5'd19) ? 4'h0 : counter + 4'h1;
      clk_reduced = (stop) ? 1'b0 : ((counter == 4'h0) ? ~clk_reduced : clk_reduced);
   end
   
   i2c bus(.stop (stop), .clk (clk_reduced), .rst (rst), .outA (outA), .SDA (I2C_SDA), .SCL (I2C_SCL), .ACK (ack));

endmodule: ChipInterface