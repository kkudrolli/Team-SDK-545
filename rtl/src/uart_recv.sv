
module uart_recv(
    input  logic       uart_sampling_clock, rst,
    input  logic       USB_RX,
    output logic       byte_ready,
    output logic       USB_CTS,
    output logic [7:0] uart_byte);

    enum logic [1:0] {S_IDLE, S_READ, S_STOP} state;

    logic [3:0] sample_count;
    logic [3:0] bit_count;

    always_ff @(posedge uart_sampling_clk, posedge rst) begin
        if (rst) begin 
            state <= S_IDLE;
            sample_count <= 4'd0;
            uart_byte <= 8'b0; // shift register for byte
            byte_ready <= 1'b0;
        end
        else begin
            case (state)

                // Wait for start condition
                S_IDLE: begin
                    state <= (USB_RX) ? S_IDLE : S_READ; // Low RX is START
                    sample_count <= 4'd8;
                    bit_count <= 4'd0;
                    USB_CTS <= 1'b0; // When 0, PC cleared to send
                end
                // Read data into shift register
                S_READ: begin
                    state <= (bit_count == 4'd9) ? S_STOP : S_READ;
                    sample_count <= sample_count + 1;
                    bit_count <= (sample_count == 4'd0) ? bit_count + 1 : bit_count;
                    uart_byte <= (sample_count == 4'd0) ? {uart_byte[6:0], USB_RX} :
                                                          uart_byte;
                    USB_CTS <= 1'b0;
                end
                // Catch a stop condition
                S_STOP: begin
                    state <= (sample_count == 4'd0) ? S_IDLE : S_STOP;
                    sample_count <= sample_count + 1;
                    USB_CTS <= 1'b1; // When 1, PC not cleared to send
                    // Byte is ready for use when stop is seen
                    byte_ready <= (sample_count == 4'd0) ? 1'b1: 1'b0;
                end

                default: ; // Do nothing
            endcase
        end
    end

endmodule: uart_recv
