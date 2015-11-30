`timescale 1ns / 1ps

module weights(input clka, rst,
              input start_0, start_1,
              output logic [4095:0] values_0,
              output logic [319:0] values_1);
    
    logic [9:0] addra_0;
    logic [6:0] addra_1;
    logic [0:0] wea_0, wea_1;
    
    logic processing_0, processingPrev_0, processing_1, processingPrev_1;
    logic [9:0] counter_0;
    logic [7:0] counter_1;
    
    logic [4095:0] dina_0;
    logic [4095:0] douta_0;    

    logic [319:0] dina_1;
    logic [319:0] douta_1;


    // 4096 bits at a time
    weights_0_wrapper w0(.BRAM_PORTA_addr(addra_0),
                        .BRAM_PORTA_clk(clka),
                        .BRAM_PORTA_din(4096'b0),
                        .BRAM_PORTA_dout(douta_0),
                        .BRAM_PORTA_we(1'b0));
    // 320 bits at a time
    weights_1_wrapper w1(.BRAM_PORTA_addr(addra_1),
                        .BRAM_PORTA_clk(clka),
                        .BRAM_PORTA_din(4096'b0),
                        .BRAM_PORTA_dout(douta_1),
                        .BRAM_PORTA_we(1'b0));

    always_ff @(posedge clka, posedge rst) begin // processingPrev is the value of processing signal one cycle before
        if (rst) begin
            processingPrev_0 <= 1'b0;
            processingPrev_1 <= 1'b0;
        end else begin
            processingPrev_0 <= processing_0;
            processingPrev_1 <= processing_1;
        end
    end

    integer i;
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

    // READING
    always_ff @(posedge clka, posedge rst) begin
        if(rst) begin
            addra_0 <= 0;
            addra_1 <= 0;
            counter_0 <= 0;
            counter_1 <= 0;
            processing_0 <= 0;
            processing_1 <= 0;
        end
        else begin
            if(processing_0) begin // processing weight request for layer 0, 784 cycles long
                if (counter_0 < 784) begin
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
                if (counter_1 < 128) begin
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
    logic [4095:0] values_0;
    logic [319:0] values_1;

    initial begin
        clka = 0;
        forever #2 clka = ~clka;
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
        $finish;
    end
endmodule
*/