`define START 8'hff
`define TRAIN 8'hf0
`define TEST  8'h0f
`define STOP  8'hbb

module top;

    // Inputs
    logic uart_sampling_clk, rst, data_rdy; 
    logic [7:0] uart_byte;
    // Outputs
    logic start, train, resend;
    logic [7:0] label;
    logic [31:0] image;

    uart_protocol #(32) dut(.*);
    
    initial begin
        $monitor($stime,, "\n \
        Inputs:\n \
        ubyte: %h drdy: %h, shift: %h, resent: %h\n \
        Outputs: \n \
        start: %h, train: %h, resend: %h, label: %h, image: %h, cs: %s, ns: %s\n",
        uart_byte, data_rdy, dut.shift, dut.resent, start, train, resend, label, 
        image, dut.cs, dut.ns);

        uart_sampling_clk = 0;
        rst = 1;
        rst <= #5 0; 
        forever #100 uart_sampling_clk = ~uart_sampling_clk;
    end

    initial begin
        data_rdy = 0;
        uart_byte = 8'h0; 
        @(posedge uart_sampling_clk);
        uart_byte = `START;
        @(posedge uart_sampling_clk);
        data_rdy = 1;
        @(posedge uart_sampling_clk);
        data_rdy = 0;
        @(posedge uart_sampling_clk);
        data_rdy = 1;
        uart_byte = `TRAIN;
        @(posedge uart_sampling_clk);
        // Data
        data_rdy = 1;
        uart_byte = 8'h01;
        @(posedge uart_sampling_clk);
        // Data
        data_rdy = 1;
        uart_byte = 8'h02;
        @(posedge uart_sampling_clk);
        // Data
        data_rdy = 1;
        uart_byte = 8'h03;
        @(posedge uart_sampling_clk);
        // Data
        data_rdy = 1;
        uart_byte = 8'h04;
        @(posedge uart_sampling_clk);
        // Label 
        data_rdy = 1;
        uart_byte = 8'h02;
        @(posedge uart_sampling_clk);
        // Checksum 
        data_rdy = 1;
        uart_byte = 8'h0b; // Correct is 8'h0c
        @(posedge uart_sampling_clk);
        data_rdy = 1;
        uart_byte = `STOP;
        @(posedge uart_sampling_clk);
        @(posedge uart_sampling_clk);
        @(posedge uart_sampling_clk);
        data_rdy = 1;
        uart_byte = `START;
        @(posedge uart_sampling_clk);
        data_rdy = 1;
        uart_byte = `TRAIN;
        @(posedge uart_sampling_clk);
        // Data
        data_rdy = 1;
        uart_byte = 8'h01;
        @(posedge uart_sampling_clk);
        // Data
        data_rdy = 1;
        uart_byte = 8'h02;
        @(posedge uart_sampling_clk);
        // Data
        data_rdy = 1;
        uart_byte = 8'h03;
        @(posedge uart_sampling_clk);
        // Data
        data_rdy = 1;
        uart_byte = 8'h04;
        @(posedge uart_sampling_clk);
        // Label 
        data_rdy = 1;
        uart_byte = 8'h02;
        @(posedge uart_sampling_clk);
        // Checksum 
        data_rdy = 1;
        uart_byte = 8'h0a; // Still wrong, shouldn't resend
        @(posedge uart_sampling_clk);
        data_rdy = 1;
        uart_byte = `STOP;
        @(posedge uart_sampling_clk);
        data_rdy = 0;
        uart_byte = 8'h0;
        @(posedge uart_sampling_clk);
        @(posedge uart_sampling_clk);
        @(posedge uart_sampling_clk);
        @(posedge uart_sampling_clk);
        #10 $finish;
    end

endmodule: top
