`define BAUDRATE 921600
`define BAUD_COUNT(rate) (200000000 / (16*rate))

module uart_clock_divider(
    input  logic clk, rst,
    output logic uart_sampling_clk);

    logic [10:0] clock_divider;

    always_ff @(posedge clk, posedge rst) begin 
        if (rst) begin
            uart_sampling_clk <= 1'b0;
            clock_divider <= 11'd0;
        end
        else begin
            // UART sampling clock is 13x slower
            uart_sampling_clk <= (clock_divider == `BAUD_COUNT(`BAUDRATE)/2 || 
                                  clock_divider == `BAUD_COUNT(`BAUDRATE)) ?
                                  ~uart_sampling_clk : uart_sampling_clk;
            clock_divider <= (clock_divider == `BAUD_COUNT(`BAUDRATE)) ? 
                              11'd0 : clock_divider + 1;
        end
    end

endmodule: uart_clock_divider
