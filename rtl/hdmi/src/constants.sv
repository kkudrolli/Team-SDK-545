/**************************************************************************
 *	"constants.sv"
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

`ifndef CONSTANTS

 `define CONSTANTS
 `define TRUE 	1'b1
 `define FALSE 	1'b0

 `timescale 1ns/100ps

/*	Constants file
 *
 *	Contains typedefs, macro definitions, and enumerations for readability
 */

/*
 *	Register enumeration
 */
typedef enum logic [2:0] {
			  reg_A		= 3'b000,
			  reg_B		= 3'b001,
			  reg_C		= 3'b010,
			  reg_D		= 3'b011,
			  reg_E		= 3'b100,
			  reg_H		= 3'b101,
			  reg_L		= 3'b110,
			  
			  reg_UNK      	= 3'bxxx
			  } reg_sel_t;

/*
 *	ALU Op Code enumeration
 */
typedef enum logic [5:0] {
			  alu_NOP 	= 6'b00_0000,
			  alu_B        	= 6'b00_0001, 
			  alu_ADD 	= 6'b00_0010,
			  alu_ADC 	= 6'b00_0011,
			  alu_SUB 	= 6'b00_0100,
			  alu_SBC 	= 6'b00_0101,
			  alu_AND 	= 6'b00_0110,
			  alu_OR       	= 6'b00_0111,
			  alu_XOR 	= 6'b00_1000,
			  alu_INC 	= 6'b00_1001,
			  alu_DEC 	= 6'b00_1010,
			  alu_SWAP 	= 6'b00_1011,
			  alu_DAA 	= 6'b00_1100,
			  alu_CPL 	= 6'b00_1101,
			  alu_RLC 	= 6'b00_1110,
			  alu_RLCA	= 6'b00_1111,
			  alu_RL       	= 6'b01_0000,
			  alu_RLA      	= 6'b01_0001,
			  alu_RRC 	= 6'b01_0010,
			  alu_RRCA	= 6'b01_0011,
			  alu_RR       	= 6'b01_0100,
			  alu_RRA      	= 6'b01_0101,
			  alu_SLA 	= 6'b01_0110,
			  alu_SRA 	= 6'b01_0111,
			  alu_SRL 	= 6'b01_1000,
			  alu_AB       	= 6'b01_1001,
			  alu_INCL	= 6'b01_1010,
			  alu_DECL	= 6'b01_1011,
			  alu_ADS_PC	= 6'b01_1100,
			  alu_SCF      	= 6'b01_1101,
			  alu_CCF      	= 6'b01_1110,
			  alu_ADS_SP	= 6'b01_1111,
			  alu_BIT      	= 6'b10_0000,
			  alu_SET      	= 6'b10_0001,
			  alu_RES      	= 6'b10_0010,

			  alu_UNK 	= 6'bxx_xxxx
			  } alu_op_t;

/*
 *	ALU sources enumeration
 */
typedef enum logic [4:0] {
			  src_NONE 	= 5'b00_000,
			  src_REGA 	= 5'b00_001,
			  src_REGB 	= 5'b00_010,
			  src_SP_l 	= 5'b00_011,
			  src_SP_h 	= 5'b00_100,
			  src_PC_l 	= 5'b00_101,
			  src_PC_h 	= 5'b00_110,
			  src_MEMD 	= 5'b00_111,
			  src_MEMA	= 5'b01_000,
			  src_FLAGS	= 5'b01_001,

			  src_00       	= 5'b01_010,
			  src_08	= 5'b01_011,
			  src_10	= 5'b01_100,
			  src_18	= 5'b01_101,
			  src_20	= 5'b01_110,
			  src_28	= 5'b01_111,
			  src_30	= 5'b10_000,
			  src_38	= 5'b10_001,
			  src_40	= 5'b10_010,
			  src_48	= 5'b10_011,
			  src_50	= 5'b10_100,
			  src_58	= 5'b10_101,
			  src_60	= 5'b10_110,

			  src_UNK 	= 5'bxx_xxx
			  } alu_src_t;

/*
 *	ALU destination enumeration
 */
typedef enum logic [3:0] {
			  dest_NONE 	= 4'b0_000,
			  dest_REG  	= 4'b0_001,
			  dest_SP_l 	= 4'b0_010,
			  dest_SP_h 	= 4'b0_011,
			  dest_PC_l 	= 4'b0_100,
			  dest_PC_h 	= 4'b0_101,
			  dest_MEMD 	= 4'b0_110,
			  dest_MEMA 	= 4'b0_111,
			  dest_MEMA_l   = 4'b1_000,
			  dest_MEMA_h   = 4'b1_001,
			  dest_PC 	= 4'b1_010,
			  dest_REGA     = 4'b1_100,
			  dest_SP      	= 4'b1_101,
			  dest_FLAGS	= 4'b1_110,
			  dest_MEMAH	= 4'b1_111,

			  dest_UNK 	= 4'bxxxx
			  } dest_t;

/*
 *	Controlpath FSM State enumeration
 */
typedef enum logic [1:0] {
			  s_FETCH      	= 2'b00,
			  s_DECODE	= 2'b01,
			  s_EXECUTE	= 2'b10,
			  s_WRITE      	= 2'b11,

			  s_UNK		= 2'bxx
			  } control_state_t;

/*
 *	Interrupts enumeration
 */
typedef enum logic [2:0] {
			  int_NONE	= 3'b000,
			  int_VBLANK	= 3'b001,
			  int_LCDC	= 3'b010,
			  int_SERIAL	= 3'b011,
			  int_JOYPAD	= 3'b100,
			  int_TIMER	= 3'b101,

			  int_UNK      	= 3'bxxx
			  } interrupt_state_t;

/*
 *	OP Code enumeration
 */
typedef logic [7:0] op_code_t;

// Standard OP Codes
typedef enum op_code_t {
			NOP 		= 8'h00, LD_BC_N16	= 8'h01, LD_BCA_A 	= 8'h02, INC_BC 	= 8'h03, INC_B 			= 8'h04, DEC_B 		= 8'h05, LD_B_N8 	= 8'h06, RLCA 		= 8'h07,
			LD_N16A_SP	= 8'h08, ADD_HL_BC 	= 8'h09, LD_A_BCA 	= 8'h0A, DEC_BC 	= 8'h0B, INC_C 			= 8'h0C, DEC_C 		= 8'h0D, LD_C_N8 	= 8'h0E, RRCA 		= 8'h0F,
			STOP 		= 8'h10, LD_DE_N16 	= 8'h11, LD_DEA_A 	= 8'h12, INC_DE 	= 8'h13, INC_D 			= 8'h14, DEC_D 		= 8'h15, LD_D_N8 	= 8'h16, RLA 		= 8'h17,
			JR_N8 		= 8'h18, ADD_HL_DE 	= 8'h19, LD_A_DEA 	= 8'h1A, DEC_DE 	= 8'h1B, INC_E 			= 8'h1C, DEC_E 		= 8'h1D, LD_E_N8 	= 8'h1E, RRA 		= 8'h1F,
			JR_NZ_N8 	= 8'h20, LD_HL_N16 	= 8'h21, LD_HLP_A 	= 8'h22, INC_HL 	= 8'h23, INC_H 			= 8'h24, DEC_H 		= 8'h25, LD_H_N8 	= 8'h26, DAA 		= 8'h27,
			JR_Z_N8 	= 8'h28, ADD_HL_HL 	= 8'h29, LD_A_HLP 	= 8'h2A, DEC_HL 	= 8'h2B, INC_L 			= 8'h2C, DEC_L 		= 8'h2D, LD_L_N8 	= 8'h2E, CPL 		= 8'h2F,
			JR_NC_N8 	= 8'h30, LD_SP_N16 	= 8'h31, LD_HLN_A 	= 8'h32, INC_SP 	= 8'h33, INC_HLA		= 8'h34, DEC_HLA	= 8'h35, LD_HLA_N8 	= 8'h36, SCF 		= 8'h37,
			JR_C_N8 	= 8'h38, ADD_HL_SP 	= 8'h39, LD_A_HLN 	= 8'h3A, DEC_SP 	= 8'h3B, INC_A 			= 8'h3C, DEC_A 		= 8'h3D, LD_A_N8 	= 8'h3E, CCF 		= 8'h3F,
			LD_B_B 		= 8'h40, LD_B_C 	= 8'h41, LD_B_D 	= 8'h42, LD_B_E 	= 8'h43, LD_B_H 		= 8'h44, LD_B_L 	= 8'h45, LD_B_HLA 	= 8'h46, LD_B_A 	= 8'h47,
			LD_C_B 		= 8'h48, LD_C_C 	= 8'h49, LD_C_D 	= 8'h4A, LD_C_E 	= 8'h4B, LD_C_H 		= 8'h4C, LD_C_L 	= 8'h4D, LD_C_HLA 	= 8'h4E, LD_C_A 	= 8'h4F,
			LD_D_B 		= 8'h50, LD_D_C 	= 8'h51, LD_D_D	 	= 8'h52, LD_D_E 	= 8'h53, LD_D_H 		= 8'h54, LD_D_L 	= 8'h55, LD_D_HLA 	= 8'h56, LD_D_A 	= 8'h57,
			LD_E_B 		= 8'h58, LD_E_C 	= 8'h59, LD_E_D 	= 8'h5A, LD_E_E 	= 8'h5B, LD_E_H 		= 8'h5C, LD_E_L 	= 8'h5D, LD_E_HLA 	= 8'h5E, LD_E_A 	= 8'h5F,
			LD_H_B 		= 8'h60, LD_H_C 	= 8'h61, LD_H_D 	= 8'h62, LD_H_E 	= 8'h63, LD_H_H 		= 8'h64, LD_H_L 	= 8'h65, LD_H_HLA 	= 8'h66, LD_H_A 	= 8'h67,
			LD_L_B 		= 8'h68, LD_L_C 	= 8'h69, LD_L_D 	= 8'h6A, LD_L_E 	= 8'h6B, LD_L_H 		= 8'h6C, LD_L_L 	= 8'h6D, LD_L_HLA 	= 8'h6E, LD_L_A 	= 8'h6F,
			LD_HLA_B 	= 8'h70, LD_HLA_C 	= 8'h71, LD_HLA_D 	= 8'h72, LD_HLA_E 	= 8'h73, LD_HLA_H 		= 8'h74, LD_HLA_L	= 8'h75, HALT 		= 8'h76, LD_HLA_A 	= 8'h77,
			LD_A_B 		= 8'h78, LD_A_C 	= 8'h79, LD_A_D	 	= 8'h7A, LD_A_E 	= 8'h7B, LD_A_H	 		= 8'h7C, LD_A_L 	= 8'h7D, LD_A_HLA 	= 8'h7E, LD_A_A 	= 8'h7F,
			ADD_A_B 	= 8'h80, ADD_A_C 	= 8'h81, ADD_A_D 	= 8'h82, ADD_A_E 	= 8'h83, ADD_A_H 		= 8'h84, ADD_A_L 	= 8'h85, ADD_A_HLA 	= 8'h86, ADD_A_A	= 8'h87,
			ADC_A_B 	= 8'h88, ADC_A_C 	= 8'h89, ADC_A_D 	= 8'h8A, ADC_A_E 	= 8'h8B, ADC_A_H 		= 8'h8C, ADC_A_L 	= 8'h8D, ADC_A_HLA 	= 8'h8E, ADC_A_A	= 8'h8F,
			SUB_A_B 	= 8'h90, SUB_A_C 	= 8'h91, SUB_A_D 	= 8'h92, SUB_A_E 	= 8'h93, SUB_A_H 		= 8'h94, SUB_A_L 	= 8'h95, SUB_A_HLA 	= 8'h96, SUB_A_A	= 8'h97,
			SBC_A_B	 	= 8'h98, SBC_A_C 	= 8'h99, SBC_A_D 	= 8'h9A, SBC_A_E 	= 8'h9B, SBC_A_H		= 8'h9C, SBC_A_L 	= 8'h9D, SBC_A_HLA 	= 8'h9E, SBC_A_A	= 8'h9F,
			AND_A_B 	= 8'hA0, AND_A_C 	= 8'hA1, AND_A_D 	= 8'hA2, AND_A_E 	= 8'hA3, AND_A_H 		= 8'hA4, AND_A_L 	= 8'hA5, AND_A_HLA 	= 8'hA6, AND_A_A 	= 8'hA7,
			XOR_A_B 	= 8'hA8, XOR_A_C 	= 8'hA9, XOR_A_D 	= 8'hAA, XOR_A_E 	= 8'hAB, XOR_A_H 		= 8'hAC, XOR_A_L 	= 8'hAD, XOR_A_HLA 	= 8'hAE, XOR_A_A 	= 8'hAF,
			OR_A_B 		= 8'hB0, OR_A_C 	= 8'hB1, OR_A_D 	= 8'hB2, OR_A_E 	= 8'hB3, OR_A_H 		= 8'hB4, OR_A_L 	= 8'hB5, OR_A_HLA 	= 8'hB6, OR_A_A 	= 8'hB7,
			CP_A_B 		= 8'hB8, CP_A_C 	= 8'hB9, CP_A_D 	= 8'hBA, CP_A_E 	= 8'hBB, CP_A_H 		= 8'hBC, CP_A_L 	= 8'hBD, CP_A_HLA 	= 8'hBE, CP_A_A 	= 8'hBF,
			RET_NZ 		= 8'hC0, POP_BC 	= 8'hC1, JP_NZ_N16 	= 8'hC2, JP_N16 	= 8'hC3, CALL_NZ_N16	= 8'hC4, PUSH_BC 	= 8'hC5, ADD_A_N8 	= 8'hC6, RST_0		= 8'hC7,
			RET_Z 		= 8'hC8, RET 		= 8'hC9, JP_Z_N16 	= 8'hCA, PREFIX 	= 8'hCB, CALL_Z_N16 	= 8'hCC, CALL_N16 	= 8'hCD, ADC_A_N8 	= 8'hCE, RST_8		= 8'hCF,
			RET_NC 		= 8'hD0, POP_DE 	= 8'hD1, JP_NC_N16	= 8'hD2, UNUSED1 	= 8'hD3, CALL_NC_N16	= 8'hD4, PUSH_DE 	= 8'hD5, SUB_A_N8 	= 8'hD6, RST_10 	= 8'hD7,
			RET_C 		= 8'hD8, RETI 		= 8'hD9, JP_C_N16 	= 8'hDA, UNUSED2 	= 8'hDB, CALL_C_N16 	= 8'hDC, UNUSED3 	= 8'hDD, SBC_A_N8 	= 8'hDE, RST_18 	= 8'hDF,
			LDH_N8A_A 	= 8'hE0, POP_HL 	= 8'hE1, LD_CA_A 	= 8'hE2, UNUSED4 	= 8'hE3, UNUSED5 		= 8'hE4, PUSH_HL 	= 8'hE5, AND_A_N8 	= 8'hE6, RST_20 	= 8'hE7,
			ADD_SP_N8 	= 8'hE8, JP_HLA 	= 8'hE9, LD_N16A_A 	= 8'hEA, UNUSED6 	= 8'hEB, UNUSED7 		= 8'hEC, UNUSED8	= 8'hED, XOR_A_N8 	= 8'hEE, RST_28 	= 8'hEF,
			LDH_A_N8A 	= 8'hF0, POP_AF 	= 8'hF1, LD_A_CA 	= 8'hF2, DI 		= 8'hF3, UNUSED9 		= 8'hF4, PUSH_AF 	= 8'hF5, OR_A_N8 	= 8'hF6, RST_30 	= 8'hF7,
			LD_HL_SPN8 	= 8'hF8, LD_SP_HL 	= 8'hF9, LD_A_N16A 	= 8'hFA, EI 		= 8'hFB, UNUSEDA 		= 8'hFC, UNUSEDB 	= 8'hFD, CP_A_N8 	= 8'hFE, RST_38 	= 8'hFF,

			UNK_OP		= 8'bxxxx_xxxx
			} std_instruction_t;

// CB Prefix OP Codes
typedef enum op_code_t {
			RLC_B 		= 8'h00, RLC_C 		= 8'h01, RLC_D 		= 8'h02, RLC_E 		= 8'h03, RLC_H 			= 8'h04, RLC_L 		= 8'h05, RLC_HLA 	= 8'h06, RLC_A 		= 8'h07,
			RRC_B 		= 8'h08, RRC_C 		= 8'h09, RRC_D 		= 8'h0A, RRC_E		= 8'h0B, RRC_H 			= 8'h0C, RRC_L 		= 8'h0D, RRC_HLA 	= 8'h0E, RRC_A 		= 8'h0F,
			RL_B 		= 8'h10, RL_C 		= 8'h11, RL_D 		= 8'h12, RL_E 		= 8'h13, RL_H 			= 8'h14, RL_L 		= 8'h15, RL_HLA 	= 8'h16, RL_A 		= 8'h17,
			RR_B 		= 8'h18, RR_C 		= 8'h19, RR_D 		= 8'h1A, RR_E 		= 8'h1B, RR_H 			= 8'h1C, RR_L 		= 8'h1D, RR_HLA 	= 8'h1E, RR_A 		= 8'h1F,
			SLA_B 		= 8'h20, SLA_C 		= 8'h21, SLA_D 		= 8'h22, SLA_E 		= 8'h23, SLA_H 			= 8'h24, SLA_L 		= 8'h25, SLA_HLA 	= 8'h26, SLA_A 		= 8'h27,
			SRA_B 		= 8'h28, SRA_C 		= 8'h29, SRA_D 		= 8'h2A, SRA_E 		= 8'h2B, SRA_H 			= 8'h2C, SRA_L 		= 8'h2D, SRA_HLA 	= 8'h2E, SRA_A 		= 8'h2F,
			SWAP_B 		= 8'h30, SWAP_C 	= 8'h31, SWAP_D 	= 8'h32, SWAP_E 	= 8'h33, SWAP_H 		= 8'h34, SWAP_L 	= 8'h35, SWAP_HLA 	= 8'h36, SWAP_A 	= 8'h37,
			SRL_B 		= 8'h38, SRL_C 		= 8'h39, SRL_D 		= 8'h3A, SRL_E 		= 8'h3B, SRL_H 			= 8'h3C, SRL_L 		= 8'h3D, SRL_HLA 	= 8'h3E, SRL_A 		= 8'h3F,
			BIT_0_B 	= 8'h40, BIT_0_C 	= 8'h41, BIT_0_D 	= 8'h42, BIT_0_E 	= 8'h43, BIT_0_H 		= 8'h44, BIT_0_L 	= 8'h45, BIT_0_HLA 	= 8'h46, BIT_0_A 	= 8'h47,
			BIT_1_B 	= 8'h48, BIT_1_C 	= 8'h49, BIT_1_D 	= 8'h4A, BIT_1_E 	= 8'h4B, BIT_1_H 		= 8'h4C, BIT_1_L 	= 8'h4D, BIT_1_HLA 	= 8'h4E, BIT_1_A 	= 8'h4F,
			BIT_2_B 	= 8'h50, BIT_2_C 	= 8'h51, BIT_2_D 	= 8'h52, BIT_2_E 	= 8'h53, BIT_2_H 		= 8'h54, BIT_2_L 	= 8'h55, BIT_2_HLA 	= 8'h56, BIT_2_A 	= 8'h57,
			BIT_3_B 	= 8'h58, BIT_3_C 	= 8'h59, BIT_3_D 	= 8'h5A, BIT_3_E 	= 8'h5B, BIT_3_H 		= 8'h5C, BIT_3_L 	= 8'h5D, BIT_3_HLA 	= 8'h5E, BIT_3_A 	= 8'h5F,
			BIT_4_B 	= 8'h60, BIT_4_C 	= 8'h61, BIT_4_D 	= 8'h62, BIT_4_E 	= 8'h63, BIT_4_H 		= 8'h64, BIT_4_L 	= 8'h65, BIT_4_HLA 	= 8'h66, BIT_4_A 	= 8'h67,
			BIT_5_B 	= 8'h68, BIT_5_C 	= 8'h69, BIT_5_D 	= 8'h6A, BIT_5_E 	= 8'h6B, BIT_5_H 		= 8'h6C, BIT_5_L 	= 8'h6D, BIT_5_HLA 	= 8'h6E, BIT_5_A 	= 8'h6F,
			BIT_6_B 	= 8'h70, BIT_6_C 	= 8'h71, BIT_6_D 	= 8'h72, BIT_6_E 	= 8'h73, BIT_6_H 		= 8'h74, BIT_6_L 	= 8'h75, BIT_6_HLA 	= 8'h76, BIT_6_A 	= 8'h77,
			BIT_7_B 	= 8'h78, BIT_7_C 	= 8'h79, BIT_7_D 	= 8'h7A, BIT_7_E 	= 8'h7B, BIT_7_H 		= 8'h7C, BIT_7_L 	= 8'h7D, BIT_7_HLA 	= 8'h7E, BIT_7_A 	= 8'h7F,
			RES_0_B 	= 8'h80, RES_0_C 	= 8'h81, RES_0_D 	= 8'h82, RES_0_E 	= 8'h83, RES_0_H 		= 8'h84, RES_0_L 	= 8'h85, RES_0_HLA 	= 8'h86, RES_0_A 	= 8'h87,
			RES_1_B 	= 8'h88, RES_1_C 	= 8'h89, RES_1_D 	= 8'h8A, RES_1_E 	= 8'h8B, RES_1_H 		= 8'h8C, RES_1_L 	= 8'h8D, RES_1_HLA 	= 8'h8E, RES_1_A 	= 8'h8F,
			RES_2_B 	= 8'h90, RES_2_C 	= 8'h91, RES_2_D 	= 8'h92, RES_2_E 	= 8'h93, RES_2_H 		= 8'h94, RES_2_L 	= 8'h95, RES_2_HLA 	= 8'h96, RES_2_A 	= 8'h97,
			RES_3_B 	= 8'h98, RES_3_C 	= 8'h99, RES_3_D 	= 8'h9A, RES_3_E 	= 8'h9B, RES_3_H 		= 8'h9C, RES_3_L 	= 8'h9D, RES_3_HLA 	= 8'h9E, RES_3_A 	= 8'h9F,
			RES_4_B 	= 8'hA0, RES_4_C 	= 8'hA1, RES_4_D 	= 8'hA2, RES_4_E 	= 8'hA3, RES_4_H 		= 8'hA4, RES_4_L 	= 8'hA5, RES_4_HLA 	= 8'hA6, RES_4_A 	= 8'hA7,
			RES_5_B 	= 8'hA8, RES_5_C 	= 8'hA9, RES_5_D 	= 8'hAA, RES_5_E 	= 8'hAB, RES_5_H 		= 8'hAC, RES_5_L 	= 8'hAD, RES_5_HLA 	= 8'hAE, RES_5_A 	= 8'hAF,
			RES_6_B 	= 8'hB0, RES_6_C 	= 8'hB1, RES_6_D 	= 8'hB2, RES_6_E 	= 8'hB3, RES_6_H 		= 8'hB4, RES_6_L 	= 8'hB5, RES_6_HLA 	= 8'hB6, RES_6_A 	= 8'hB7,
			RES_7_B 	= 8'hB8, RES_7_C 	= 8'hB9, RES_7_D 	= 8'hBA, RES_7_E 	= 8'hBB, RES_7_H 		= 8'hBC, RES_7_L 	= 8'hBD, RES_7_HLA 	= 8'hBE, RES_7_A 	= 8'hBF,
			SET_0_B 	= 8'hC0, SET_0_C 	= 8'hC1, SET_0_D 	= 8'hC2, SET_0_E 	= 8'hC3, SET_0_H 		= 8'hC4, SET_0_L 	= 8'hC5, SET_0_HLA 	= 8'hC6, SET_0_A 	= 8'hC7,
			SET_1_B 	= 8'hC8, SET_1_C 	= 8'hC9, SET_1_D 	= 8'hCA, SET_1_E 	= 8'hCB, SET_1_H 		= 8'hCC, SET_1_L 	= 8'hCD, SET_1_HLA 	= 8'hCE, SET_1_A 	= 8'hCF,
			SET_2_B 	= 8'hD0, SET_2_C 	= 8'hD1, SET_2_D 	= 8'hD2, SET_2_E 	= 8'hD3, SET_2_H 		= 8'hD4, SET_2_L 	= 8'hD5, SET_2_HLA 	= 8'hD6, SET_2_A 	= 8'hD7,
			SET_3_B 	= 8'hD8, SET_3_C 	= 8'hD9, SET_3_D 	= 8'hDA, SET_3_E 	= 8'hDB, SET_3_H 		= 8'hDC, SET_3_L 	= 8'hDD, SET_3_HLA 	= 8'hDE, SET_3_A 	= 8'hDF,
			SET_4_B 	= 8'hE0, SET_4_C 	= 8'hE1, SET_4_D 	= 8'hE2, SET_4_E 	= 8'hE3, SET_4_H 		= 8'hE4, SET_4_L 	= 8'hE5, SET_4_HLA 	= 8'hE6, SET_4_A 	= 8'hE7,
			SET_5_B 	= 8'hE8, SET_5_C 	= 8'hE9, SET_5_D 	= 8'hEA, SET_5_E 	= 8'hEB, SET_5_H 		= 8'hEC, SET_5_L 	= 8'hED, SET_5_HLA 	= 8'hEE, SET_5_A 	= 8'hEF,
			SET_6_B 	= 8'hF0, SET_6_C 	= 8'hF1, SET_6_D 	= 8'hF2, SET_6_E 	= 8'hF3, SET_6_H 		= 8'hF4, SET_6_L 	= 8'hF5, SET_6_HLA 	= 8'hF6, SET_6_A 	= 8'hF7,
			SET_7_B 	= 8'hF8, SET_7_C 	= 8'hF9, SET_7_D 	= 8'hFA, SET_7_E 	= 8'hFB, SET_7_H 		= 8'hFC, SET_7_L 	= 8'hFD, SET_7_HLA 	= 8'hFE, SET_7_A 	= 8'hFF,

			UNK_OP_SP = 8'bxxxx_xxxx
			} cb_instruction_t;

/*
 *	Micro-code for i2c
 */
typedef enum logic [2:0] {
			  i2c_NOP      	= 3'b000,
			  i2c_START	= 3'b001,
			  i2c_STOP	= 3'b010,
			  i2c_READ	= 3'b011,
			  i2c_WRITE	= 3'b100,

			  i2c_HALT	= 3'b111,
			  i2c_UNK      	= 3'bxxx
			  } i2c_micro_instruc_t;

/*
 *	Controlpath control code output for Datapath
 */
typedef struct packed {
		       reg_sel_t	reg_selA;
		       reg_sel_t	reg_selB;
		       alu_op_t 	alu_op;
		       alu_src_t 	alu_srcA;
		       alu_src_t 	alu_srcB;
		       dest_t 		alu_dest;
		       logic [2:0]	bit_num;
		       logic		fetch;
		       logic		load_op_code;
		       logic 		read_en;
		       logic 		write_en;
		       logic		ld_flags;
		       } control_code_t;

/*
 *	Control/IO register read/write window
 */
typedef struct packed {
		       reg [7:0]		joypad;
		       reg [7:0]		serial_data;
		       reg [7:0]		serial_control;
		       reg [7:0]		timer_divide;
		       reg [7:0]		timer_count;
		       reg [7:0]		timer_modulo;
		       reg [7:0]		timer_control;
		       reg [7:0]		interrupt_st;
		       
		       /* TODO SOUND */
		       
		       reg [7:0]		lcd_control;
		       reg [7:0]		lcd_status;
		       reg [7:0]		scroll_y;
		       reg [7:0]		scroll_x;
		       reg [7:0]		lcd_v;
		       reg [7:0]		lcd_v_cp;
		       reg [7:0]		dma;
		       reg [7:0]		bg_pal;
		       reg [7:0]		obj_pal0;
		       reg [7:0]		obj_pal1;
		       reg [7:0]		win_y;
		       reg [7:0]		win_x;
		       reg	       		dmg_disable;
		       reg [7:0]		interrupt_en;
		       } control_reg_t;

typedef enum logic [4:0] {
			  s_WAIT       		= 5'b00_000, 

			  // OAM SEARCH
			  s_OAM_LD_ADDR		= 5'b00_001,
			  s_OAM_READ_BLK       	= 5'b00_010,
			  s_OAM_INSPECT_BLK	= 5'b00_011,
			  s_OAM_BUFF_BLK       	= 5'b00_100,

			  // BACKGROUND RENDER
			  s_BACK_LD_ADDR       	= 5'b00_101, 
			  s_BACK_READ_INDEX	= 5'b00_110, 
			  s_BACK_LD_INDEX 	= 5'b00_111, 
			  s_BACK_READ_PIXELS 	= 5'b01_000, 
			  s_BACK_LD_PIXELS1 	= 5'b01_001, 
			  s_BACK_LD_PIXELS2 	= 5'b01_010

			  // WINDOW RENDER

			  // SPRITE RENDER
			  } draw_state_t;

typedef enum logic [2:0] {
			  s_DMA_WAIT	       	= 3'b000,
			  s_DMA_ADDRESS_INIT	= 3'b001,
			  s_DMA_ADDRESS_READ	= 3'b010,
			  s_DMA_DATA_READ      	= 3'b011,
			  s_DMA_ADDRESS_WRITE	= 3'b100,
			  s_DMA_DATA_WRITE	= 3'b101

			  } dma_state_t;

`endif