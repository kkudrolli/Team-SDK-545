// 
// control_unit_tb.sv
//
// Author: Kais Kudrolli
//
// Description: Testbench fro control unit module for neural network.
//

module top;

    // Inputs
    logic        clk, rst, train, start; 
    logic        weights_ack, bp_done, fp_done, drawn;
    logic [31:0] image_in;
    // Outputs
    logic        get_all_weights, do_fp, do_bp, draw;
    logic [31:0] image_out;
    
    control_unit #(32) dut(clk, rst, train, start, 
                           weights_ack, bp_done, fp_done, drawn,
                           image_in, get_all_weights, do_fp, do_bp, 
                           draw, image_out);

    initial begin
        $monitor($stime,, "\n \
        Inputs:\n \
        train: %h, start: %h, weights_ack: %h, bp_done: %h, fp_done: %h, drawn: %h, image: %h \n \
        Outputs: \n \
        get_all_w: %h, do_fp: %h, do_bp: %h, draw: %h, image_out: %h, cs: %s, ns: %s\n",
        train, start, weights_ack, bp_done, fp_done, drawn, image_in, 
        get_all_weights, do_fp, do_bp, draw, image_out, dut.cs, dut.ns);

        clk = 0;
        rst = 1;
        rst <= #5 0; 
        forever #10 clk = ~clk;
    end

    initial begin
        train = 0;
        start = 0;
        weights_ack = 0;
        bp_done = 0;
        fp_done = 0;
        drawn = 0;
        image_in = 'hdeadbeef;
        @(posedge clk);
        @(posedge clk);
        start = 1;
        @(posedge clk);
        weights_ack = 1;
        @(posedge clk);
        weights_ack = 0;
        @(posedge clk);
        @(posedge clk);
        fp_done = 1;
        @(posedge clk);
        fp_done = 0;
        drawn = 1; 
        @(posedge clk);
        start = 1;
        @(posedge clk);
        weights_ack = 1;
        @(posedge clk);
        start = 0;
        weights_ack = 0;
        train = 1;
        @(posedge clk);
        fp_done = 1;
        @(posedge clk);
        bp_done = 1;
        @(posedge clk);
        @(posedge clk);
        #10 $finish;
    end

endmodule: top
