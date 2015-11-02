/**
 * weight for forward propagation testing
 * start_0 or start_1 should be asserted for one cycle only
 */
module weight(input clka, rst,
              input start_0, start_1,
              output logic [127:0] [31:0] values_0,
              output logic [9:0] [31:0] values_1);
    
    logic processing_0, processing_1;
    logic [9:0] counter_0;
    logic [6:0] counter_1;
 
   
    //32 x 128, for 784 cycles
    logic [783:0] [127:0] [31:0] douta_0;
    logic [783:0] [127:0] [31:0] dina_0;
   
    // 32 x 10, 128 cycles
    logic [127:0] [9:0] [31:0] 	 dina_1;
    logic [127:0] [9:0] [31:0] 	 douta_1;

    integer i,j;
    // READING
    always_ff @(posedge clka or posedge rst) begin
        if(rst) begin
            values_0 <= 0;
            values_1 <= 0;
            counter_0 <= 0;
            counter_1 <= 0;
            processing_0 <= 0;
            processing_1 <= 0;
            // initialize for the purpose of testing
            for(j=0;j<784;j=j+1) begin
                for(i=0;i<128;i=i+1) begin
                    douta_0[j][i] <= 1520;
                end
            end
            // initialize for the purpose of testing
            for(j=0;j<128;j=j+1) begin
                for(i=0;i<10;i=i+1) begin
                    douta_1[j][i] <= 320;
                end
            end
        end
        else begin
            if(processing_0) begin // processing weight request for layer 0, 784 cycles long
                if (counter_0<784) begin
                    counter_0 <= counter_0 + 1;
                    for(i=0;i<128;i=i+1) begin
                       values_0[i] <= douta_0[counter_0][i];
                    end
                    if(counter_0==783) begin
                        counter_0 <= 0;
                        processing_0 <= 0;
                    end
                end
            end
            else if(start_0) begin // weight values for layer 0 request, asserted for one cycle
                processing_0 <= 1;
                counter_0 <= counter_0 + 1;
                for(i=0;i<128;i=i+1) begin
                   values_0[i] <= douta_0[counter_0][i];
                end
            end

            if(processing_1) begin // processing weight request for layer 1, 128 cycles long
                if (counter_1<128) begin
                    counter_1 <= counter_1 + 1;
                    for(i=0;i<10;i=i+1) begin
                        values_1[i] <= douta_1[counter_1][i];
                    end
                    if(counter_1==127) begin
                        counter_1 <= 0;
                        processing_1 <= 0;
                    end
                end
            end
            else if(start_1) begin // weight values for layer 1 request, asserted for one cycle
                if (counter_1<128) begin
                    counter_1 <= counter_1 + 1;
                    for(i=0;i<10;i=i+1) begin
                        values_1[i] <= douta_1[counter_1][i];
                    end
                end
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
        forever #1 clka = ~clka;
    end

    integer i;
    weight w(clka, rst, start_0, start_1, values_0, values_1);

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
        @(posedge clka);
        start_0 = 0;
        @(posedge clka);
        @(posedge clka);
        @(posedge clka);
        $display("values_0[125]=%d",values_0[125]);
        $display("values_0[20]=%d",values_0[20]);
        $display("values_1[5]=%d",values_1[5]);
        for(i=0;i<790;i=i+1) begin
            @(posedge clka);
        end
        $display("values_0[125]=%d",values_0[125]);
        $display("values_0[20]=%d",values_0[20]);
        $display("values_1[5]=%d",values_1[5]);
        start_1 = 1;
        @(posedge clka);
        start_1 = 0;
        @(posedge clka);
        @(posedge clka);
        $display("values_0[125]=%d",values_0[125]);
        $display("values_0[20]=%d",values_0[20]);
        $display("values_1[5]=%d",values_1[5]);
        for(i=0;i<10;i=i+1) begin
            @(posedge clka);
        end
        @(posedge clka);
        $display("values_0[125]=%d",values_0[125]);
        $display("values_0[20]=%d",values_0[20]);
        $display("values_1[5]=%d",values_1[5]);
        @(posedge clka);
        $finish;
    end

endmodule
*/
