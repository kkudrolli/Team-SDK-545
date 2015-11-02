module top;

    logic clk, uart_sampling_clk, rst; 
    logic start, train, start_out, train_out;
    logic [7:0] label, label_out;
    logic [31:0] image, image_out;

    uart_clock_divider div (.*);
    uart_control_synch #(32) dut (.*);
    
    initial begin
        $monitor($stime,, "\n \
        Inputs:\n \
        start: %h, train: %h, label: %h, image: %h \n \
        Outputs: \n \
        start_out: %h, train_out: %h, label_out: %h, image_out: %h\n",
        start, train, label, image, start_out, train_out, label_out, image_out);

        clk = 0;
        rst = 1;
        rst <= #5 0; 
        forever #100 clk = ~clk;
    end

    initial begin
        start = 1;
        train = 1;
        label = 8'd4;
        image = 'hdeadbeef;
        @(posedge uart_sampling_clk);
        @(posedge uart_sampling_clk);
        @(posedge uart_sampling_clk);
        @(posedge uart_sampling_clk);
        @(posedge uart_sampling_clk);
        @(posedge uart_sampling_clk);
        @(posedge uart_sampling_clk);
        @(posedge uart_sampling_clk);
        @(posedge uart_sampling_clk);
        @(posedge uart_sampling_clk);
        @(posedge uart_sampling_clk);
        @(posedge uart_sampling_clk);
        @(posedge uart_sampling_clk);
        @(posedge clk);
        start = 0;
        train = 0;
        label = 8'd0;
        image = 'h0;
        @(posedge clk);
        #10 $finish;
    end

endmodule: top
