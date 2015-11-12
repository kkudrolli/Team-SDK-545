`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2015 12:04:15 PM
// Design Name: 
// Module Name: weight
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


module weights(input clka, rst,
              input start_0, start_1,
              output logic [127:0] [31:0] values_0,
              output logic [9:0] [31:0] values_1);
    
    logic [9:0] addra_0;
    logic [6:0] addra_1;
    logic [0:0] wea_0, wea_1;
    
    logic processing_0, processingPrev_0, processing_1, processingPrev_1;
    logic [9:0] counter_0;
    logic [7:0] counter_1;
    
    logic [127:0] [31:0] douta_0;
    logic [127:0] [31:0] dina_0;

    logic [9:0] [31:0] dina_1;
    logic [9:0] [31:0] douta_1;

    weights_layer_0_wrapper l0(
        .BRAM_PORTA_addr(addra_0),
        .BRAM_PORTA_clk(clka),
        .BRAM_PORTA_din(0),
        .BRAM_PORTA_dout(douta_0[0]),
        .BRAM_PORTA_we(0),
        .BRAM_PORTA_1_addr(addra_0),
        .BRAM_PORTA_1_clk(clka),
        .BRAM_PORTA_1_din(0),
        .BRAM_PORTA_1_dout(douta_0[1]),
        .BRAM_PORTA_1_we(0),
        .BRAM_PORTA_2_addr(addra_0),
        .BRAM_PORTA_2_clk(clka),
        .BRAM_PORTA_2_din(0),
        .BRAM_PORTA_2_dout(douta_0[2]),
        .BRAM_PORTA_2_we(0),
        .BRAM_PORTA_3_addr(addra_0),
        .BRAM_PORTA_3_clk(clka),
        .BRAM_PORTA_3_din(0),
        .BRAM_PORTA_3_dout(douta_0[3]),
        .BRAM_PORTA_3_we(0),
        .BRAM_PORTA_4_addr(addra_0),
        .BRAM_PORTA_4_clk(clka),
        .BRAM_PORTA_4_din(0),
        .BRAM_PORTA_4_dout(douta_0[4]),
        .BRAM_PORTA_4_we(0),
        .BRAM_PORTA_5_addr(addra_0),
        .BRAM_PORTA_5_clk(clka),
        .BRAM_PORTA_5_din(0),
        .BRAM_PORTA_5_dout(douta_0[5]),
        .BRAM_PORTA_5_we(0),
        .BRAM_PORTA_6_addr(addra_0),
        .BRAM_PORTA_6_clk(clka),
        .BRAM_PORTA_6_din(0),
        .BRAM_PORTA_6_dout(douta_0[6]),
        .BRAM_PORTA_6_we(0),
        .BRAM_PORTA_7_addr(addra_0),
        .BRAM_PORTA_7_clk(clka),
        .BRAM_PORTA_7_din(0),
        .BRAM_PORTA_7_dout(douta_0[7]),
        .BRAM_PORTA_7_we(0),
        .BRAM_PORTA_8_addr(addra_0),
        .BRAM_PORTA_8_clk(clka),
        .BRAM_PORTA_8_din(0),
        .BRAM_PORTA_8_dout(douta_0[8]),
        .BRAM_PORTA_8_we(0),
        .BRAM_PORTA_9_addr(addra_0),
        .BRAM_PORTA_9_clk(clka),
        .BRAM_PORTA_9_din(0),
        .BRAM_PORTA_9_dout(douta_0[9]),
        .BRAM_PORTA_9_we(0),
        .BRAM_PORTA_10_addr(addra_0),
        .BRAM_PORTA_10_clk(clka),
        .BRAM_PORTA_10_din(0),
        .BRAM_PORTA_10_dout(douta_0[10]),
        .BRAM_PORTA_10_we(0),
        .BRAM_PORTA_11_addr(addra_0),
        .BRAM_PORTA_11_clk(clka),
        .BRAM_PORTA_11_din(0),
        .BRAM_PORTA_11_dout(douta_0[11]),
        .BRAM_PORTA_11_we(0),
        .BRAM_PORTA_12_addr(addra_0),
        .BRAM_PORTA_12_clk(clka),
        .BRAM_PORTA_12_din(0),
        .BRAM_PORTA_12_dout(douta_0[12]),
        .BRAM_PORTA_12_we(0),
        .BRAM_PORTA_13_addr(addra_0),
        .BRAM_PORTA_13_clk(clka),
        .BRAM_PORTA_13_din(0),
        .BRAM_PORTA_13_dout(douta_0[13]),
        .BRAM_PORTA_13_we(0),
        .BRAM_PORTA_14_addr(addra_0),
        .BRAM_PORTA_14_clk(clka),
        .BRAM_PORTA_14_din(0),
        .BRAM_PORTA_14_dout(douta_0[14]),
        .BRAM_PORTA_14_we(0),
        .BRAM_PORTA_15_addr(addra_0),
        .BRAM_PORTA_15_clk(clka),
        .BRAM_PORTA_15_din(0),
        .BRAM_PORTA_15_dout(douta_0[15]),
        .BRAM_PORTA_15_we(0),
        .BRAM_PORTA_16_addr(addra_0),
        .BRAM_PORTA_16_clk(clka),
        .BRAM_PORTA_16_din(0),
        .BRAM_PORTA_16_dout(douta_0[16]),
        .BRAM_PORTA_16_we(0),
        .BRAM_PORTA_17_addr(addra_0),
        .BRAM_PORTA_17_clk(clka),
        .BRAM_PORTA_17_din(0),
        .BRAM_PORTA_17_dout(douta_0[17]),
        .BRAM_PORTA_17_we(0),
        .BRAM_PORTA_18_addr(addra_0),
        .BRAM_PORTA_18_clk(clka),
        .BRAM_PORTA_18_din(0),
        .BRAM_PORTA_18_dout(douta_0[18]),
        .BRAM_PORTA_18_we(0),
        .BRAM_PORTA_19_addr(addra_0),
        .BRAM_PORTA_19_clk(clka),
        .BRAM_PORTA_19_din(0),
        .BRAM_PORTA_19_dout(douta_0[19]),
        .BRAM_PORTA_19_we(0),
        .BRAM_PORTA_20_addr(addra_0),
        .BRAM_PORTA_20_clk(clka),
        .BRAM_PORTA_20_din(0),
        .BRAM_PORTA_20_dout(douta_0[20]),
        .BRAM_PORTA_20_we(0),
        .BRAM_PORTA_21_addr(addra_0),
        .BRAM_PORTA_21_clk(clka),
        .BRAM_PORTA_21_din(0),
        .BRAM_PORTA_21_dout(douta_0[21]),
        .BRAM_PORTA_21_we(0),
        .BRAM_PORTA_22_addr(addra_0),
        .BRAM_PORTA_22_clk(clka),
        .BRAM_PORTA_22_din(0),
        .BRAM_PORTA_22_dout(douta_0[22]),
        .BRAM_PORTA_22_we(0),
        .BRAM_PORTA_23_addr(addra_0),
        .BRAM_PORTA_23_clk(clka),
        .BRAM_PORTA_23_din(0),
        .BRAM_PORTA_23_dout(douta_0[23]),
        .BRAM_PORTA_23_we(0),
        .BRAM_PORTA_24_addr(addra_0),
        .BRAM_PORTA_24_clk(clka),
        .BRAM_PORTA_24_din(0),
        .BRAM_PORTA_24_dout(douta_0[24]),
        .BRAM_PORTA_24_we(0),
        .BRAM_PORTA_25_addr(addra_0),
        .BRAM_PORTA_25_clk(clka),
        .BRAM_PORTA_25_din(0),
        .BRAM_PORTA_25_dout(douta_0[25]),
        .BRAM_PORTA_25_we(0),
        .BRAM_PORTA_26_addr(addra_0),
        .BRAM_PORTA_26_clk(clka),
        .BRAM_PORTA_26_din(0),
        .BRAM_PORTA_26_dout(douta_0[26]),
        .BRAM_PORTA_26_we(0),
        .BRAM_PORTA_27_addr(addra_0),
        .BRAM_PORTA_27_clk(clka),
        .BRAM_PORTA_27_din(0),
        .BRAM_PORTA_27_dout(douta_0[27]),
        .BRAM_PORTA_27_we(0),
        .BRAM_PORTA_28_addr(addra_0),
        .BRAM_PORTA_28_clk(clka),
        .BRAM_PORTA_28_din(0),
        .BRAM_PORTA_28_dout(douta_0[28]),
        .BRAM_PORTA_28_we(0),
        .BRAM_PORTA_29_addr(addra_0),
        .BRAM_PORTA_29_clk(clka),
        .BRAM_PORTA_29_din(0),
        .BRAM_PORTA_29_dout(douta_0[29]),
        .BRAM_PORTA_29_we(0),
        .BRAM_PORTA_30_addr(addra_0),
        .BRAM_PORTA_30_clk(clka),
        .BRAM_PORTA_30_din(0),
        .BRAM_PORTA_30_dout(douta_0[30]),
        .BRAM_PORTA_30_we(0),
        .BRAM_PORTA_31_addr(addra_0),
        .BRAM_PORTA_31_clk(clka),
        .BRAM_PORTA_31_din(0),
        .BRAM_PORTA_31_dout(douta_0[31]),
        .BRAM_PORTA_31_we(0),
        .BRAM_PORTA_32_addr(addra_0),
        .BRAM_PORTA_32_clk(clka),
        .BRAM_PORTA_32_din(0),
        .BRAM_PORTA_32_dout(douta_0[32]),
        .BRAM_PORTA_32_we(0),
        .BRAM_PORTA_33_addr(addra_0),
        .BRAM_PORTA_33_clk(clka),
        .BRAM_PORTA_33_din(0),
        .BRAM_PORTA_33_dout(douta_0[33]),
        .BRAM_PORTA_33_we(0),
        .BRAM_PORTA_34_addr(addra_0),
        .BRAM_PORTA_34_clk(clka),
        .BRAM_PORTA_34_din(0),
        .BRAM_PORTA_34_dout(douta_0[34]),
        .BRAM_PORTA_34_we(0),
        .BRAM_PORTA_35_addr(addra_0),
        .BRAM_PORTA_35_clk(clka),
        .BRAM_PORTA_35_din(0),
        .BRAM_PORTA_35_dout(douta_0[35]),
        .BRAM_PORTA_35_we(0),
        .BRAM_PORTA_36_addr(addra_0),
        .BRAM_PORTA_36_clk(clka),
        .BRAM_PORTA_36_din(0),
        .BRAM_PORTA_36_dout(douta_0[36]),
        .BRAM_PORTA_36_we(0),
        .BRAM_PORTA_37_addr(addra_0),
        .BRAM_PORTA_37_clk(clka),
        .BRAM_PORTA_37_din(0),
        .BRAM_PORTA_37_dout(douta_0[37]),
        .BRAM_PORTA_37_we(0),
        .BRAM_PORTA_38_addr(addra_0),
        .BRAM_PORTA_38_clk(clka),
        .BRAM_PORTA_38_din(0),
        .BRAM_PORTA_38_dout(douta_0[38]),
        .BRAM_PORTA_38_we(0),
        .BRAM_PORTA_39_addr(addra_0),
        .BRAM_PORTA_39_clk(clka),
        .BRAM_PORTA_39_din(0),
        .BRAM_PORTA_39_dout(douta_0[39]),
        .BRAM_PORTA_39_we(0),
        .BRAM_PORTA_40_addr(addra_0),
        .BRAM_PORTA_40_clk(clka),
        .BRAM_PORTA_40_din(0),
        .BRAM_PORTA_40_dout(douta_0[40]),
        .BRAM_PORTA_40_we(0),
        .BRAM_PORTA_41_addr(addra_0),
        .BRAM_PORTA_41_clk(clka),
        .BRAM_PORTA_41_din(0),
        .BRAM_PORTA_41_dout(douta_0[41]),
        .BRAM_PORTA_41_we(0),
        .BRAM_PORTA_42_addr(addra_0),
        .BRAM_PORTA_42_clk(clka),
        .BRAM_PORTA_42_din(0),
        .BRAM_PORTA_42_dout(douta_0[42]),
        .BRAM_PORTA_42_we(0),
        .BRAM_PORTA_43_addr(addra_0),
        .BRAM_PORTA_43_clk(clka),
        .BRAM_PORTA_43_din(0),
        .BRAM_PORTA_43_dout(douta_0[43]),
        .BRAM_PORTA_43_we(0),
        .BRAM_PORTA_44_addr(addra_0),
        .BRAM_PORTA_44_clk(clka),
        .BRAM_PORTA_44_din(0),
        .BRAM_PORTA_44_dout(douta_0[44]),
        .BRAM_PORTA_44_we(0),
        .BRAM_PORTA_45_addr(addra_0),
        .BRAM_PORTA_45_clk(clka),
        .BRAM_PORTA_45_din(0),
        .BRAM_PORTA_45_dout(douta_0[45]),
        .BRAM_PORTA_45_we(0),
        .BRAM_PORTA_46_addr(addra_0),
        .BRAM_PORTA_46_clk(clka),
        .BRAM_PORTA_46_din(0),
        .BRAM_PORTA_46_dout(douta_0[46]),
        .BRAM_PORTA_46_we(0),
        .BRAM_PORTA_47_addr(addra_0),
        .BRAM_PORTA_47_clk(clka),
        .BRAM_PORTA_47_din(0),
        .BRAM_PORTA_47_dout(douta_0[47]),
        .BRAM_PORTA_47_we(0),
        .BRAM_PORTA_48_addr(addra_0),
        .BRAM_PORTA_48_clk(clka),
        .BRAM_PORTA_48_din(0),
        .BRAM_PORTA_48_dout(douta_0[48]),
        .BRAM_PORTA_48_we(0),
        .BRAM_PORTA_49_addr(addra_0),
        .BRAM_PORTA_49_clk(clka),
        .BRAM_PORTA_49_din(0),
        .BRAM_PORTA_49_dout(douta_0[49]),
        .BRAM_PORTA_49_we(0),
        .BRAM_PORTA_50_addr(addra_0),
        .BRAM_PORTA_50_clk(clka),
        .BRAM_PORTA_50_din(0),
        .BRAM_PORTA_50_dout(douta_0[50]),
        .BRAM_PORTA_50_we(0),
        .BRAM_PORTA_51_addr(addra_0),
        .BRAM_PORTA_51_clk(clka),
        .BRAM_PORTA_51_din(0),
        .BRAM_PORTA_51_dout(douta_0[51]),
        .BRAM_PORTA_51_we(0),
        .BRAM_PORTA_52_addr(addra_0),
        .BRAM_PORTA_52_clk(clka),
        .BRAM_PORTA_52_din(0),
        .BRAM_PORTA_52_dout(douta_0[52]),
        .BRAM_PORTA_52_we(0),
        .BRAM_PORTA_53_addr(addra_0),
        .BRAM_PORTA_53_clk(clka),
        .BRAM_PORTA_53_din(0),
        .BRAM_PORTA_53_dout(douta_0[53]),
        .BRAM_PORTA_53_we(0),
        .BRAM_PORTA_54_addr(addra_0),
        .BRAM_PORTA_54_clk(clka),
        .BRAM_PORTA_54_din(0),
        .BRAM_PORTA_54_dout(douta_0[54]),
        .BRAM_PORTA_54_we(0),
        .BRAM_PORTA_55_addr(addra_0),
        .BRAM_PORTA_55_clk(clka),
        .BRAM_PORTA_55_din(0),
        .BRAM_PORTA_55_dout(douta_0[55]),
        .BRAM_PORTA_55_we(0),
        .BRAM_PORTA_56_addr(addra_0),
        .BRAM_PORTA_56_clk(clka),
        .BRAM_PORTA_56_din(0),
        .BRAM_PORTA_56_dout(douta_0[56]),
        .BRAM_PORTA_56_we(0),
        .BRAM_PORTA_57_addr(addra_0),
        .BRAM_PORTA_57_clk(clka),
        .BRAM_PORTA_57_din(0),
        .BRAM_PORTA_57_dout(douta_0[57]),
        .BRAM_PORTA_57_we(0),
        .BRAM_PORTA_58_addr(addra_0),
        .BRAM_PORTA_58_clk(clka),
        .BRAM_PORTA_58_din(0),
        .BRAM_PORTA_58_dout(douta_0[58]),
        .BRAM_PORTA_58_we(0),
        .BRAM_PORTA_59_addr(addra_0),
        .BRAM_PORTA_59_clk(clka),
        .BRAM_PORTA_59_din(0),
        .BRAM_PORTA_59_dout(douta_0[59]),
        .BRAM_PORTA_59_we(0),
        .BRAM_PORTA_60_addr(addra_0),
        .BRAM_PORTA_60_clk(clka),
        .BRAM_PORTA_60_din(0),
        .BRAM_PORTA_60_dout(douta_0[60]),
        .BRAM_PORTA_60_we(0),
        .BRAM_PORTA_61_addr(addra_0),
        .BRAM_PORTA_61_clk(clka),
        .BRAM_PORTA_61_din(0),
        .BRAM_PORTA_61_dout(douta_0[61]),
        .BRAM_PORTA_61_we(0),
        .BRAM_PORTA_62_addr(addra_0),
        .BRAM_PORTA_62_clk(clka),
        .BRAM_PORTA_62_din(0),
        .BRAM_PORTA_62_dout(douta_0[62]),
        .BRAM_PORTA_62_we(0),
        .BRAM_PORTA_63_addr(addra_0),
        .BRAM_PORTA_63_clk(clka),
        .BRAM_PORTA_63_din(0),
        .BRAM_PORTA_63_dout(douta_0[63]),
        .BRAM_PORTA_63_we(0),
        .BRAM_PORTA_64_addr(addra_0),
        .BRAM_PORTA_64_clk(clka),
        .BRAM_PORTA_64_din(0),
        .BRAM_PORTA_64_dout(douta_0[64]),
        .BRAM_PORTA_64_we(0),
        .BRAM_PORTA_65_addr(addra_0),
        .BRAM_PORTA_65_clk(clka),
        .BRAM_PORTA_65_din(0),
        .BRAM_PORTA_65_dout(douta_0[65]),
        .BRAM_PORTA_65_we(0),
        .BRAM_PORTA_66_addr(addra_0),
        .BRAM_PORTA_66_clk(clka),
        .BRAM_PORTA_66_din(0),
        .BRAM_PORTA_66_dout(douta_0[66]),
        .BRAM_PORTA_66_we(0),
        .BRAM_PORTA_67_addr(addra_0),
        .BRAM_PORTA_67_clk(clka),
        .BRAM_PORTA_67_din(0),
        .BRAM_PORTA_67_dout(douta_0[67]),
        .BRAM_PORTA_67_we(0),
        .BRAM_PORTA_68_addr(addra_0),
        .BRAM_PORTA_68_clk(clka),
        .BRAM_PORTA_68_din(0),
        .BRAM_PORTA_68_dout(douta_0[68]),
        .BRAM_PORTA_68_we(0),
        .BRAM_PORTA_69_addr(addra_0),
        .BRAM_PORTA_69_clk(clka),
        .BRAM_PORTA_69_din(0),
        .BRAM_PORTA_69_dout(douta_0[69]),
        .BRAM_PORTA_69_we(0),
        .BRAM_PORTA_70_addr(addra_0),
        .BRAM_PORTA_70_clk(clka),
        .BRAM_PORTA_70_din(0),
        .BRAM_PORTA_70_dout(douta_0[70]),
        .BRAM_PORTA_70_we(0),
        .BRAM_PORTA_71_addr(addra_0),
        .BRAM_PORTA_71_clk(clka),
        .BRAM_PORTA_71_din(0),
        .BRAM_PORTA_71_dout(douta_0[71]),
        .BRAM_PORTA_71_we(0),
        .BRAM_PORTA_72_addr(addra_0),
        .BRAM_PORTA_72_clk(clka),
        .BRAM_PORTA_72_din(0),
        .BRAM_PORTA_72_dout(douta_0[72]),
        .BRAM_PORTA_72_we(0),
        .BRAM_PORTA_73_addr(addra_0),
        .BRAM_PORTA_73_clk(clka),
        .BRAM_PORTA_73_din(0),
        .BRAM_PORTA_73_dout(douta_0[73]),
        .BRAM_PORTA_73_we(0),
        .BRAM_PORTA_74_addr(addra_0),
        .BRAM_PORTA_74_clk(clka),
        .BRAM_PORTA_74_din(0),
        .BRAM_PORTA_74_dout(douta_0[74]),
        .BRAM_PORTA_74_we(0),
        .BRAM_PORTA_75_addr(addra_0),
        .BRAM_PORTA_75_clk(clka),
        .BRAM_PORTA_75_din(0),
        .BRAM_PORTA_75_dout(douta_0[75]),
        .BRAM_PORTA_75_we(0),
        .BRAM_PORTA_76_addr(addra_0),
        .BRAM_PORTA_76_clk(clka),
        .BRAM_PORTA_76_din(0),
        .BRAM_PORTA_76_dout(douta_0[76]),
        .BRAM_PORTA_76_we(0),
        .BRAM_PORTA_77_addr(addra_0),
        .BRAM_PORTA_77_clk(clka),
        .BRAM_PORTA_77_din(0),
        .BRAM_PORTA_77_dout(douta_0[77]),
        .BRAM_PORTA_77_we(0),
        .BRAM_PORTA_78_addr(addra_0),
        .BRAM_PORTA_78_clk(clka),
        .BRAM_PORTA_78_din(0),
        .BRAM_PORTA_78_dout(douta_0[78]),
        .BRAM_PORTA_78_we(0),
        .BRAM_PORTA_79_addr(addra_0),
        .BRAM_PORTA_79_clk(clka),
        .BRAM_PORTA_79_din(0),
        .BRAM_PORTA_79_dout(douta_0[79]),
        .BRAM_PORTA_79_we(0),
        .BRAM_PORTA_80_addr(addra_0),
        .BRAM_PORTA_80_clk(clka),
        .BRAM_PORTA_80_din(0),
        .BRAM_PORTA_80_dout(douta_0[80]),
        .BRAM_PORTA_80_we(0),
        .BRAM_PORTA_81_addr(addra_0),
        .BRAM_PORTA_81_clk(clka),
        .BRAM_PORTA_81_din(0),
        .BRAM_PORTA_81_dout(douta_0[81]),
        .BRAM_PORTA_81_we(0),
        .BRAM_PORTA_82_addr(addra_0),
        .BRAM_PORTA_82_clk(clka),
        .BRAM_PORTA_82_din(0),
        .BRAM_PORTA_82_dout(douta_0[82]),
        .BRAM_PORTA_82_we(0),
        .BRAM_PORTA_83_addr(addra_0),
        .BRAM_PORTA_83_clk(clka),
        .BRAM_PORTA_83_din(0),
        .BRAM_PORTA_83_dout(douta_0[83]),
        .BRAM_PORTA_83_we(0),
        .BRAM_PORTA_84_addr(addra_0),
        .BRAM_PORTA_84_clk(clka),
        .BRAM_PORTA_84_din(0),
        .BRAM_PORTA_84_dout(douta_0[84]),
        .BRAM_PORTA_84_we(0),
        .BRAM_PORTA_85_addr(addra_0),
        .BRAM_PORTA_85_clk(clka),
        .BRAM_PORTA_85_din(0),
        .BRAM_PORTA_85_dout(douta_0[85]),
        .BRAM_PORTA_85_we(0),
        .BRAM_PORTA_86_addr(addra_0),
        .BRAM_PORTA_86_clk(clka),
        .BRAM_PORTA_86_din(0),
        .BRAM_PORTA_86_dout(douta_0[86]),
        .BRAM_PORTA_86_we(0),
        .BRAM_PORTA_87_addr(addra_0),
        .BRAM_PORTA_87_clk(clka),
        .BRAM_PORTA_87_din(0),
        .BRAM_PORTA_87_dout(douta_0[87]),
        .BRAM_PORTA_87_we(0),
        .BRAM_PORTA_88_addr(addra_0),
        .BRAM_PORTA_88_clk(clka),
        .BRAM_PORTA_88_din(0),
        .BRAM_PORTA_88_dout(douta_0[88]),
        .BRAM_PORTA_88_we(0),
        .BRAM_PORTA_89_addr(addra_0),
        .BRAM_PORTA_89_clk(clka),
        .BRAM_PORTA_89_din(0),
        .BRAM_PORTA_89_dout(douta_0[89]),
        .BRAM_PORTA_89_we(0),
        .BRAM_PORTA_90_addr(addra_0),
        .BRAM_PORTA_90_clk(clka),
        .BRAM_PORTA_90_din(0),
        .BRAM_PORTA_90_dout(douta_0[90]),
        .BRAM_PORTA_90_we(0),
        .BRAM_PORTA_91_addr(addra_0),
        .BRAM_PORTA_91_clk(clka),
        .BRAM_PORTA_91_din(0),
        .BRAM_PORTA_91_dout(douta_0[91]),
        .BRAM_PORTA_91_we(0),
        .BRAM_PORTA_92_addr(addra_0),
        .BRAM_PORTA_92_clk(clka),
        .BRAM_PORTA_92_din(0),
        .BRAM_PORTA_92_dout(douta_0[92]),
        .BRAM_PORTA_92_we(0),
        .BRAM_PORTA_93_addr(addra_0),
        .BRAM_PORTA_93_clk(clka),
        .BRAM_PORTA_93_din(0),
        .BRAM_PORTA_93_dout(douta_0[93]),
        .BRAM_PORTA_93_we(0),
        .BRAM_PORTA_94_addr(addra_0),
        .BRAM_PORTA_94_clk(clka),
        .BRAM_PORTA_94_din(0),
        .BRAM_PORTA_94_dout(douta_0[94]),
        .BRAM_PORTA_94_we(0),
        .BRAM_PORTA_95_addr(addra_0),
        .BRAM_PORTA_95_clk(clka),
        .BRAM_PORTA_95_din(0),
        .BRAM_PORTA_95_dout(douta_0[95]),
        .BRAM_PORTA_95_we(0),
        .BRAM_PORTA_96_addr(addra_0),
        .BRAM_PORTA_96_clk(clka),
        .BRAM_PORTA_96_din(0),
        .BRAM_PORTA_96_dout(douta_0[96]),
        .BRAM_PORTA_96_we(0),
        .BRAM_PORTA_97_addr(addra_0),
        .BRAM_PORTA_97_clk(clka),
        .BRAM_PORTA_97_din(0),
        .BRAM_PORTA_97_dout(douta_0[97]),
        .BRAM_PORTA_97_we(0),
        .BRAM_PORTA_98_addr(addra_0),
        .BRAM_PORTA_98_clk(clka),
        .BRAM_PORTA_98_din(0),
        .BRAM_PORTA_98_dout(douta_0[98]),
        .BRAM_PORTA_98_we(0),
        .BRAM_PORTA_99_addr(addra_0),
        .BRAM_PORTA_99_clk(clka),
        .BRAM_PORTA_99_din(0),
        .BRAM_PORTA_99_dout(douta_0[99]),
        .BRAM_PORTA_99_we(0),
        .BRAM_PORTA_100_addr(addra_0),
        .BRAM_PORTA_100_clk(clka),
        .BRAM_PORTA_100_din(0),
        .BRAM_PORTA_100_dout(douta_0[100]),
        .BRAM_PORTA_100_we(0),
        .BRAM_PORTA_101_addr(addra_0),
        .BRAM_PORTA_101_clk(clka),
        .BRAM_PORTA_101_din(0),
        .BRAM_PORTA_101_dout(douta_0[101]),
        .BRAM_PORTA_101_we(0),
        .BRAM_PORTA_102_addr(addra_0),
        .BRAM_PORTA_102_clk(clka),
        .BRAM_PORTA_102_din(0),
        .BRAM_PORTA_102_dout(douta_0[102]),
        .BRAM_PORTA_102_we(0),
        .BRAM_PORTA_103_addr(addra_0),
        .BRAM_PORTA_103_clk(clka),
        .BRAM_PORTA_103_din(0),
        .BRAM_PORTA_103_dout(douta_0[103]),
        .BRAM_PORTA_103_we(0),
        .BRAM_PORTA_104_addr(addra_0),
        .BRAM_PORTA_104_clk(clka),
        .BRAM_PORTA_104_din(0),
        .BRAM_PORTA_104_dout(douta_0[104]),
        .BRAM_PORTA_104_we(0),
        .BRAM_PORTA_105_addr(addra_0),
        .BRAM_PORTA_105_clk(clka),
        .BRAM_PORTA_105_din(0),
        .BRAM_PORTA_105_dout(douta_0[105]),
        .BRAM_PORTA_105_we(0),
        .BRAM_PORTA_106_addr(addra_0),
        .BRAM_PORTA_106_clk(clka),
        .BRAM_PORTA_106_din(0),
        .BRAM_PORTA_106_dout(douta_0[106]),
        .BRAM_PORTA_106_we(0),
        .BRAM_PORTA_107_addr(addra_0),
        .BRAM_PORTA_107_clk(clka),
        .BRAM_PORTA_107_din(0),
        .BRAM_PORTA_107_dout(douta_0[107]),
        .BRAM_PORTA_107_we(0),
        .BRAM_PORTA_108_addr(addra_0),
        .BRAM_PORTA_108_clk(clka),
        .BRAM_PORTA_108_din(0),
        .BRAM_PORTA_108_dout(douta_0[108]),
        .BRAM_PORTA_108_we(0),
        .BRAM_PORTA_109_addr(addra_0),
        .BRAM_PORTA_109_clk(clka),
        .BRAM_PORTA_109_din(0),
        .BRAM_PORTA_109_dout(douta_0[109]),
        .BRAM_PORTA_109_we(0),
        .BRAM_PORTA_110_addr(addra_0),
        .BRAM_PORTA_110_clk(clka),
        .BRAM_PORTA_110_din(0),
        .BRAM_PORTA_110_dout(douta_0[110]),
        .BRAM_PORTA_110_we(0),
        .BRAM_PORTA_111_addr(addra_0),
        .BRAM_PORTA_111_clk(clka),
        .BRAM_PORTA_111_din(0),
        .BRAM_PORTA_111_dout(douta_0[111]),
        .BRAM_PORTA_111_we(0),
        .BRAM_PORTA_112_addr(addra_0),
        .BRAM_PORTA_112_clk(clka),
        .BRAM_PORTA_112_din(0),
        .BRAM_PORTA_112_dout(douta_0[112]),
        .BRAM_PORTA_112_we(0),
        .BRAM_PORTA_113_addr(addra_0),
        .BRAM_PORTA_113_clk(clka),
        .BRAM_PORTA_113_din(0),
        .BRAM_PORTA_113_dout(douta_0[113]),
        .BRAM_PORTA_113_we(0),
        .BRAM_PORTA_114_addr(addra_0),
        .BRAM_PORTA_114_clk(clka),
        .BRAM_PORTA_114_din(0),
        .BRAM_PORTA_114_dout(douta_0[114]),
        .BRAM_PORTA_114_we(0),
        .BRAM_PORTA_115_addr(addra_0),
        .BRAM_PORTA_115_clk(clka),
        .BRAM_PORTA_115_din(0),
        .BRAM_PORTA_115_dout(douta_0[115]),
        .BRAM_PORTA_115_we(0),
        .BRAM_PORTA_116_addr(addra_0),
        .BRAM_PORTA_116_clk(clka),
        .BRAM_PORTA_116_din(0),
        .BRAM_PORTA_116_dout(douta_0[116]),
        .BRAM_PORTA_116_we(0),
        .BRAM_PORTA_117_addr(addra_0),
        .BRAM_PORTA_117_clk(clka),
        .BRAM_PORTA_117_din(0),
        .BRAM_PORTA_117_dout(douta_0[117]),
        .BRAM_PORTA_117_we(0),
        .BRAM_PORTA_118_addr(addra_0),
        .BRAM_PORTA_118_clk(clka),
        .BRAM_PORTA_118_din(0),
        .BRAM_PORTA_118_dout(douta_0[118]),
        .BRAM_PORTA_118_we(0),
        .BRAM_PORTA_119_addr(addra_0),
        .BRAM_PORTA_119_clk(clka),
        .BRAM_PORTA_119_din(0),
        .BRAM_PORTA_119_dout(douta_0[119]),
        .BRAM_PORTA_119_we(0),
        .BRAM_PORTA_120_addr(addra_0),
        .BRAM_PORTA_120_clk(clka),
        .BRAM_PORTA_120_din(0),
        .BRAM_PORTA_120_dout(douta_0[120]),
        .BRAM_PORTA_120_we(0),
        .BRAM_PORTA_121_addr(addra_0),
        .BRAM_PORTA_121_clk(clka),
        .BRAM_PORTA_121_din(0),
        .BRAM_PORTA_121_dout(douta_0[121]),
        .BRAM_PORTA_121_we(0),
        .BRAM_PORTA_122_addr(addra_0),
        .BRAM_PORTA_122_clk(clka),
        .BRAM_PORTA_122_din(0),
        .BRAM_PORTA_122_dout(douta_0[122]),
        .BRAM_PORTA_122_we(0),
        .BRAM_PORTA_123_addr(addra_0),
        .BRAM_PORTA_123_clk(clka),
        .BRAM_PORTA_123_din(0),
        .BRAM_PORTA_123_dout(douta_0[123]),
        .BRAM_PORTA_123_we(0),
        .BRAM_PORTA_124_addr(addra_0),
        .BRAM_PORTA_124_clk(clka),
        .BRAM_PORTA_124_din(0),
        .BRAM_PORTA_124_dout(douta_0[124]),
        .BRAM_PORTA_124_we(0),
        .BRAM_PORTA_125_addr(addra_0),
        .BRAM_PORTA_125_clk(clka),
        .BRAM_PORTA_125_din(0),
        .BRAM_PORTA_125_dout(douta_0[125]),
        .BRAM_PORTA_125_we(0),
        .BRAM_PORTA_126_addr(addra_0),
        .BRAM_PORTA_126_clk(clka),
        .BRAM_PORTA_126_din(0),
        .BRAM_PORTA_126_dout(douta_0[126]),
        .BRAM_PORTA_126_we(0),
        .BRAM_PORTA_127_addr(addra_0),
        .BRAM_PORTA_127_clk(clka),
        .BRAM_PORTA_127_din(0),
        .BRAM_PORTA_127_dout(douta_0[127]),
        .BRAM_PORTA_127_we(0));
        
    weights_layer_1_wrapper l1(
        .BRAM_PORTA_addr(addra_1),
        .BRAM_PORTA_clk(clka),
        .BRAM_PORTA_din(0),
        .BRAM_PORTA_dout(douta_1[0]),
        .BRAM_PORTA_we(0),
        .BRAM_PORTA1_addr(addra_1),
        .BRAM_PORTA1_clk(clka),
        .BRAM_PORTA1_din(0),
        .BRAM_PORTA1_dout(douta_1[1]),
        .BRAM_PORTA1_we(0),
        .BRAM_PORTA2_addr(addra_1),
        .BRAM_PORTA2_clk(clka),
        .BRAM_PORTA2_din(0),
        .BRAM_PORTA2_dout(douta_1[2]),
        .BRAM_PORTA2_we(0),
        .BRAM_PORTA3_addr(addra_1),
        .BRAM_PORTA3_clk(clka),
        .BRAM_PORTA3_din(0),
        .BRAM_PORTA3_dout(douta_1[3]),
        .BRAM_PORTA3_we(0),
        .BRAM_PORTA4_addr(addra_1),
        .BRAM_PORTA4_clk(clka),
        .BRAM_PORTA4_din(0),
        .BRAM_PORTA4_dout(douta_1[4]),
        .BRAM_PORTA4_we(0),
        .BRAM_PORTA5_addr(addra_1),
        .BRAM_PORTA5_clk(clka),
        .BRAM_PORTA5_din(0),
        .BRAM_PORTA5_dout(douta_1[5]),
        .BRAM_PORTA5_we(0),
        .BRAM_PORTA6_addr(addra_1),
        .BRAM_PORTA6_clk(clka),
        .BRAM_PORTA6_din(0),
        .BRAM_PORTA6_dout(douta_1[6]),
        .BRAM_PORTA6_we(0),
        .BRAM_PORTA7_addr(addra_1),
        .BRAM_PORTA7_clk(clka),
        .BRAM_PORTA7_din(0),
        .BRAM_PORTA7_dout(douta_1[7]),
        .BRAM_PORTA7_we(0),
        .BRAM_PORTA8_addr(addra_1),
        .BRAM_PORTA8_clk(clka),
        .BRAM_PORTA8_din(0),
        .BRAM_PORTA8_dout(douta_1[8]),
        .BRAM_PORTA8_we(0),
        .BRAM_PORTA9_addr(addra_1),
        .BRAM_PORTA9_clk(clka),
        .BRAM_PORTA9_din(0),
        .BRAM_PORTA9_dout(douta_1[9]),
        .BRAM_PORTA9_we(0));
    

    always_ff @(posedge clka) begin // processingPrev is the value of processing signal one cycle before
        processingPrev_0 <= processing_0;
        processingPrev_1 <= processing_1;
    end
    
    // output logic
    always_comb begin
        if(processingPrev_0) begin
            for(i=0;i<128;i=i+1) begin
                values_0[i] = douta_0[i];
            end
        end
        else begin
            values_0 = 0;
        end
        if(processingPrev_1) begin
            for(i=0;i<10;i=i+1) begin
                values_1[i] = douta_1[i];
            end
        end
        else begin
            values_1 = 0;
        end
    end

    integer i;
    // READING
    always_ff @(posedge clka or posedge rst) begin
        if(rst) begin
            values_0 <= 0;
            values_1 <= 0;
            addra_0 <= 0;
            addra_1 <= 0;
            counter_0 <= 0;
            counter_1 <= 0;
            processing_0 <= 0;
            processing_1 <= 0;
        end
        else begin
            if(processing_0) begin // processing weight request for layer 0, 784 cycles long
                if (counter_0<784) begin
                    addra_0 <= addra_0 + 1;
                    counter_0 <= counter_0 + 1;
                end
                else if(counter_0==784) begin
                    addra_0 <= 0;
                    counter_0 <= 0;
                    processing_0 <= 0;
                end
            end
            else if(start_0) begin // weight values for layer 0 request, asserted for one cycle
                processing_0 <= 1;
                counter_0 <= counter_0 + 1;
            end            
            if(processing_1) begin // processing weight request for layer 1, 128 cycles long
                if (counter_1<128) begin
                    addra_1 <= addra_1 + 1;
                    counter_1 <= counter_1 + 1;
                end
                else if(counter_1==128) begin
                    addra_1 <= 0;
                    counter_1 <= 0;
                    processing_1 <= 0;
                end
            end
            else if(start_1) begin // weight values for layer 1 request, asserted for one cycle
                processing_1 <= 1;
                counter_1 <= counter_1 + 1;
            end
        end
    end

endmodule
/*
module test;

    logic clka, rst;
    logic start_0, start_1;
    logic [127:0] [31:0] values_0;
    logic [9:0] [31:0] values_1;

    initial begin
        clka = 0;
        forever #5 clka = ~clka;
    end

    integer i;
    weights w(clka, rst, start_0, start_1, values_0, values_1);

    initial begin
        rst = 0;
        start_0 = 0;
        start_1 = 0;
        @(posedge clka);
        rst = 1;
        @(posedge clka);
        rst = 0;
        @(posedge clka);
        @(posedge clka);
        @(posedge clka);
        start_0 = 1;
        $display("\n");
        $display("start_0\n");
        $display("values_0[125]=%d",values_0[125]); // 0
        $display("values_0[20]=%d",values_0[20]); // 0
        $display("values_1[5]=%d",values_1[5]); // 0
        $display("------------------------------");
        @(posedge clka); // 1
        start_0 = 0;
        $display("values_0[125]=%d",values_0[125]); // 0
        $display("values_0[20]=%d",values_0[20]); // 0
        $display("values_1[5]=%d",values_1[5]); // 0
        $display("------------------------------");
        @(posedge clka); // 2
        $display("values_0[125]=%d",values_0[125]); // 1
        $display("values_0[20]=%d",values_0[20]); // 1
        $display("values_1[5]=%d",values_1[5]); // 0
        $display("------------------------------");
        @(posedge clka); // 3
        $display("values_0[125]=%d",values_0[125]); // 2
        $display("values_0[20]=%d",values_0[20]); // 2
        $display("values_1[5]=%d",values_1[5]); // 0
        $display("------------------------------");
        for(i=0;i<780;i=i+1) begin
            @(posedge clka);
        end
        $display("values_0[125]=%d",values_0[125]); // 782
        $display("values_0[20]=%d",values_0[20]); // 782
        $display("values_1[5]=%d",values_1[5]); //0
        $display("------------------------------");
        @(posedge clka); // 784
        $display("values_0[125]=%d",values_0[125]); // 783
        $display("values_0[20]=%d",values_0[20]); // 783
        $display("values_1[5]=%d",values_1[5]); //0
        $display("------------------------------");
        @(posedge clka); // 785
        // done
        $display("values_0[125]=%d",values_0[125]); // 0
        $display("values_0[20]=%d",values_0[20]); // 0
        $display("values_1[5]=%d",values_1[5]); //0
        $display("------------------------------");
        $display("\n");
        @(posedge clka);
        $display("values_0[125]=%d",values_0[125]); // 0
        $display("values_0[20]=%d",values_0[20]); // 0
        $display("values_1[5]=%d",values_1[5]); //0
        $display("------------------------------");
        $display("\n");
        @(posedge clka);
        start_1 = 1;
        $display("start_1\n");
        $display("values_0[125]=%d",values_0[125]); // 0
        $display("values_0[20]=%d",values_0[20]); // 0
        $display("values_1[5]=%d",values_1[5]); // 0
        $display("------------------------------");
        @(posedge clka); // 1
        $display("values_0[125]=%d",values_0[125]); // 0
        $display("values_0[20]=%d",values_0[20]); // 0
        $display("values_1[5]=%d",values_1[5]); // 0
        $display("------------------------------");
        start_1 = 0;
        @(posedge clka); // 2
        $display("values_0[125]=%d",values_0[125]); // 0
        $display("values_0[20]=%d",values_0[20]); // 0
        $display("values_1[5]=%d",values_1[5]); // 1
        $display("------------------------------");
        @(posedge clka); // 3
        for(i=0;i<125;i=i+1) begin
            @(posedge clka);
        end
        $display("values_0[125]=%d",values_0[125]); // 0
        $display("values_0[20]=%d",values_0[20]); // 0
        $display("values_1[5]=%d",values_1[5]); // 127 
        $display("------------------------------");
        @(posedge clka); // 129
        $display("values_0[125]=%d",values_0[125]); // 0
        $display("values_0[20]=%d",values_0[20]); // 0
        $display("values_1[5]=%d",values_1[5]); // 0
        $display("------------------------------");
        @(posedge clka);
        $display("values_0[125]=%d",values_0[125]); // 0
        $display("values_0[20]=%d",values_0[20]); // 0
        $display("values_1[5]=%d",values_1[5]); // 0
        $display("------------------------------");
        $display("\n");
        @(posedge clka);
        @(posedge clka);
        @(posedge clka);
        $finish;
    end

endmodule*/