// 
// control_unit.sv
//
// Author: Kais Kudrolli
//
// Description: Definition of control unit module for neural network
//              implementation.
//

module control_unit
    // Image size parameter
    #(parameter IMG_SZ = 784<<3)
    (// Input signals and clock
    input  logic              clk, rst, train, start, 
    // Input control signals
    input  logic              weights_ack, bp_done, fp_done, drawn,
    // Input image
    input  logic [IMG_SZ-1:0] image_in,
    // Output control signals
    output logic              get_all_weights, do_fp, do_bp, draw,
    // Output image vector
    output logic [IMG_SZ-1:0] image_out);

    enum logic [1:0] {weights, fwd_prop, back_prop, display} cs, ns;

    logic started, clear_start, train_reg, clear_train;

    // Just pass input image 
    assign image_out = image_in;

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            cs <= weights;
            started <= 1'b0;
            started <= 1'b0;
        end
        else begin
            cs <= ns;
            // Buffer the start and train from uart_protocol
            started <= (start) ? 1'b1 : ((clear_start) ? 1'b0 : started);
            train_reg <= (train) ? 1'b1 : ((clear_train) ? 1'b0 : train_reg);
        end
    end 

    // Next state and output logic
    always_comb begin
        get_all_weights = 0;
        do_fp = 0;
        do_bp = 0;
        draw = 0;
        clear_start = 0;
        clear_train = 0;

        case (cs) 
            weights: begin
                get_all_weights = (weights_ack) ? 0 : 1;
                do_fp = ((start | started) & weights_ack) ? 1 : 0;
                ns = ((start | started) & weights_ack) ? fwd_prop : weights;
            end
            fwd_prop: begin
                do_fp = (fp_done) ? 0 : 1;
                do_bp = (fp_done & train) ? 1 : 0;
                draw = (fp_done & ~train) ? 1 : 0;
                ns = (fp_done) ? ((train) ? back_prop : display) : fwd_prop;
            end
            back_prop: begin
                do_bp = (bp_done) ? 0 : 1;
                get_all_weights = (bp_done) ? 1 : 0;
                ns = (bp_done) ? weights : back_prop;
                // Clear the start and train when done with a backprop pass
                clear_start = (bp_done) ? 1 : 0;
                clear_train = (bp_done) ? 1 : 0;
            end
            display: begin
                draw = (drawn) ? 0 : 1; 
                get_all_weights = (drawn) ? 1 : 0;
                ns = (drawn) ? weights : display;
                // Clear the start when done with a display pass
                clear_start = (drawn) ? 1 : 0;
            end
        endcase
    end
   

endmodule: control_unit
