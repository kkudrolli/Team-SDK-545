/**************************************************************************
 *      "constants.sv"
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

`ifndef CONSTANTS

 `define CONSTANTS
 `define TRUE   1'b1
 `define FALSE  1'b0

 `timescale 1ns/100ps

/*      Constants file
 *
 *      Contains typedefs, macro definitions, and enumerations for readability
 */

/*
 *      Micro-code for i2c
 */
typedef enum logic [2:0] {
                          i2c_NOP       = 3'b000,
                          i2c_START     = 3'b001,
                          i2c_STOP      = 3'b010,
                          i2c_READ      = 3'b011,
                          i2c_WRITE     = 3'b100,
                          
                          i2c_HALT      = 3'b111,
                          i2c_UNK       = 3'bxxx
                          } i2c_micro_instruc_t;
