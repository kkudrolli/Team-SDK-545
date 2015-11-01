module control_trans_synch(
    input  logic clk, uart_sampling_clk, rst,
    input  logic ack,
    output logic ack_out);

    logic ack_mid;

    // TODO: ack may be too fast and missed, so hold for like 16 cycles?
    always_ff @(posedge clk, @posedge rst) begin
        if (rst) begin
            ack_mid <= 1'b0;
        end
        else begin
            ack_mid <= ack;
        end
    end

    always_ff @(posedge uart_sampling_clk, @posedge rst) begin
        if (rst) begin
            ack_out <= 1'b0;
        end
        else begin
            ack_out <= ack_mid;
        end
    end

endmodule: control_trans_synch
