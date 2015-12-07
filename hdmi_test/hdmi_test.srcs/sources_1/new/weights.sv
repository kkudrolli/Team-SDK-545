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
    
    logic [9:0] addra_0,addra_0_write;
    logic [6:0] addra_1,addra_1_write;
    
    logic processing_0, processingPrev_0, processing_1, processingPrev_1, 
          processing_update_0, processing_updatePrev_0, processing_update_1, processing_updatePrev_1;
    logic [9:0] counter_0;
    logic [7:0] counter_1;
    
    logic [4095:0] douta_0, dina_0, douta_notUsed_0;
    logic [319:0] douta_1, dina_1, douta_notUsed_1;
  
    weights_0_wrapper w0(.BRAM_PORTA_addr(addra_0),.BRAM_PORTA_clk(clka),.BRAM_PORTA_din(4096'b0),.BRAM_PORTA_dout(douta_0),.BRAM_PORTA_we(1'b0), //  reading port
                        .BRAM_PORTB_addr(addra_0_write),.BRAM_PORTB_clk(clka),.BRAM_PORTB_din(dina_0),.BRAM_PORTB_dout(douta_0_notUsed),.BRAM_PORTB_we(processing_updatePrev_0)); // writing port

    weights_1_wrapper w1(.BRAM_PORTA_addr(addra_1),.BRAM_PORTA_clk(clka),.BRAM_PORTA_din(320'b0),.BRAM_PORTA_dout(douta_1),.BRAM_PORTA_we(1'b0), // reading port
                        .BRAM_PORTB_addr(addra_1_write),.BRAM_PORTB_clk(clka),.BRAM_PORTB_din(dina_1),.BRAM_PORTB_dout(douta_1_notUsed),.BRAM_PORTB_we(processing_updatePrev_1)); // writing port

    always_ff @(posedge clka) begin // processingPrev is the value of processing signal one cycle before
        processingPrev_0 <= processing_0;
        processingPrev_1 <= processing_1;
        processing_updatePrev_0 <= processing_update_0;
        addra_0_write <= addra_0;
        processing_updatePrev_1 <= processing_update_1;
        addra_1_write <= addra_1;
    end

    // output logic
    always_comb begin
        if(processingPrev_0) begin
            values_0 = douta_0;
        end
        else begin
            values_0 = 0;
        end
        if(processingPrev_1) begin
            values_1 = douta_1;
        end
        else begin
            values_1 = 0;
        end
    end
    
    always_comb begin
        if(processing_updatePrev_0) begin
            dina_0[31:0] = douta_0[31:0]+deltaWeights_0[31:0];
            dina_0[63:32] = douta_0[63:32]+deltaWeights_0[63:32];
            dina_0[95:64] = douta_0[95:64]+deltaWeights_0[95:64];
            dina_0[127:96] = douta_0[127:96]+deltaWeights_0[127:96];
            dina_0[159:128] = douta_0[159:128]+deltaWeights_0[159:128];
            dina_0[191:160] = douta_0[191:160]+deltaWeights_0[191:160];
            dina_0[223:192] = douta_0[223:192]+deltaWeights_0[223:192];
            dina_0[255:224] = douta_0[255:224]+deltaWeights_0[255:224];
            dina_0[287:256] = douta_0[287:256]+deltaWeights_0[287:256];
            dina_0[319:288] = douta_0[319:288]+deltaWeights_0[319:288];
            dina_0[351:320] = douta_0[351:320]+deltaWeights_0[351:320];
            dina_0[383:352] = douta_0[383:352]+deltaWeights_0[383:352];
            dina_0[415:384] = douta_0[415:384]+deltaWeights_0[415:384];
            dina_0[447:416] = douta_0[447:416]+deltaWeights_0[447:416];
            dina_0[479:448] = douta_0[479:448]+deltaWeights_0[479:448];
            dina_0[511:480] = douta_0[511:480]+deltaWeights_0[511:480];
            dina_0[543:512] = douta_0[543:512]+deltaWeights_0[543:512];
            dina_0[575:544] = douta_0[575:544]+deltaWeights_0[575:544];
            dina_0[607:576] = douta_0[607:576]+deltaWeights_0[607:576];
            dina_0[639:608] = douta_0[639:608]+deltaWeights_0[639:608];
            dina_0[671:640] = douta_0[671:640]+deltaWeights_0[671:640];
            dina_0[703:672] = douta_0[703:672]+deltaWeights_0[703:672];
            dina_0[735:704] = douta_0[735:704]+deltaWeights_0[735:704];
            dina_0[767:736] = douta_0[767:736]+deltaWeights_0[767:736];
            dina_0[799:768] = douta_0[799:768]+deltaWeights_0[799:768];
            dina_0[831:800] = douta_0[831:800]+deltaWeights_0[831:800];
            dina_0[863:832] = douta_0[863:832]+deltaWeights_0[863:832];
            dina_0[895:864] = douta_0[895:864]+deltaWeights_0[895:864];
            dina_0[927:896] = douta_0[927:896]+deltaWeights_0[927:896];
            dina_0[959:928] = douta_0[959:928]+deltaWeights_0[959:928];
            dina_0[991:960] = douta_0[991:960]+deltaWeights_0[991:960];
            dina_0[1023:992] = douta_0[1023:992]+deltaWeights_0[1023:992];
            dina_0[1055:1024] = douta_0[1055:1024]+deltaWeights_0[1055:1024];
            dina_0[1087:1056] = douta_0[1087:1056]+deltaWeights_0[1087:1056];
            dina_0[1119:1088] = douta_0[1119:1088]+deltaWeights_0[1119:1088];
            dina_0[1151:1120] = douta_0[1151:1120]+deltaWeights_0[1151:1120];
            dina_0[1183:1152] = douta_0[1183:1152]+deltaWeights_0[1183:1152];
            dina_0[1215:1184] = douta_0[1215:1184]+deltaWeights_0[1215:1184];
            dina_0[1247:1216] = douta_0[1247:1216]+deltaWeights_0[1247:1216];
            dina_0[1279:1248] = douta_0[1279:1248]+deltaWeights_0[1279:1248];
            dina_0[1311:1280] = douta_0[1311:1280]+deltaWeights_0[1311:1280];
            dina_0[1343:1312] = douta_0[1343:1312]+deltaWeights_0[1343:1312];
            dina_0[1375:1344] = douta_0[1375:1344]+deltaWeights_0[1375:1344];
            dina_0[1407:1376] = douta_0[1407:1376]+deltaWeights_0[1407:1376];
            dina_0[1439:1408] = douta_0[1439:1408]+deltaWeights_0[1439:1408];
            dina_0[1471:1440] = douta_0[1471:1440]+deltaWeights_0[1471:1440];
            dina_0[1503:1472] = douta_0[1503:1472]+deltaWeights_0[1503:1472];
            dina_0[1535:1504] = douta_0[1535:1504]+deltaWeights_0[1535:1504];
            dina_0[1567:1536] = douta_0[1567:1536]+deltaWeights_0[1567:1536];
            dina_0[1599:1568] = douta_0[1599:1568]+deltaWeights_0[1599:1568];
            dina_0[1631:1600] = douta_0[1631:1600]+deltaWeights_0[1631:1600];
            dina_0[1663:1632] = douta_0[1663:1632]+deltaWeights_0[1663:1632];
            dina_0[1695:1664] = douta_0[1695:1664]+deltaWeights_0[1695:1664];
            dina_0[1727:1696] = douta_0[1727:1696]+deltaWeights_0[1727:1696];
            dina_0[1759:1728] = douta_0[1759:1728]+deltaWeights_0[1759:1728];
            dina_0[1791:1760] = douta_0[1791:1760]+deltaWeights_0[1791:1760];
            dina_0[1823:1792] = douta_0[1823:1792]+deltaWeights_0[1823:1792];
            dina_0[1855:1824] = douta_0[1855:1824]+deltaWeights_0[1855:1824];
            dina_0[1887:1856] = douta_0[1887:1856]+deltaWeights_0[1887:1856];
            dina_0[1919:1888] = douta_0[1919:1888]+deltaWeights_0[1919:1888];
            dina_0[1951:1920] = douta_0[1951:1920]+deltaWeights_0[1951:1920];
            dina_0[1983:1952] = douta_0[1983:1952]+deltaWeights_0[1983:1952];
            dina_0[2015:1984] = douta_0[2015:1984]+deltaWeights_0[2015:1984];
            dina_0[2047:2016] = douta_0[2047:2016]+deltaWeights_0[2047:2016];
            dina_0[2079:2048] = douta_0[2079:2048]+deltaWeights_0[2079:2048];
            dina_0[2111:2080] = douta_0[2111:2080]+deltaWeights_0[2111:2080];
            dina_0[2143:2112] = douta_0[2143:2112]+deltaWeights_0[2143:2112];
            dina_0[2175:2144] = douta_0[2175:2144]+deltaWeights_0[2175:2144];
            dina_0[2207:2176] = douta_0[2207:2176]+deltaWeights_0[2207:2176];
            dina_0[2239:2208] = douta_0[2239:2208]+deltaWeights_0[2239:2208];
            dina_0[2271:2240] = douta_0[2271:2240]+deltaWeights_0[2271:2240];
            dina_0[2303:2272] = douta_0[2303:2272]+deltaWeights_0[2303:2272];
            dina_0[2335:2304] = douta_0[2335:2304]+deltaWeights_0[2335:2304];
            dina_0[2367:2336] = douta_0[2367:2336]+deltaWeights_0[2367:2336];
            dina_0[2399:2368] = douta_0[2399:2368]+deltaWeights_0[2399:2368];
            dina_0[2431:2400] = douta_0[2431:2400]+deltaWeights_0[2431:2400];
            dina_0[2463:2432] = douta_0[2463:2432]+deltaWeights_0[2463:2432];
            dina_0[2495:2464] = douta_0[2495:2464]+deltaWeights_0[2495:2464];
            dina_0[2527:2496] = douta_0[2527:2496]+deltaWeights_0[2527:2496];
            dina_0[2559:2528] = douta_0[2559:2528]+deltaWeights_0[2559:2528];
            dina_0[2591:2560] = douta_0[2591:2560]+deltaWeights_0[2591:2560];
            dina_0[2623:2592] = douta_0[2623:2592]+deltaWeights_0[2623:2592];
            dina_0[2655:2624] = douta_0[2655:2624]+deltaWeights_0[2655:2624];
            dina_0[2687:2656] = douta_0[2687:2656]+deltaWeights_0[2687:2656];
            dina_0[2719:2688] = douta_0[2719:2688]+deltaWeights_0[2719:2688];
            dina_0[2751:2720] = douta_0[2751:2720]+deltaWeights_0[2751:2720];
            dina_0[2783:2752] = douta_0[2783:2752]+deltaWeights_0[2783:2752];
            dina_0[2815:2784] = douta_0[2815:2784]+deltaWeights_0[2815:2784];
            dina_0[2847:2816] = douta_0[2847:2816]+deltaWeights_0[2847:2816];
            dina_0[2879:2848] = douta_0[2879:2848]+deltaWeights_0[2879:2848];
            dina_0[2911:2880] = douta_0[2911:2880]+deltaWeights_0[2911:2880];
            dina_0[2943:2912] = douta_0[2943:2912]+deltaWeights_0[2943:2912];
            dina_0[2975:2944] = douta_0[2975:2944]+deltaWeights_0[2975:2944];
            dina_0[3007:2976] = douta_0[3007:2976]+deltaWeights_0[3007:2976];
            dina_0[3039:3008] = douta_0[3039:3008]+deltaWeights_0[3039:3008];
            dina_0[3071:3040] = douta_0[3071:3040]+deltaWeights_0[3071:3040];
            dina_0[3103:3072] = douta_0[3103:3072]+deltaWeights_0[3103:3072];
            dina_0[3135:3104] = douta_0[3135:3104]+deltaWeights_0[3135:3104];
            dina_0[3167:3136] = douta_0[3167:3136]+deltaWeights_0[3167:3136];
            dina_0[3199:3168] = douta_0[3199:3168]+deltaWeights_0[3199:3168];
            dina_0[3231:3200] = douta_0[3231:3200]+deltaWeights_0[3231:3200];
            dina_0[3263:3232] = douta_0[3263:3232]+deltaWeights_0[3263:3232];
            dina_0[3295:3264] = douta_0[3295:3264]+deltaWeights_0[3295:3264];
            dina_0[3327:3296] = douta_0[3327:3296]+deltaWeights_0[3327:3296];
            dina_0[3359:3328] = douta_0[3359:3328]+deltaWeights_0[3359:3328];
            dina_0[3391:3360] = douta_0[3391:3360]+deltaWeights_0[3391:3360];
            dina_0[3423:3392] = douta_0[3423:3392]+deltaWeights_0[3423:3392];
            dina_0[3455:3424] = douta_0[3455:3424]+deltaWeights_0[3455:3424];
            dina_0[3487:3456] = douta_0[3487:3456]+deltaWeights_0[3487:3456];
            dina_0[3519:3488] = douta_0[3519:3488]+deltaWeights_0[3519:3488];
            dina_0[3551:3520] = douta_0[3551:3520]+deltaWeights_0[3551:3520];
            dina_0[3583:3552] = douta_0[3583:3552]+deltaWeights_0[3583:3552];
            dina_0[3615:3584] = douta_0[3615:3584]+deltaWeights_0[3615:3584];
            dina_0[3647:3616] = douta_0[3647:3616]+deltaWeights_0[3647:3616];
            dina_0[3679:3648] = douta_0[3679:3648]+deltaWeights_0[3679:3648];
            dina_0[3711:3680] = douta_0[3711:3680]+deltaWeights_0[3711:3680];
            dina_0[3743:3712] = douta_0[3743:3712]+deltaWeights_0[3743:3712];
            dina_0[3775:3744] = douta_0[3775:3744]+deltaWeights_0[3775:3744];
            dina_0[3807:3776] = douta_0[3807:3776]+deltaWeights_0[3807:3776];
            dina_0[3839:3808] = douta_0[3839:3808]+deltaWeights_0[3839:3808];
            dina_0[3871:3840] = douta_0[3871:3840]+deltaWeights_0[3871:3840];
            dina_0[3903:3872] = douta_0[3903:3872]+deltaWeights_0[3903:3872];
            dina_0[3935:3904] = douta_0[3935:3904]+deltaWeights_0[3935:3904];
            dina_0[3967:3936] = douta_0[3967:3936]+deltaWeights_0[3967:3936];
            dina_0[3999:3968] = douta_0[3999:3968]+deltaWeights_0[3999:3968];
            dina_0[4031:4000] = douta_0[4031:4000]+deltaWeights_0[4031:4000];
            dina_0[4063:4032] = douta_0[4063:4032]+deltaWeights_0[4063:4032];
            dina_0[4095:4064] = douta_0[4095:4064]+deltaWeights_0[4095:4064];
        end
        else begin
            dina_0 <= 0;
        end
        
        if(processing_updatePrev_1) begin
            dina_1[31:0] = douta_1[31:0]+deltaWeights_1[31:0];
            dina_1[63:32] = douta_1[63:32]+deltaWeights_1[63:32];
            dina_1[95:64] = douta_1[95:64]+deltaWeights_1[95:64];
            dina_1[127:96] = douta_1[127:96]+deltaWeights_1[127:96];
            dina_1[159:128] = douta_1[159:128]+deltaWeights_1[159:128];
            dina_1[191:160] = douta_1[191:160]+deltaWeights_1[191:160];
            dina_1[223:192] = douta_1[223:192]+deltaWeights_1[223:192];
            dina_1[255:224] = douta_1[255:224]+deltaWeights_1[255:224];
            dina_1[287:256] = douta_1[287:256]+deltaWeights_1[287:256];
            dina_1[319:288] = douta_1[319:288]+deltaWeights_1[319:288];
        end
        else begin
            dina_1 <= 0;
        end
    end

    // READING
    always_ff @(posedge clka or posedge rst) begin
        if(rst) begin
            addra_0 <= 0;
            addra_1 <= 0;
            counter_0 <= 0;
            counter_1 <= 0;
            processing_0 <= 0;
            processing_1 <= 0;
            processing_update_0 <= 0;
            processing_update_1 <= 0;
        end
        else begin
            /////////////
            // READING //
            /////////////
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
            
            //////////////
            // UPDATING //
            //////////////
            if(processing_update_0) begin
                if (counter_0<784) begin
                    addra_0 <= addra_0 + 1;
                    counter_0 <= counter_0 + 1;
                end
                else if(counter_0==784) begin
                    addra_0 <= 0;
                    counter_0 <= 0;
                    processing_update_0 <= 0;
                end
            end
            else if(update_0) begin // assume that addr and counter are 0!
                processing_update_0 <= 1;
                counter_0 <= counter_0 + 1;
            end
            
            if(processing_update_1) begin
                if (counter_1<128) begin
                    addra_1 <= addra_1 + 1;
                    counter_1 <= counter_1 + 1;
                end
                else if(counter_1==128) begin
                    addra_1 <= 0;
                    counter_1 <= 0;
                    processing_update_1 <= 0;
                end            
            end
            else if(update_1) begin // assume that addr and counter are 0!
                processing_update_1 <= 1;
                counter_1 <= counter_1 + 1;
            end
        end
    end

endmodule

/*
module test;

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