module chip_interface(
    input  logic clk, rst,
    input  logic USB_RX, USB_RTS,
    output logic USB_TX, USB_CTS); 

    logic       uart_sampling_clk, byte_ready, data_rdy, start, train, resend,
                start_buf, train_buf, do_fp, do_bp, draw, ack, ack_buf;
    logic [7:0] uart_byte, label, label_buf, label_out;
    logic [(784<<3)-1:0] image, image_buf, image_out;

    // Divide system clk to get slower uart_sampling_clk
    uart_clock_divider div(.clk(clk), .rst(rst), .uart_sampling_clk(uart_sampling_clk));

    /////////////////////////////////
    // Begin forward data transfer //
    /////////////////////////////////

    // Handles receiving serial uart data
    uart_recv recv(.uart_sampling_clk(uart_sampling_clk), .rst(rst), .USB_RX(USB_RX),
                   .byte_ready(byte_ready), .USB_CTS(USB_CTS), .uart_byte(uart_byte));

    // Handles byte level protocol
    uart_protocol #(784<<3) prot(.uart_sampling_clk(uart_sampling_clk), .rst(rst),
                                 .data_rdy(data_rdy), .uart_byte(uart_byte),
                                 .start(start), .train(train), .resend(resend),
                                 .label(label), .image(image));

    // Synchronizes data going from uart protocol fsm to control unit
    uart_control_synch #(784<<3) uc_syn(.clk(clk), .uart_sampling_clk(uart_sampling_clk),
                                        .rst(rst), .start(start), .train(train), 
                                        .label(label), .image(image), 
                                        .start_out(start_buf), .train_out(train_buf),
                                        .label_out(label_buf), .image_out(image_buf));

    ///////////////////////////////
    // End forward data transfer //
    ///////////////////////////////

    // Control unit for neural network
    control_unit #(784<<3) ctrl(.clk(clk), .rst(rst), .train(train_buf), .start(start_buf),
                                .bp_done(1'b0), .fp_done(1'b0), .drawn(1'b0), 
                                .label_in(label_buf), .image_in(image_buf), 
                                .do_fp(do_fp), .do_bp(do_bp), .draw(draw), .ack(ack),
                                .label_out(label_out), .image_out(image_out));

    //////////////////////////////////
    // Begin backward data transfer //
    //////////////////////////////////

    // Synchronizes ACK signal from control unit to uart
    control_trans_synch ct_syn(.clk(clk), .uart_sampling_clk(uart_sampling_clk),
                               .rst(rst), .ack(ack), .ack_out(ack_buf));

    // Handles transfer of ACKs and retries to sw over serial uart
    uart_trans trans(.uart_sampling_clk(uart_sampling_clk), .rst(rst), .ack(ack_buf),
                     .resend(resend), .USB_RTS(USB_RTS), .USB_TX(USB_TX));
    
    ////////////////////////////////
    // End backward data transfer //
    ////////////////////////////////

endmodule: chip_interface
