
module top;

    integer IMG_SZ = 32;

    // Inputs
    logic              clk, rst_l, train, start, 
    logic              weights_ack, bp_done, fp_done, drawn,
    logic [IMG_SZ-1:0] image_in,
    // Outputs
    logic              get_all_weights, do_fp, do_bp, draw,
    logic [IMG_SZ-1:0] image_out);
    
    
    control_unit #(IMG_SZ) dut(clk, rst_l, train, start, 
                               weights_ack, bp_done, fp_done, drawn,
                               image_in, get_all_weights, do_fp, do_bp, 
                               draw, image_out);

    initial begin
        $monitor($stime,, "Inputs\n \
                          train: %h, start: %h, weights_ack: %h, bp_done: %h, fp_done: %h, drawn: %h, image: %h \n \
                          Outputs: \n \
                          get_all_w: %h, do_fp: %h, do_bp: %h, draw: %h, image_out: %h\n",
                          train, start, weights_ack, bp_done, fp_done, drawn, image_in, 
                          get_all_weights, do_fp, do_bp, draw, image_out);

        clk = 0;
        rst_l = 1;
        rst_l <= #5 1; 
        forever #10 clk = ~clk;
    end

    initial begin
        train = 0;
        start = 0;
        weights_ack = 0;
        bp_done = 0;
        fp_done = 0;
        drawn = 0;
        image_in = 'd0;
        @(posedge clk);
        @(posedge clk);
        start = 1;
        @(posedge clk);


        #10 $finish
    end

endmodule: top
