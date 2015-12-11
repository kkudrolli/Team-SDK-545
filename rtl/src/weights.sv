`timescale 1ns / 1ps

/**
 * A cycle after update is asserted, deltaWeights are applied.
 */
module weights(input clka, rst,
              input start_0, start_1, update_0, update_1,
              input [4095:0] deltaWeights_0,
              input [319:0] deltaWeights_1,
              output logic [4095:0] values_0,
              output logic [319:0] values_1);
    
    logic processing_0, processing_1, processing_update_0, processing_update_1;
    logic [9:0] counter_0;
    logic [7:0] counter_1;

    //32 x 128, for 784 cycles
    logic [783:0] [4095:0] BRAM_0 /* verilator public */;
    // 32 x 10, 128 cycles
    logic [127:0] [319:0]  BRAM_1 /* verilator public */;

    integer i;
    // READING
    always_ff @(posedge clka or posedge rst) begin
        if(rst) begin
            counter_0 <= 0;
            counter_1 <= 0;
            processing_0 <= 0;
            processing_1 <= 0;
            processing_update_0 <= 0;
            processing_update_1 <= 0;
            for(i=0;i<784;i=i+1) begin
                BRAM_0[i] <= i; // random number
            end
            // initialize for the purpose of testing
            for(i=0;i<128;i=i+1) begin
                BRAM_1[i] <= i; // random number
            end
        end
        else begin
            /////////////
            // READING //
            /////////////
            if(processing_0) begin // processing weight request for layer 0, 784 cycles long
                if (counter_0<784) begin
                    values_0 <= BRAM_0[counter_0];
                    counter_0 <= counter_0 + 1;
                end
                else if(counter_0==784) begin
                    values_0 <= 0;
                    counter_0 <= 0;
                    processing_0 <= 0;
                end
            end
            else if(start_0) begin // weight values for layer 0 request, asserted for one cycle
                values_0 <= BRAM_0[counter_0];
                processing_0 <= 1;
                counter_0 <= counter_0 + 1;
            end            
            if(processing_1) begin // processing weight request for layer 1, 128 cycles long
                if (counter_1<128) begin
                    values_1 <= BRAM_1[counter_1];
                    counter_1 <= counter_1 + 1;
                end
                else if(counter_1==128) begin
                    values_1 <= 0;
                    counter_1 <= 0;
                    processing_1 <= 0;
                end
            end
            else if(start_1) begin // weight values for layer 1 request, asserted for one cycle
                values_1 <= BRAM_1[counter_1];
                processing_1 <= 1;
                counter_1 <= counter_1 + 1;
            end
            
            //////////////
            // UPDATING //
            //////////////
            if(processing_update_0) begin
                if (counter_0<784) begin

                    BRAM_0[counter_0-1][31:0] <= BRAM_0[counter_0-1][31:0]+deltaWeights_0[31:0];
                    BRAM_0[counter_0-1][63:32] <= BRAM_0[counter_0-1][63:32]+deltaWeights_0[63:32];
                    BRAM_0[counter_0-1][95:64] <= BRAM_0[counter_0-1][95:64]+deltaWeights_0[95:64];
                    BRAM_0[counter_0-1][127:96] <= BRAM_0[counter_0-1][127:96]+deltaWeights_0[127:96];
                    BRAM_0[counter_0-1][159:128] <= BRAM_0[counter_0-1][159:128]+deltaWeights_0[159:128];
                    BRAM_0[counter_0-1][191:160] <= BRAM_0[counter_0-1][191:160]+deltaWeights_0[191:160];
                    BRAM_0[counter_0-1][223:192] <= BRAM_0[counter_0-1][223:192]+deltaWeights_0[223:192];
                    BRAM_0[counter_0-1][255:224] <= BRAM_0[counter_0-1][255:224]+deltaWeights_0[255:224];
                    BRAM_0[counter_0-1][287:256] <= BRAM_0[counter_0-1][287:256]+deltaWeights_0[287:256];
                    BRAM_0[counter_0-1][319:288] <= BRAM_0[counter_0-1][319:288]+deltaWeights_0[319:288];
                    BRAM_0[counter_0-1][351:320] <= BRAM_0[counter_0-1][351:320]+deltaWeights_0[351:320];
                    BRAM_0[counter_0-1][383:352] <= BRAM_0[counter_0-1][383:352]+deltaWeights_0[383:352];
                    BRAM_0[counter_0-1][415:384] <= BRAM_0[counter_0-1][415:384]+deltaWeights_0[415:384];
                    BRAM_0[counter_0-1][447:416] <= BRAM_0[counter_0-1][447:416]+deltaWeights_0[447:416];
                    BRAM_0[counter_0-1][479:448] <= BRAM_0[counter_0-1][479:448]+deltaWeights_0[479:448];
                    BRAM_0[counter_0-1][511:480] <= BRAM_0[counter_0-1][511:480]+deltaWeights_0[511:480];
                    BRAM_0[counter_0-1][543:512] <= BRAM_0[counter_0-1][543:512]+deltaWeights_0[543:512];
                    BRAM_0[counter_0-1][575:544] <= BRAM_0[counter_0-1][575:544]+deltaWeights_0[575:544];
                    BRAM_0[counter_0-1][607:576] <= BRAM_0[counter_0-1][607:576]+deltaWeights_0[607:576];
                    BRAM_0[counter_0-1][639:608] <= BRAM_0[counter_0-1][639:608]+deltaWeights_0[639:608];
                    BRAM_0[counter_0-1][671:640] <= BRAM_0[counter_0-1][671:640]+deltaWeights_0[671:640];
                    BRAM_0[counter_0-1][703:672] <= BRAM_0[counter_0-1][703:672]+deltaWeights_0[703:672];
                    BRAM_0[counter_0-1][735:704] <= BRAM_0[counter_0-1][735:704]+deltaWeights_0[735:704];
                    BRAM_0[counter_0-1][767:736] <= BRAM_0[counter_0-1][767:736]+deltaWeights_0[767:736];
                    BRAM_0[counter_0-1][799:768] <= BRAM_0[counter_0-1][799:768]+deltaWeights_0[799:768];
                    BRAM_0[counter_0-1][831:800] <= BRAM_0[counter_0-1][831:800]+deltaWeights_0[831:800];
                    BRAM_0[counter_0-1][863:832] <= BRAM_0[counter_0-1][863:832]+deltaWeights_0[863:832];
                    BRAM_0[counter_0-1][895:864] <= BRAM_0[counter_0-1][895:864]+deltaWeights_0[895:864];
                    BRAM_0[counter_0-1][927:896] <= BRAM_0[counter_0-1][927:896]+deltaWeights_0[927:896];
                    BRAM_0[counter_0-1][959:928] <= BRAM_0[counter_0-1][959:928]+deltaWeights_0[959:928];
                    BRAM_0[counter_0-1][991:960] <= BRAM_0[counter_0-1][991:960]+deltaWeights_0[991:960];
                    BRAM_0[counter_0-1][1023:992] <= BRAM_0[counter_0-1][1023:992]+deltaWeights_0[1023:992];
                    BRAM_0[counter_0-1][1055:1024] <= BRAM_0[counter_0-1][1055:1024]+deltaWeights_0[1055:1024];
                    BRAM_0[counter_0-1][1087:1056] <= BRAM_0[counter_0-1][1087:1056]+deltaWeights_0[1087:1056];
                    BRAM_0[counter_0-1][1119:1088] <= BRAM_0[counter_0-1][1119:1088]+deltaWeights_0[1119:1088];
                    BRAM_0[counter_0-1][1151:1120] <= BRAM_0[counter_0-1][1151:1120]+deltaWeights_0[1151:1120];
                    BRAM_0[counter_0-1][1183:1152] <= BRAM_0[counter_0-1][1183:1152]+deltaWeights_0[1183:1152];
                    BRAM_0[counter_0-1][1215:1184] <= BRAM_0[counter_0-1][1215:1184]+deltaWeights_0[1215:1184];
                    BRAM_0[counter_0-1][1247:1216] <= BRAM_0[counter_0-1][1247:1216]+deltaWeights_0[1247:1216];
                    BRAM_0[counter_0-1][1279:1248] <= BRAM_0[counter_0-1][1279:1248]+deltaWeights_0[1279:1248];
                    BRAM_0[counter_0-1][1311:1280] <= BRAM_0[counter_0-1][1311:1280]+deltaWeights_0[1311:1280];
                    BRAM_0[counter_0-1][1343:1312] <= BRAM_0[counter_0-1][1343:1312]+deltaWeights_0[1343:1312];
                    BRAM_0[counter_0-1][1375:1344] <= BRAM_0[counter_0-1][1375:1344]+deltaWeights_0[1375:1344];
                    BRAM_0[counter_0-1][1407:1376] <= BRAM_0[counter_0-1][1407:1376]+deltaWeights_0[1407:1376];
                    BRAM_0[counter_0-1][1439:1408] <= BRAM_0[counter_0-1][1439:1408]+deltaWeights_0[1439:1408];
                    BRAM_0[counter_0-1][1471:1440] <= BRAM_0[counter_0-1][1471:1440]+deltaWeights_0[1471:1440];
                    BRAM_0[counter_0-1][1503:1472] <= BRAM_0[counter_0-1][1503:1472]+deltaWeights_0[1503:1472];
                    BRAM_0[counter_0-1][1535:1504] <= BRAM_0[counter_0-1][1535:1504]+deltaWeights_0[1535:1504];
                    BRAM_0[counter_0-1][1567:1536] <= BRAM_0[counter_0-1][1567:1536]+deltaWeights_0[1567:1536];
                    BRAM_0[counter_0-1][1599:1568] <= BRAM_0[counter_0-1][1599:1568]+deltaWeights_0[1599:1568];
                    BRAM_0[counter_0-1][1631:1600] <= BRAM_0[counter_0-1][1631:1600]+deltaWeights_0[1631:1600];
                    BRAM_0[counter_0-1][1663:1632] <= BRAM_0[counter_0-1][1663:1632]+deltaWeights_0[1663:1632];
                    BRAM_0[counter_0-1][1695:1664] <= BRAM_0[counter_0-1][1695:1664]+deltaWeights_0[1695:1664];
                    BRAM_0[counter_0-1][1727:1696] <= BRAM_0[counter_0-1][1727:1696]+deltaWeights_0[1727:1696];
                    BRAM_0[counter_0-1][1759:1728] <= BRAM_0[counter_0-1][1759:1728]+deltaWeights_0[1759:1728];
                    BRAM_0[counter_0-1][1791:1760] <= BRAM_0[counter_0-1][1791:1760]+deltaWeights_0[1791:1760];
                    BRAM_0[counter_0-1][1823:1792] <= BRAM_0[counter_0-1][1823:1792]+deltaWeights_0[1823:1792];
                    BRAM_0[counter_0-1][1855:1824] <= BRAM_0[counter_0-1][1855:1824]+deltaWeights_0[1855:1824];
                    BRAM_0[counter_0-1][1887:1856] <= BRAM_0[counter_0-1][1887:1856]+deltaWeights_0[1887:1856];
                    BRAM_0[counter_0-1][1919:1888] <= BRAM_0[counter_0-1][1919:1888]+deltaWeights_0[1919:1888];
                    BRAM_0[counter_0-1][1951:1920] <= BRAM_0[counter_0-1][1951:1920]+deltaWeights_0[1951:1920];
                    BRAM_0[counter_0-1][1983:1952] <= BRAM_0[counter_0-1][1983:1952]+deltaWeights_0[1983:1952];
                    BRAM_0[counter_0-1][2015:1984] <= BRAM_0[counter_0-1][2015:1984]+deltaWeights_0[2015:1984];
                    BRAM_0[counter_0-1][2047:2016] <= BRAM_0[counter_0-1][2047:2016]+deltaWeights_0[2047:2016];
                    BRAM_0[counter_0-1][2079:2048] <= BRAM_0[counter_0-1][2079:2048]+deltaWeights_0[2079:2048];
                    BRAM_0[counter_0-1][2111:2080] <= BRAM_0[counter_0-1][2111:2080]+deltaWeights_0[2111:2080];
                    BRAM_0[counter_0-1][2143:2112] <= BRAM_0[counter_0-1][2143:2112]+deltaWeights_0[2143:2112];
                    BRAM_0[counter_0-1][2175:2144] <= BRAM_0[counter_0-1][2175:2144]+deltaWeights_0[2175:2144];
                    BRAM_0[counter_0-1][2207:2176] <= BRAM_0[counter_0-1][2207:2176]+deltaWeights_0[2207:2176];
                    BRAM_0[counter_0-1][2239:2208] <= BRAM_0[counter_0-1][2239:2208]+deltaWeights_0[2239:2208];
                    BRAM_0[counter_0-1][2271:2240] <= BRAM_0[counter_0-1][2271:2240]+deltaWeights_0[2271:2240];
                    BRAM_0[counter_0-1][2303:2272] <= BRAM_0[counter_0-1][2303:2272]+deltaWeights_0[2303:2272];
                    BRAM_0[counter_0-1][2335:2304] <= BRAM_0[counter_0-1][2335:2304]+deltaWeights_0[2335:2304];
                    BRAM_0[counter_0-1][2367:2336] <= BRAM_0[counter_0-1][2367:2336]+deltaWeights_0[2367:2336];
                    BRAM_0[counter_0-1][2399:2368] <= BRAM_0[counter_0-1][2399:2368]+deltaWeights_0[2399:2368];
                    BRAM_0[counter_0-1][2431:2400] <= BRAM_0[counter_0-1][2431:2400]+deltaWeights_0[2431:2400];
                    BRAM_0[counter_0-1][2463:2432] <= BRAM_0[counter_0-1][2463:2432]+deltaWeights_0[2463:2432];
                    BRAM_0[counter_0-1][2495:2464] <= BRAM_0[counter_0-1][2495:2464]+deltaWeights_0[2495:2464];
                    BRAM_0[counter_0-1][2527:2496] <= BRAM_0[counter_0-1][2527:2496]+deltaWeights_0[2527:2496];
                    BRAM_0[counter_0-1][2559:2528] <= BRAM_0[counter_0-1][2559:2528]+deltaWeights_0[2559:2528];
                    BRAM_0[counter_0-1][2591:2560] <= BRAM_0[counter_0-1][2591:2560]+deltaWeights_0[2591:2560];
                    BRAM_0[counter_0-1][2623:2592] <= BRAM_0[counter_0-1][2623:2592]+deltaWeights_0[2623:2592];
                    BRAM_0[counter_0-1][2655:2624] <= BRAM_0[counter_0-1][2655:2624]+deltaWeights_0[2655:2624];
                    BRAM_0[counter_0-1][2687:2656] <= BRAM_0[counter_0-1][2687:2656]+deltaWeights_0[2687:2656];
                    BRAM_0[counter_0-1][2719:2688] <= BRAM_0[counter_0-1][2719:2688]+deltaWeights_0[2719:2688];
                    BRAM_0[counter_0-1][2751:2720] <= BRAM_0[counter_0-1][2751:2720]+deltaWeights_0[2751:2720];
                    BRAM_0[counter_0-1][2783:2752] <= BRAM_0[counter_0-1][2783:2752]+deltaWeights_0[2783:2752];
                    BRAM_0[counter_0-1][2815:2784] <= BRAM_0[counter_0-1][2815:2784]+deltaWeights_0[2815:2784];
                    BRAM_0[counter_0-1][2847:2816] <= BRAM_0[counter_0-1][2847:2816]+deltaWeights_0[2847:2816];
                    BRAM_0[counter_0-1][2879:2848] <= BRAM_0[counter_0-1][2879:2848]+deltaWeights_0[2879:2848];
                    BRAM_0[counter_0-1][2911:2880] <= BRAM_0[counter_0-1][2911:2880]+deltaWeights_0[2911:2880];
                    BRAM_0[counter_0-1][2943:2912] <= BRAM_0[counter_0-1][2943:2912]+deltaWeights_0[2943:2912];
                    BRAM_0[counter_0-1][2975:2944] <= BRAM_0[counter_0-1][2975:2944]+deltaWeights_0[2975:2944];
                    BRAM_0[counter_0-1][3007:2976] <= BRAM_0[counter_0-1][3007:2976]+deltaWeights_0[3007:2976];
                    BRAM_0[counter_0-1][3039:3008] <= BRAM_0[counter_0-1][3039:3008]+deltaWeights_0[3039:3008];
                    BRAM_0[counter_0-1][3071:3040] <= BRAM_0[counter_0-1][3071:3040]+deltaWeights_0[3071:3040];
                    BRAM_0[counter_0-1][3103:3072] <= BRAM_0[counter_0-1][3103:3072]+deltaWeights_0[3103:3072];
                    BRAM_0[counter_0-1][3135:3104] <= BRAM_0[counter_0-1][3135:3104]+deltaWeights_0[3135:3104];
                    BRAM_0[counter_0-1][3167:3136] <= BRAM_0[counter_0-1][3167:3136]+deltaWeights_0[3167:3136];
                    BRAM_0[counter_0-1][3199:3168] <= BRAM_0[counter_0-1][3199:3168]+deltaWeights_0[3199:3168];
                    BRAM_0[counter_0-1][3231:3200] <= BRAM_0[counter_0-1][3231:3200]+deltaWeights_0[3231:3200];
                    BRAM_0[counter_0-1][3263:3232] <= BRAM_0[counter_0-1][3263:3232]+deltaWeights_0[3263:3232];
                    BRAM_0[counter_0-1][3295:3264] <= BRAM_0[counter_0-1][3295:3264]+deltaWeights_0[3295:3264];
                    BRAM_0[counter_0-1][3327:3296] <= BRAM_0[counter_0-1][3327:3296]+deltaWeights_0[3327:3296];
                    BRAM_0[counter_0-1][3359:3328] <= BRAM_0[counter_0-1][3359:3328]+deltaWeights_0[3359:3328];
                    BRAM_0[counter_0-1][3391:3360] <= BRAM_0[counter_0-1][3391:3360]+deltaWeights_0[3391:3360];
                    BRAM_0[counter_0-1][3423:3392] <= BRAM_0[counter_0-1][3423:3392]+deltaWeights_0[3423:3392];
                    BRAM_0[counter_0-1][3455:3424] <= BRAM_0[counter_0-1][3455:3424]+deltaWeights_0[3455:3424];
                    BRAM_0[counter_0-1][3487:3456] <= BRAM_0[counter_0-1][3487:3456]+deltaWeights_0[3487:3456];
                    BRAM_0[counter_0-1][3519:3488] <= BRAM_0[counter_0-1][3519:3488]+deltaWeights_0[3519:3488];
                    BRAM_0[counter_0-1][3551:3520] <= BRAM_0[counter_0-1][3551:3520]+deltaWeights_0[3551:3520];
                    BRAM_0[counter_0-1][3583:3552] <= BRAM_0[counter_0-1][3583:3552]+deltaWeights_0[3583:3552];
                    BRAM_0[counter_0-1][3615:3584] <= BRAM_0[counter_0-1][3615:3584]+deltaWeights_0[3615:3584];
                    BRAM_0[counter_0-1][3647:3616] <= BRAM_0[counter_0-1][3647:3616]+deltaWeights_0[3647:3616];
                    BRAM_0[counter_0-1][3679:3648] <= BRAM_0[counter_0-1][3679:3648]+deltaWeights_0[3679:3648];
                    BRAM_0[counter_0-1][3711:3680] <= BRAM_0[counter_0-1][3711:3680]+deltaWeights_0[3711:3680];
                    BRAM_0[counter_0-1][3743:3712] <= BRAM_0[counter_0-1][3743:3712]+deltaWeights_0[3743:3712];
                    BRAM_0[counter_0-1][3775:3744] <= BRAM_0[counter_0-1][3775:3744]+deltaWeights_0[3775:3744];
                    BRAM_0[counter_0-1][3807:3776] <= BRAM_0[counter_0-1][3807:3776]+deltaWeights_0[3807:3776];
                    BRAM_0[counter_0-1][3839:3808] <= BRAM_0[counter_0-1][3839:3808]+deltaWeights_0[3839:3808];
                    BRAM_0[counter_0-1][3871:3840] <= BRAM_0[counter_0-1][3871:3840]+deltaWeights_0[3871:3840];
                    BRAM_0[counter_0-1][3903:3872] <= BRAM_0[counter_0-1][3903:3872]+deltaWeights_0[3903:3872];
                    BRAM_0[counter_0-1][3935:3904] <= BRAM_0[counter_0-1][3935:3904]+deltaWeights_0[3935:3904];
                    BRAM_0[counter_0-1][3967:3936] <= BRAM_0[counter_0-1][3967:3936]+deltaWeights_0[3967:3936];
                    BRAM_0[counter_0-1][3999:3968] <= BRAM_0[counter_0-1][3999:3968]+deltaWeights_0[3999:3968];
                    BRAM_0[counter_0-1][4031:4000] <= BRAM_0[counter_0-1][4031:4000]+deltaWeights_0[4031:4000];
                    BRAM_0[counter_0-1][4063:4032] <= BRAM_0[counter_0-1][4063:4032]+deltaWeights_0[4063:4032];
                    BRAM_0[counter_0-1][4095:4064] <= BRAM_0[counter_0-1][4095:4064]+deltaWeights_0[4095:4064];
                    counter_0 <= counter_0 + 1;
                end
                else if(counter_0==784) begin
                    BRAM_0[counter_0-1][31:0] <= BRAM_0[counter_0-1][31:0]+deltaWeights_0[31:0];
                    BRAM_0[counter_0-1][63:32] <= BRAM_0[counter_0-1][63:32]+deltaWeights_0[63:32];
                    BRAM_0[counter_0-1][95:64] <= BRAM_0[counter_0-1][95:64]+deltaWeights_0[95:64];
                    BRAM_0[counter_0-1][127:96] <= BRAM_0[counter_0-1][127:96]+deltaWeights_0[127:96];
                    BRAM_0[counter_0-1][159:128] <= BRAM_0[counter_0-1][159:128]+deltaWeights_0[159:128];
                    BRAM_0[counter_0-1][191:160] <= BRAM_0[counter_0-1][191:160]+deltaWeights_0[191:160];
                    BRAM_0[counter_0-1][223:192] <= BRAM_0[counter_0-1][223:192]+deltaWeights_0[223:192];
                    BRAM_0[counter_0-1][255:224] <= BRAM_0[counter_0-1][255:224]+deltaWeights_0[255:224];
                    BRAM_0[counter_0-1][287:256] <= BRAM_0[counter_0-1][287:256]+deltaWeights_0[287:256];
                    BRAM_0[counter_0-1][319:288] <= BRAM_0[counter_0-1][319:288]+deltaWeights_0[319:288];
                    BRAM_0[counter_0-1][351:320] <= BRAM_0[counter_0-1][351:320]+deltaWeights_0[351:320];
                    BRAM_0[counter_0-1][383:352] <= BRAM_0[counter_0-1][383:352]+deltaWeights_0[383:352];
                    BRAM_0[counter_0-1][415:384] <= BRAM_0[counter_0-1][415:384]+deltaWeights_0[415:384];
                    BRAM_0[counter_0-1][447:416] <= BRAM_0[counter_0-1][447:416]+deltaWeights_0[447:416];
                    BRAM_0[counter_0-1][479:448] <= BRAM_0[counter_0-1][479:448]+deltaWeights_0[479:448];
                    BRAM_0[counter_0-1][511:480] <= BRAM_0[counter_0-1][511:480]+deltaWeights_0[511:480];
                    BRAM_0[counter_0-1][543:512] <= BRAM_0[counter_0-1][543:512]+deltaWeights_0[543:512];
                    BRAM_0[counter_0-1][575:544] <= BRAM_0[counter_0-1][575:544]+deltaWeights_0[575:544];
                    BRAM_0[counter_0-1][607:576] <= BRAM_0[counter_0-1][607:576]+deltaWeights_0[607:576];
                    BRAM_0[counter_0-1][639:608] <= BRAM_0[counter_0-1][639:608]+deltaWeights_0[639:608];
                    BRAM_0[counter_0-1][671:640] <= BRAM_0[counter_0-1][671:640]+deltaWeights_0[671:640];
                    BRAM_0[counter_0-1][703:672] <= BRAM_0[counter_0-1][703:672]+deltaWeights_0[703:672];
                    BRAM_0[counter_0-1][735:704] <= BRAM_0[counter_0-1][735:704]+deltaWeights_0[735:704];
                    BRAM_0[counter_0-1][767:736] <= BRAM_0[counter_0-1][767:736]+deltaWeights_0[767:736];
                    BRAM_0[counter_0-1][799:768] <= BRAM_0[counter_0-1][799:768]+deltaWeights_0[799:768];
                    BRAM_0[counter_0-1][831:800] <= BRAM_0[counter_0-1][831:800]+deltaWeights_0[831:800];
                    BRAM_0[counter_0-1][863:832] <= BRAM_0[counter_0-1][863:832]+deltaWeights_0[863:832];
                    BRAM_0[counter_0-1][895:864] <= BRAM_0[counter_0-1][895:864]+deltaWeights_0[895:864];
                    BRAM_0[counter_0-1][927:896] <= BRAM_0[counter_0-1][927:896]+deltaWeights_0[927:896];
                    BRAM_0[counter_0-1][959:928] <= BRAM_0[counter_0-1][959:928]+deltaWeights_0[959:928];
                    BRAM_0[counter_0-1][991:960] <= BRAM_0[counter_0-1][991:960]+deltaWeights_0[991:960];
                    BRAM_0[counter_0-1][1023:992] <= BRAM_0[counter_0-1][1023:992]+deltaWeights_0[1023:992];
                    BRAM_0[counter_0-1][1055:1024] <= BRAM_0[counter_0-1][1055:1024]+deltaWeights_0[1055:1024];
                    BRAM_0[counter_0-1][1087:1056] <= BRAM_0[counter_0-1][1087:1056]+deltaWeights_0[1087:1056];
                    BRAM_0[counter_0-1][1119:1088] <= BRAM_0[counter_0-1][1119:1088]+deltaWeights_0[1119:1088];
                    BRAM_0[counter_0-1][1151:1120] <= BRAM_0[counter_0-1][1151:1120]+deltaWeights_0[1151:1120];
                    BRAM_0[counter_0-1][1183:1152] <= BRAM_0[counter_0-1][1183:1152]+deltaWeights_0[1183:1152];
                    BRAM_0[counter_0-1][1215:1184] <= BRAM_0[counter_0-1][1215:1184]+deltaWeights_0[1215:1184];
                    BRAM_0[counter_0-1][1247:1216] <= BRAM_0[counter_0-1][1247:1216]+deltaWeights_0[1247:1216];
                    BRAM_0[counter_0-1][1279:1248] <= BRAM_0[counter_0-1][1279:1248]+deltaWeights_0[1279:1248];
                    BRAM_0[counter_0-1][1311:1280] <= BRAM_0[counter_0-1][1311:1280]+deltaWeights_0[1311:1280];
                    BRAM_0[counter_0-1][1343:1312] <= BRAM_0[counter_0-1][1343:1312]+deltaWeights_0[1343:1312];
                    BRAM_0[counter_0-1][1375:1344] <= BRAM_0[counter_0-1][1375:1344]+deltaWeights_0[1375:1344];
                    BRAM_0[counter_0-1][1407:1376] <= BRAM_0[counter_0-1][1407:1376]+deltaWeights_0[1407:1376];
                    BRAM_0[counter_0-1][1439:1408] <= BRAM_0[counter_0-1][1439:1408]+deltaWeights_0[1439:1408];
                    BRAM_0[counter_0-1][1471:1440] <= BRAM_0[counter_0-1][1471:1440]+deltaWeights_0[1471:1440];
                    BRAM_0[counter_0-1][1503:1472] <= BRAM_0[counter_0-1][1503:1472]+deltaWeights_0[1503:1472];
                    BRAM_0[counter_0-1][1535:1504] <= BRAM_0[counter_0-1][1535:1504]+deltaWeights_0[1535:1504];
                    BRAM_0[counter_0-1][1567:1536] <= BRAM_0[counter_0-1][1567:1536]+deltaWeights_0[1567:1536];
                    BRAM_0[counter_0-1][1599:1568] <= BRAM_0[counter_0-1][1599:1568]+deltaWeights_0[1599:1568];
                    BRAM_0[counter_0-1][1631:1600] <= BRAM_0[counter_0-1][1631:1600]+deltaWeights_0[1631:1600];
                    BRAM_0[counter_0-1][1663:1632] <= BRAM_0[counter_0-1][1663:1632]+deltaWeights_0[1663:1632];
                    BRAM_0[counter_0-1][1695:1664] <= BRAM_0[counter_0-1][1695:1664]+deltaWeights_0[1695:1664];
                    BRAM_0[counter_0-1][1727:1696] <= BRAM_0[counter_0-1][1727:1696]+deltaWeights_0[1727:1696];
                    BRAM_0[counter_0-1][1759:1728] <= BRAM_0[counter_0-1][1759:1728]+deltaWeights_0[1759:1728];
                    BRAM_0[counter_0-1][1791:1760] <= BRAM_0[counter_0-1][1791:1760]+deltaWeights_0[1791:1760];
                    BRAM_0[counter_0-1][1823:1792] <= BRAM_0[counter_0-1][1823:1792]+deltaWeights_0[1823:1792];
                    BRAM_0[counter_0-1][1855:1824] <= BRAM_0[counter_0-1][1855:1824]+deltaWeights_0[1855:1824];
                    BRAM_0[counter_0-1][1887:1856] <= BRAM_0[counter_0-1][1887:1856]+deltaWeights_0[1887:1856];
                    BRAM_0[counter_0-1][1919:1888] <= BRAM_0[counter_0-1][1919:1888]+deltaWeights_0[1919:1888];
                    BRAM_0[counter_0-1][1951:1920] <= BRAM_0[counter_0-1][1951:1920]+deltaWeights_0[1951:1920];
                    BRAM_0[counter_0-1][1983:1952] <= BRAM_0[counter_0-1][1983:1952]+deltaWeights_0[1983:1952];
                    BRAM_0[counter_0-1][2015:1984] <= BRAM_0[counter_0-1][2015:1984]+deltaWeights_0[2015:1984];
                    BRAM_0[counter_0-1][2047:2016] <= BRAM_0[counter_0-1][2047:2016]+deltaWeights_0[2047:2016];
                    BRAM_0[counter_0-1][2079:2048] <= BRAM_0[counter_0-1][2079:2048]+deltaWeights_0[2079:2048];
                    BRAM_0[counter_0-1][2111:2080] <= BRAM_0[counter_0-1][2111:2080]+deltaWeights_0[2111:2080];
                    BRAM_0[counter_0-1][2143:2112] <= BRAM_0[counter_0-1][2143:2112]+deltaWeights_0[2143:2112];
                    BRAM_0[counter_0-1][2175:2144] <= BRAM_0[counter_0-1][2175:2144]+deltaWeights_0[2175:2144];
                    BRAM_0[counter_0-1][2207:2176] <= BRAM_0[counter_0-1][2207:2176]+deltaWeights_0[2207:2176];
                    BRAM_0[counter_0-1][2239:2208] <= BRAM_0[counter_0-1][2239:2208]+deltaWeights_0[2239:2208];
                    BRAM_0[counter_0-1][2271:2240] <= BRAM_0[counter_0-1][2271:2240]+deltaWeights_0[2271:2240];
                    BRAM_0[counter_0-1][2303:2272] <= BRAM_0[counter_0-1][2303:2272]+deltaWeights_0[2303:2272];
                    BRAM_0[counter_0-1][2335:2304] <= BRAM_0[counter_0-1][2335:2304]+deltaWeights_0[2335:2304];
                    BRAM_0[counter_0-1][2367:2336] <= BRAM_0[counter_0-1][2367:2336]+deltaWeights_0[2367:2336];
                    BRAM_0[counter_0-1][2399:2368] <= BRAM_0[counter_0-1][2399:2368]+deltaWeights_0[2399:2368];
                    BRAM_0[counter_0-1][2431:2400] <= BRAM_0[counter_0-1][2431:2400]+deltaWeights_0[2431:2400];
                    BRAM_0[counter_0-1][2463:2432] <= BRAM_0[counter_0-1][2463:2432]+deltaWeights_0[2463:2432];
                    BRAM_0[counter_0-1][2495:2464] <= BRAM_0[counter_0-1][2495:2464]+deltaWeights_0[2495:2464];
                    BRAM_0[counter_0-1][2527:2496] <= BRAM_0[counter_0-1][2527:2496]+deltaWeights_0[2527:2496];
                    BRAM_0[counter_0-1][2559:2528] <= BRAM_0[counter_0-1][2559:2528]+deltaWeights_0[2559:2528];
                    BRAM_0[counter_0-1][2591:2560] <= BRAM_0[counter_0-1][2591:2560]+deltaWeights_0[2591:2560];
                    BRAM_0[counter_0-1][2623:2592] <= BRAM_0[counter_0-1][2623:2592]+deltaWeights_0[2623:2592];
                    BRAM_0[counter_0-1][2655:2624] <= BRAM_0[counter_0-1][2655:2624]+deltaWeights_0[2655:2624];
                    BRAM_0[counter_0-1][2687:2656] <= BRAM_0[counter_0-1][2687:2656]+deltaWeights_0[2687:2656];
                    BRAM_0[counter_0-1][2719:2688] <= BRAM_0[counter_0-1][2719:2688]+deltaWeights_0[2719:2688];
                    BRAM_0[counter_0-1][2751:2720] <= BRAM_0[counter_0-1][2751:2720]+deltaWeights_0[2751:2720];
                    BRAM_0[counter_0-1][2783:2752] <= BRAM_0[counter_0-1][2783:2752]+deltaWeights_0[2783:2752];
                    BRAM_0[counter_0-1][2815:2784] <= BRAM_0[counter_0-1][2815:2784]+deltaWeights_0[2815:2784];
                    BRAM_0[counter_0-1][2847:2816] <= BRAM_0[counter_0-1][2847:2816]+deltaWeights_0[2847:2816];
                    BRAM_0[counter_0-1][2879:2848] <= BRAM_0[counter_0-1][2879:2848]+deltaWeights_0[2879:2848];
                    BRAM_0[counter_0-1][2911:2880] <= BRAM_0[counter_0-1][2911:2880]+deltaWeights_0[2911:2880];
                    BRAM_0[counter_0-1][2943:2912] <= BRAM_0[counter_0-1][2943:2912]+deltaWeights_0[2943:2912];
                    BRAM_0[counter_0-1][2975:2944] <= BRAM_0[counter_0-1][2975:2944]+deltaWeights_0[2975:2944];
                    BRAM_0[counter_0-1][3007:2976] <= BRAM_0[counter_0-1][3007:2976]+deltaWeights_0[3007:2976];
                    BRAM_0[counter_0-1][3039:3008] <= BRAM_0[counter_0-1][3039:3008]+deltaWeights_0[3039:3008];
                    BRAM_0[counter_0-1][3071:3040] <= BRAM_0[counter_0-1][3071:3040]+deltaWeights_0[3071:3040];
                    BRAM_0[counter_0-1][3103:3072] <= BRAM_0[counter_0-1][3103:3072]+deltaWeights_0[3103:3072];
                    BRAM_0[counter_0-1][3135:3104] <= BRAM_0[counter_0-1][3135:3104]+deltaWeights_0[3135:3104];
                    BRAM_0[counter_0-1][3167:3136] <= BRAM_0[counter_0-1][3167:3136]+deltaWeights_0[3167:3136];
                    BRAM_0[counter_0-1][3199:3168] <= BRAM_0[counter_0-1][3199:3168]+deltaWeights_0[3199:3168];
                    BRAM_0[counter_0-1][3231:3200] <= BRAM_0[counter_0-1][3231:3200]+deltaWeights_0[3231:3200];
                    BRAM_0[counter_0-1][3263:3232] <= BRAM_0[counter_0-1][3263:3232]+deltaWeights_0[3263:3232];
                    BRAM_0[counter_0-1][3295:3264] <= BRAM_0[counter_0-1][3295:3264]+deltaWeights_0[3295:3264];
                    BRAM_0[counter_0-1][3327:3296] <= BRAM_0[counter_0-1][3327:3296]+deltaWeights_0[3327:3296];
                    BRAM_0[counter_0-1][3359:3328] <= BRAM_0[counter_0-1][3359:3328]+deltaWeights_0[3359:3328];
                    BRAM_0[counter_0-1][3391:3360] <= BRAM_0[counter_0-1][3391:3360]+deltaWeights_0[3391:3360];
                    BRAM_0[counter_0-1][3423:3392] <= BRAM_0[counter_0-1][3423:3392]+deltaWeights_0[3423:3392];
                    BRAM_0[counter_0-1][3455:3424] <= BRAM_0[counter_0-1][3455:3424]+deltaWeights_0[3455:3424];
                    BRAM_0[counter_0-1][3487:3456] <= BRAM_0[counter_0-1][3487:3456]+deltaWeights_0[3487:3456];
                    BRAM_0[counter_0-1][3519:3488] <= BRAM_0[counter_0-1][3519:3488]+deltaWeights_0[3519:3488];
                    BRAM_0[counter_0-1][3551:3520] <= BRAM_0[counter_0-1][3551:3520]+deltaWeights_0[3551:3520];
                    BRAM_0[counter_0-1][3583:3552] <= BRAM_0[counter_0-1][3583:3552]+deltaWeights_0[3583:3552];
                    BRAM_0[counter_0-1][3615:3584] <= BRAM_0[counter_0-1][3615:3584]+deltaWeights_0[3615:3584];
                    BRAM_0[counter_0-1][3647:3616] <= BRAM_0[counter_0-1][3647:3616]+deltaWeights_0[3647:3616];
                    BRAM_0[counter_0-1][3679:3648] <= BRAM_0[counter_0-1][3679:3648]+deltaWeights_0[3679:3648];
                    BRAM_0[counter_0-1][3711:3680] <= BRAM_0[counter_0-1][3711:3680]+deltaWeights_0[3711:3680];
                    BRAM_0[counter_0-1][3743:3712] <= BRAM_0[counter_0-1][3743:3712]+deltaWeights_0[3743:3712];
                    BRAM_0[counter_0-1][3775:3744] <= BRAM_0[counter_0-1][3775:3744]+deltaWeights_0[3775:3744];
                    BRAM_0[counter_0-1][3807:3776] <= BRAM_0[counter_0-1][3807:3776]+deltaWeights_0[3807:3776];
                    BRAM_0[counter_0-1][3839:3808] <= BRAM_0[counter_0-1][3839:3808]+deltaWeights_0[3839:3808];
                    BRAM_0[counter_0-1][3871:3840] <= BRAM_0[counter_0-1][3871:3840]+deltaWeights_0[3871:3840];
                    BRAM_0[counter_0-1][3903:3872] <= BRAM_0[counter_0-1][3903:3872]+deltaWeights_0[3903:3872];
                    BRAM_0[counter_0-1][3935:3904] <= BRAM_0[counter_0-1][3935:3904]+deltaWeights_0[3935:3904];
                    BRAM_0[counter_0-1][3967:3936] <= BRAM_0[counter_0-1][3967:3936]+deltaWeights_0[3967:3936];
                    BRAM_0[counter_0-1][3999:3968] <= BRAM_0[counter_0-1][3999:3968]+deltaWeights_0[3999:3968];
                    BRAM_0[counter_0-1][4031:4000] <= BRAM_0[counter_0-1][4031:4000]+deltaWeights_0[4031:4000];
                    BRAM_0[counter_0-1][4063:4032] <= BRAM_0[counter_0-1][4063:4032]+deltaWeights_0[4063:4032];
                    BRAM_0[counter_0-1][4095:4064] <= BRAM_0[counter_0-1][4095:4064]+deltaWeights_0[4095:4064];
                    counter_0 <= 0;
                    processing_update_0 <= 0;
                end
	        //$display("v[%d] = %h", counter_0-2, BRAM_0[counter_0-2]);
	        //$display("v[%d] = %h", counter_0-1, BRAM_0[counter_0-1]);	       
            end
            else if(update_0) begin // assume that addr and counter are 0!
                processing_update_0 <= 1;
                counter_0 <= counter_0 + 1;
            end
            
            if(processing_update_1) begin
                if (counter_1<128) begin
                    BRAM_1[counter_1-1][31:0] <= BRAM_1[counter_1-1][31:0] + deltaWeights_1[31:0];
                    BRAM_1[counter_1-1][63:32] <= BRAM_1[counter_1-1][63:32] + deltaWeights_1[63:32];
                    BRAM_1[counter_1-1][95:64] <= BRAM_1[counter_1-1][95:64] + deltaWeights_1[95:64];
                    BRAM_1[counter_1-1][127:96] <= BRAM_1[counter_1-1][127:96] + deltaWeights_1[127:96];
                    BRAM_1[counter_1-1][159:128] <= BRAM_1[counter_1-1][159:128] + deltaWeights_1[159:128];
                    BRAM_1[counter_1-1][191:160] <= BRAM_1[counter_1-1][191:160] + deltaWeights_1[191:160];                    
                    BRAM_1[counter_1-1][223:192] <= BRAM_1[counter_1-1][223:192] + deltaWeights_1[223:192];
                    BRAM_1[counter_1-1][255:224] <= BRAM_1[counter_1-1][255:224] + deltaWeights_1[255:224];
                    BRAM_1[counter_1-1][287:256] <= BRAM_1[counter_1-1][287:256] + deltaWeights_1[287:256];                    
                    BRAM_1[counter_1-1][319:288] <= BRAM_1[counter_1-1][319:288] + deltaWeights_1[319:288];
                    counter_1 <= counter_1 + 1;
                end
                else if(counter_1==128) begin
                    BRAM_1[counter_1-1][31:0] <= BRAM_1[counter_1-1][31:0] + deltaWeights_1[31:0];
                    BRAM_1[counter_1-1][63:32] <= BRAM_1[counter_1-1][63:32] + deltaWeights_1[63:32];
                    BRAM_1[counter_1-1][95:64] <= BRAM_1[counter_1-1][95:64] + deltaWeights_1[95:64];
                    BRAM_1[counter_1-1][127:96] <= BRAM_1[counter_1-1][127:96] + deltaWeights_1[127:96];
                    BRAM_1[counter_1-1][159:128] <= BRAM_1[counter_1-1][159:128] + deltaWeights_1[159:128];
                    BRAM_1[counter_1-1][191:160] <= BRAM_1[counter_1-1][191:160] + deltaWeights_1[191:160];                    
                    BRAM_1[counter_1-1][223:192] <= BRAM_1[counter_1-1][223:192] + deltaWeights_1[223:192];
                    BRAM_1[counter_1-1][255:224] <= BRAM_1[counter_1-1][255:224] + deltaWeights_1[255:224];
                    BRAM_1[counter_1-1][287:256] <= BRAM_1[counter_1-1][287:256] + deltaWeights_1[287:256];                    
                    BRAM_1[counter_1-1][319:288] <= BRAM_1[counter_1-1][319:288] + deltaWeights_1[319:288];
                    counter_1 <= 0;
                    processing_update_1 <= 0;
                end
	        //$display("v[%d] = %h", counter_1-2, BRAM_1[counter_1-2]);
	        //$display("v[%d] = %h", counter_1-1, BRAM_1[counter_1-1]);
            end
            else if(update_1) begin // assume that addr and counter are 0!
                processing_update_1 <= 1;
                counter_1 <= counter_1 + 1;
            end
                 
        end
    end

endmodule

/*
module testReg;

    logic clka, rst;
    logic start_0, start_1, update_0, update_1;
    logic [4095:0] values_0, deltaWeights_0;
    logic [319:0] values_1, deltaWeights_1;

    initial begin
        clka = 0;
        forever #2 clka = ~clka;
    end

    integer i;
    weights w(clka, rst, start_0, start_1, update_0, update_1, deltaWeights_0, deltaWeights_1, values_0, values_1);
    
    initial begin
        rst = 0;
        start_0 = 0;
        start_1 = 0;
        update_0 = 0;
        update_1 = 0;
        deltaWeights_0 = 0;
        deltaWeights_1 = 0;
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
        $display("values_0=%x",values_0);
        $display("values_1=%x",values_1);
        $display("------------------------------");
        @(posedge clka); // 1
        start_0 = 0;
        $display("values_0=%x",values_0);
        $display("values_1=%x",values_1);
        $display("------------------------------");
        @(posedge clka); // 2
        $display("values_0=%x",values_0);
        $display("values_1=%x",values_1);
        $display("------------------------------");
        @(posedge clka); // 3
        $display("values_0=%x",values_0);
        $display("values_1=%x",values_1);
        $display("------------------------------");
        for(i=0;i<780;i=i+1) begin
            @(posedge clka);
        end
        $display("values_0=%x",values_0);
        $display("values_1=%x",values_1);
        $display("------------------------------");
        @(posedge clka); // 784
        $display("values_0=%x",values_0);
        $display("values_1=%x",values_1);
        $display("------------------------------");
        @(posedge clka); // 785
        // done
        $display("values_0=%x",values_0);
        $display("values_1=%x",values_1);
        $display("------------------------------");
        $display("\n");
        @(posedge clka);
        $display("values_0=%x",values_0);
        $display("values_1=%x",values_1);
        $display("------------------------------");
        $display("\n");
        @(posedge clka);
        start_1 = 1;
        $display("start_1\n");
        $display("values_0=%x",values_0);
        $display("values_1=%x",values_1);
        $display("------------------------------");
        @(posedge clka); // 1
        $display("values_0=%x",values_0);
        $display("values_1=%x",values_1);
        $display("------------------------------");
        start_1 = 0;
        @(posedge clka); // 2
        $display("values_0=%x",values_0);
        $display("values_1=%x",values_1);
        $display("------------------------------");
        @(posedge clka); // 3
        for(i=0;i<125;i=i+1) begin
            @(posedge clka);
        end
        $display("values_0=%x",values_0);
        $display("values_1=%x",values_1);
        $display("------------------------------");
        @(posedge clka); // 129
        $display("values_0=%x",values_0);
        $display("values_1=%x",values_1);
        $display("------------------------------");
        @(posedge clka);
        $display("values_0=%x",values_0);
        $display("values_1=%x",values_1);
        $display("------------------------------");
        $display("\n");
        @(posedge clka);
        @(posedge clka);
        @(posedge clka);
        deltaWeights_0 = 4096'h0000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001;
        @(posedge clka);
        update_1 = 1;
        @(posedge clka);
        update_1 = 0;
        deltaWeights_1 = 320'h00000001000000010000000100000001000000010000000100000001000000010000000100000001;
        @(posedge clka);
        deltaWeights_1 = 320'h00000002000000020000000200000002000000020000000200000002000000020000000200000002;
        @(posedge clka);
        deltaWeights_1 = 320'h00000003000000030000000300000003000000030000000300000003000000030000000300000003;
        @(posedge clka);
        deltaWeights_1 = 320'h00000004000000040000000400000004000000040000000400000004000000040000000400000004;
        @(posedge clka);
        for(i=0;i<130;i=i+1) begin
            @(posedge clka);
        end
        @(posedge clka);
        @(posedge clka);
        @(posedge clka);
        start_1 = 1;
        @(posedge clka);
        start_1 = 0;
        @(posedge clka);
        for(i=0;i<130;i=i+1) begin
            @(posedge clka);
        end
        @(posedge clka);
        @(posedge clka);
        @(posedge clka);
        @(posedge clka);
        update_0 = 1;
        @(posedge clka);
        update_0 = 0;
        for(i=0;i<790;i=i+1) begin
            @(posedge clka);
        end
        @(posedge clka);
        @(posedge clka);
        @(posedge clka);
        @(posedge clka);
        start_0 = 1;
        @(posedge clka);
        start_0 = 0;
        for(i=0;i<790;i=i+1) begin
            @(posedge clka);
        end
        @(posedge clka);
        @(posedge clka);
        
        $finish;
    end
endmodule
*/
