module top;

    // Inputs
    logic clk, uart_sampling_clk, rst; 
    logic ack;
    // Outputs
    logic ack_out;

    uart_clock_divider div (.*);
    control_trans_synch dut (.*);
    
    initial begin
        $monitor($stime,, "\n \
        Inputs:\n \
        ack: %h, ack_mid: %h \n \
        Outputs: \n \
        ack_out: %h, cs: %s, ns: %s\n",
        ack, dut.ack_mid, ack_out, dut.cs, dut.ns);

        clk = 0;
        rst = 1;
        rst <= #5 0; 
        forever #100 clk = ~clk;
    end

    initial begin
        ack = 1;
        @(posedge clk);
        ack = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        ack = 1;
        @(posedge clk);
        ack = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #10 $finish;
    end

endmodule: top
