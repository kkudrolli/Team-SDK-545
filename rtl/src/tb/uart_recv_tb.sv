module top;

    // Inputs
    logic uart_sampling_clk, rst, USB_RX; 
    // Outputs
    logic byte_ready, USB_CTS;
    logic [7:0] uart_byte;

    uart_recv dut(.*);
    
    initial begin
        $monitor($stime,, "\n \
        Inputs:\n \
        rx: %h\n \
        Outputs: \n \
        brdy: %h, cts: %h, ubyte: 0b%b, cs: %s\n",
        USB_RX, byte_ready, USB_CTS, uart_byte, dut.state); 

        uart_sampling_clk = 0;
        rst = 1;
        rst <= #5 0; 
        forever #100 uart_sampling_clk = ~uart_sampling_clk;
    end

    initial begin
        USB_RX = 1;
        for (int i = 0; i < 8; i++) begin
            @(posedge uart_sampling_clk);
        end
        // Start condition
        USB_RX = 0;
        for (int i = 0; i < 8; i++) begin
            @(posedge uart_sampling_clk);
        end
        // Send pattern 10101010
        USB_RX = 1;
        for (int i = 0; i < 16; i++) begin
            @(posedge uart_sampling_clk);
        end
        USB_RX = 0;
        for (int i = 0; i < 16; i++) begin
            @(posedge uart_sampling_clk);
        end
        USB_RX = 1;
        for (int i = 0; i < 16; i++) begin
            @(posedge uart_sampling_clk);
        end
        USB_RX = 0;
        for (int i = 0; i < 16; i++) begin
            @(posedge uart_sampling_clk);
        end
        USB_RX = 1;
        for (int i = 0; i < 16; i++) begin
            @(posedge uart_sampling_clk);
        end
        USB_RX = 0;
        for (int i = 0; i < 16; i++) begin
            @(posedge uart_sampling_clk);
        end
        USB_RX = 1;
        for (int i = 0; i < 16; i++) begin
            @(posedge uart_sampling_clk);
        end
        USB_RX = 0;
        for (int i = 0; i < 16; i++) begin
            @(posedge uart_sampling_clk);
        end
        // STOP condition
        USB_RX = 1;
        for (int i = 0; i < 16; i++) begin
            @(posedge uart_sampling_clk);
        end
        USB_RX = 0;
        @(posedge uart_sampling_clk);

        #10 $finish;
    end

endmodule: top
