/**************************************************************************
 *      "I2C.sv"
 *      GameBoy SystemVerilog reverse engineering project.
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
 *      Contact Sohil Shah at sohils@cmu.edu with all questions. 
 **************************************************************************/

`include "constants.sv"

module i2c
  (input logic              clk,
   input logic              rst,
   output logic         SCL,
   output logic         ACK,
   inout tri            SDA,
   output logic [7:0]   outA,
   output logic         stop);

   // State enumeration
   enum                 logic [1:0] {s_stsp = 2'b10, s_negedge = 2'b11, s_data = 2'b00, s_posedge = 2'b01} curr, next;
   
   // Program counter and micro-code instruction store
   reg [8:0]            PC;
   reg [3:0]            IS [290:0];
   initial
     $readmemh("i2c.hex", IS);
   
   // Initialize PC to zero, increment at end of cycle
   always @(posedge clk, posedge rst)
     if (rst)
       PC <= 7'b0;
     else
       PC <= (curr == s_negedge) ? PC + 1'b1 : PC;
   
   // State machine transition logic
   always @(posedge clk, posedge rst)
     if (rst)
       curr <= s_data;
     else
       curr <= next;

   // Next state logic
   always_comb begin
      case (curr)
        s_stsp: next = s_negedge;
        s_negedge: next = s_data;
        s_data: next = s_posedge;
        s_posedge: next = s_stsp;
      endcase
   end
   
   // SCL logic
   always_comb begin
      case (curr)
        s_stsp: SCL = 1'b1;
        s_negedge: SCL = 1'b1;
        s_data: SCL = 1'b0;
        s_posedge: SCL = 1'b0;
      endcase
   end
   
   // Data logic:
   reg curr_data;
   reg RW; // Read high write low
   always @(posedge clk, posedge rst) begin
      if (rst)
        curr_data <= 1'b1;
      else begin
         case (IS[PC][3:1]) 
           
           i2c_START: begin
              if (curr == s_stsp || curr == s_negedge) begin
                 RW <= 1'b0;
                 curr_data <= 1'b0;
              end else begin
                 RW <= 1'b0;
                 curr_data <= 1'b1;
              end
           end
           
           i2c_STOP: begin
              if (curr == s_stsp || curr == s_negedge) begin
                 RW <= 1'b0;
                 curr_data <= 1'b1;
              end else begin
                 RW <= 1'b0;
                 curr_data <= 1'b0;
              end
           end
           
           i2c_READ: begin
              RW <= 1'b1;
              if (curr == s_negedge)
                curr_data <= SDA;
              else
                curr_data <= curr_data;
           end
           
           i2c_WRITE: begin
              RW <= 1'b0;
              curr_data <= IS[PC][0];
           end
           
           default: begin
              RW <= RW;
              curr_data <= curr_data;
           end
           
         endcase
      end
   end
   
   // SDA tri state driving
   assign SDA = (RW) ? 1'bz : curr_data;
   
   // Output shift register and acknowledge confirmation
   logic shift;
   logic ack;
   assign shift = (IS[PC-1][3:1] == i2c_READ && IS[PC-1][0] == 1'b0 && curr == s_data) ? 1'b1 : 1'b0;
   assign ack = (IS[PC-1][3:1] == i2c_READ && IS[PC-1][0] == 1'b1 && curr == s_data) ? ~curr_data : ACK;
   always @(posedge clk, posedge rst)
     if (rst) begin
        outA <= 8'b0;
        ACK <= 1'b1;
     end else begin
        outA <= (shift) ? {outA[6:0], curr_data} : outA;
        ACK <= ack;
     end

   always @(posedge clk, posedge rst) begin
      if (rst)
        stop <= 1'b0;
      else if (IS[PC][3:1] == i2c_HALT) begin
         stop <= 1'b1;
      end else
        stop <= 1'b0;
   end
endmodule: i2c
