module control_trans_synch(
    input  logic clk, uart_sampling_clk, rst,
    input  logic ack,
    output logic ack_out);

    enum logic {s_idle, s_hold} cs, ns;

    logic       ack_mid, next_mid, inc;
    logic [3:0] count;

    // uart_sampling_clk is ~13x slower, so to catch the ack, hold ack for 16 cycles
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            cs <= s_idle;
            ack_mid <= 1'b0;
            count <= 4'd0;
        end
        else begin
            cs <= ns;
            ack_mid <= next_mid;
            count <= (inc) ? count + 4'd1 : count;
        end
    end

    always_comb begin
        next_mid = 1'b0;
        inc = 1'b0;
        case (cs)
            s_idle: begin
                ns = (ack) ? s_hold : s_idle;
                next_mid = (ack) ? 1'b1 : 1'b0;
                inc = (ack) ? 1'b1 : 1'b0;
            end
            s_hold: begin
                ns = (count == 4'd0) ? s_idle : s_hold;
                inc = (count != 4'd0) ? 1'b1 : 1'b0;
                next_mid = 1'b1;
            end
        endcase
    end

    // Second set of synchronizing registers
    always_ff @(posedge uart_sampling_clk, posedge rst) begin
        if (rst) begin
            ack_out <= 1'b0;
        end
        else begin
            ack_out <= ack_mid;
        end
    end

endmodule: control_trans_synch
