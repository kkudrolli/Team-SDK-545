module top;

    // Inputs
    logic uart_sampling_clk, rst, ack, resend, USB_RTS; 
    // Outputs
    logic USB_TX;

    uart_trans dut(.*);
    
    initial begin
        $monitor($stime,, "\n \
        Inputs:\n \
        ack: %h, resend: %h, rts: %h\n \
        Outputs: \n \
        tx: %h, cs: %s, ns: %s, ubyte: %b, bit_cnt: %d\n",
        ack, resend, USB_RTS, USB_TX, dut.cs, dut.ns, dut.uart_byte, dut.bit_count); 

        uart_sampling_clk = 0;
        rst = 1;
        rst <= #5 0; 
        forever #100 uart_sampling_clk = ~uart_sampling_clk;
    end

    initial begin
        USB_RTS = 0;
        ack = 1;
        resend = 0;
        for (int i = 0; i < 162; i++) begin
            @(posedge uart_sampling_clk);
            ack = 0;
        end

        resend = 1;
        for (int i = 0; i < 162; i++) begin
            @(posedge uart_sampling_clk);
            resend = 0;
        end

        #10 $finish;
    end

endmodule: top
