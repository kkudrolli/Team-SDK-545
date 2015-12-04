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
    logic [783:0] [4095:0] BRAM_0;
    // 32 x 10, 128 cycles
    logic [127:0] [319:0] BRAM_1;
    
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
                    BRAM_0[counter_0-1] <= BRAM_0[counter_0-1] + deltaWeights_0;
                    counter_0 <= counter_0 + 1;
                end
                else if(counter_0==784) begin
                    BRAM_0[counter_0-1] <= BRAM_0[counter_0-1] + deltaWeights_0;
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
                    BRAM_1[counter_1-1] <= BRAM_1[counter_1-1] + deltaWeights_1;
                    counter_1 <= counter_1 + 1;
                end
                else if(counter_1==128) begin
                    BRAM_1[counter_1-1] <= BRAM_1[counter_1-1] + deltaWeights_1;
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
