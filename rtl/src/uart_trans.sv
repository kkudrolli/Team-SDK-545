`define ACK    8'haa
`define RESEND 8'hcc

module uart_trans(
    input  logic uart_sampling_clk, rst,
    input  logic ack, resend,
    input  logic USB_RTS,
    output logic USB_TX);

    enum logic [1:0] {s_idle, s_start, s_trans, s_stop} cs, ns;

    // Control signals
    logic       inc_sample, inc_bit, clr_sample, clr_bit, clr_ack, clr_resend;
    logic       clr_byte, set_byte, shift;
    // Input buffers
    logic       ack_buf, resend_buf;
    // Registers
    logic [3:0] sample_count;
    logic [2:0] bit_count;
    logic [7:0] uart_byte, next_byte;

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            cs <= s_idle;
            sample_count <= 4'd0;
            bit_count <= 3'd0;
            ack_buf <= 1'b0;
            resend_buf <= 1'b0;
            uart_byte <= 8'd0;
        end
        else begin 
            cs <= ns;
            sample_count <= (clr_sample) ? 4'd1 : 
                            ((inc_sample) ? sample_count + 4'd1 : sample_count);
            bit_count <= (clr_bit) ? 3'd0 : 
                         ((inc_bit) ? bit_count + 3'd1 : bit_count);
            // Buffer inputs and clear them when done
            ack_buf <= (ack) ? 1'b1 : ((clr_ack) ? 1'b0 : ack_buf);
            resend_buf <= (resend) ? 1'b1 : ((clr_resend) ? 1'b0 : resend_buf);
            // Shift register for byte
            uart_byte <= (clr_byte) ? 8'd0 : 
                         ((set_byte) ? next_byte :
                         ((shift) ? {1'b0, uart_byte[6:0]} : uart_byte));
        end
    end

    assign start_trans = ~USB_RTS & (ack | resend | ack_buf | resend_buf);

    // Output and next state logic
    always_comb begin
        inc_sample = 1'b0; 
        inc_bit = 1'b0;
        clr_sample = 1'b0;
        clr_bit = 1'b0; 
        clr_ack = 1'b0;
        clr_resend = 1'b0;
        clr_byte = 1'b0;
        shift = 1'b0;
        USB_TX = 1'b1;
        set_byte = 1'b0;
        next_byte = 8'd0; 

        case (cs) 
            // start condition is logic 0 and stop is logic 1!!
            s_idle: begin
                ns = (start_trans) ? s_start : s_idle;
                inc_sample = start_trans;
                USB_TX = ~start_trans;
                set_byte = start_trans;
                next_byte = (start_trans) ? ((resend) ? `RESEND : `ACK) : 8'd0;
            end
            s_start: begin
                ns = (~USB_RTS && sample_count == 4'd0) ? s_trans : s_start; 
                inc_sample = ~USB_RTS;
                clr_sample = USB_RTS;
                USB_TX = (USB_RTS) ? 1'b1 : ~(sample_count != 4'd0);
            end
            s_trans: begin
                ns = (~USB_RTS && bit_count == 4'd9) ? s_stop : s_trans; 
                inc_sample = ~USB_RTS;
                inc_bit = (~USB_RTS && sample_count == 4'd0);
                clr_sample = USB_RTS;
                clr_bit = USB_RTS;
                shift = (~USB_RTS && sample_count == 4'd0);
                // Drive with data
                USB_TX = (USB_RTS) ? 1'b1 : uart_byte[0];
            end
            s_stop: begin
                ns = (~USB_RTS && sample_count == 4'd0) ? s_idle : s_stop; 
                inc_sample = ~USB_RTS && sample_count != 4'd0;
                clr_sample = USB_RTS;
                clr_ack = (~USB_RTS && sample_count == 4'd0);
                clr_resend = (~USB_RTS && sample_count == 4'd0);
                clr_byte = (~USB_RTS && sample_count == 4'd0);
            end
        endcase
    end
endmodule: uart_trans
