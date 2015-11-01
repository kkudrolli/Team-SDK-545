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
    input  logic              bp_done, fp_done, drawn,
    // Input label
    input  logic [7:0]        label_in,
    // Input image
    input  logic [IMG_SZ-1:0] image_in,
    // Output control signals
    output logic              do_fp, do_bp, draw, ack,
    // Output label
    output logic [7:0]        label_out,
    // Output image vector
    output logic [IMG_SZ-1:0] image_out);

    enum logic [1:0] {idle, fwd_prop, back_prop, display} cs, ns;

    logic started, clear_start, train_reg, clear_train;

    // Just pass input image 
    assign image_out = image_in;
    assign label_out = label_in;

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            cs <= idle;
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
        do_fp = 0;
        do_bp = 0;
        draw = 0;
        clear_start = 0;
        clear_train = 0;

        case (cs) 
            idle: begin
                do_fp = (start | started) ? 1 : 0;
                ns = (start | started) ? fwd_prop : idle;
            end
            fwd_prop: begin
                do_fp = (fp_done) ? 0 : 1;
                do_bp = (fp_done & train) ? 1 : 0;
                draw = (fp_done & ~train) ? 1 : 0;
                ns = (fp_done) ? ((train) ? back_prop : display) : fwd_prop;
            end
            back_prop: begin
                do_bp = (bp_done) ? 0 : 1;
                ns = (bp_done) ? idle : back_prop;
                // Clear the start and train when done with a backprop pass
                clear_start = (bp_done) ? 1 : 0;
                clear_train = (bp_done) ? 1 : 0;
                ack = (bp_done) ? 1 : 0;
            end
            display: begin
                draw = (drawn) ? 0 : 1; 
                ns = (drawn) ? idle : display;
                // Clear the start when done with a display pass
                clear_start = (drawn) ? 1 : 0;
                ack = (drawn) ? 1 : 0;
            end
        endcase
    end
   

endmodule: control_unit
