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
    logic        bp_done, fp_done, drawn;
    logic [7:0]  label_in;
    logic [31:0] image_in;
    // Outputs
    logic        do_fp, do_bp, draw;
    logic [7:0]  label_out;
    logic [31:0] image_out;
    
    control_unit #(32) dut(.clk(clk), .rst(rst), .train(train), .start(start), 
                               .bp_done(bp_done), .fp_done(fp_done), .drawn(drawn),
                               .label_in(label_in), .image_in(image_in), .do_fp(do_fp), .do_bp(do_bp), 
                               .draw(draw), .label_out(label_out), .image_out(image_out));

    initial begin
        $monitor($stime,, "\n \
        Inputs:\n \
        train: %h, start: %h, bp_done: %h, fp_done: %h, drawn: %h, image: %h, label_in: %h\n \
        Outputs: \n \
        do_fp: %h, do_bp: %h, draw: %h, label_out: %h, image_out: %h, cs: %s, ns: %s, tr: %h, st: %h\n",
        train, start, bp_done, fp_done, drawn, image_in, label_in,
        do_fp, do_bp, draw, label_out, image_out, dut.cs, dut.ns, dut.train_reg, dut.started);

        clk = 0;
        rst = 1;
        rst <= #5 0; 
        forever #10 clk = ~clk;
    end

    initial begin
        train = 0;
        start = 0;
        bp_done = 0;
        fp_done = 0;
        drawn = 0;
        label_in = 8'd4;
        image_in = 'hdeadbeef;
        @(posedge clk);
        @(posedge clk);
        start = 1;
        @(posedge clk);
        @(posedge clk);
        fp_done = 1;
        @(posedge clk);
        fp_done = 0;
        drawn = 1; 
        @(posedge clk);
        start = 1;
        train = 1;
        @(posedge clk);
        start = 0;
        train = 0;
        @(posedge clk);
        fp_done = 1;
        @(posedge clk);
        bp_done = 1;
        @(posedge clk);
        @(posedge clk);
        #10 $finish;
    end

endmodule: top
