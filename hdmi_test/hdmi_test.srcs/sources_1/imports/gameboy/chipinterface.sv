`define BUADRATE 921600
`define BUAD_COUNT(rate) (200000000 / (16*rate))

module ChipInterface(
    input  logic	   SYSCLK_P, SYSCLK_N,
    input  logic       rst, push, 
    input  logic       bp_done, fp_done, drawn,
    input  logic       USB_RX, USB_RTS,
    input  logic [1:0] sel,
    output logic [7:0] LEDS,
    output logic       USB_TX, USB_CTS,
    
    output logic         en_bus,
           
    // hdmi
    output logic            I2C_SCL,
    inout tri               I2C_SDA,
    output logic [35:0]     HDMI_TX_D,
    output logic            HDMI_TX_CLK,   
    output logic            HDMI_TX_DE,
    output logic            HDMI_TX_HS,
    output logic            HDMI_TX_VS
    );

    logic clk; // 200 MHz clock because it just uses the board clock
   
    IBUFDS #(.DIFF_TERM("TRUE"), .IBUF_LOW_PWR("TRUE"), .IOSTANDARD("DEFAULT"))
             clk_ibufds (.O(clk), .I(SYSCLK_P), .IB(SYSCLK_N));
   
    logic                uart_sampling_clk, byte_ready, start, train, resend,
                         start_buf, train_buf, ack, ack_buf, do_fp, do_bp, draw,
                         trans_ack_buf, trans_resend_buf, draw_image, draw_pred;
    logic [7:0]          uart_byte, label, label_buf, label_out, led_out;
    logic [2:0]          cs;
    logic [1:0]          recv_state, cs_ctrl, cs_trans;
    logic [(784<<3)-1:0] image, image_buf, image_out, image_shift_buf, pred_image, pred_image_buf;
    
    logic [18:0] addr, addr_w;
    logic [31:0] data_in;
    logic [3:0]  we;
    
    logic shift_image, shift_pred;
    logic [9:0] shift_count, data_count, shift_pred_count;
    
    logic [3:0] col_counter_small,row_counter_small;
    logic [4:0] col_counter_large, row_counter_large;
    logic processingPixel;
    logic side, rts_probe, rx_probe;
    
    logic [7:0] max_result, max_result_buf;
    logic done, done_reg, start_reg;
    
    logic [9:0][31:0] result;
    
    assign rts_probe = USB_RTS;
    assign rx_probe = USB_RX;
    
    // Divide system clk to get slower uart_sampling_clk
    //uart_clock_divider div(.clk(clk), .rst(rst), .uart_sampling_clk(uart_sampling_clk));
    
    always_comb begin
        case (sel)
            2'b00: LEDS = {recv_state[1:0], draw_image, cs_ctrl[1:0], cs[2:0]};
            2'b01: LEDS = data_count[9:2];
            2'b10: LEDS = {trans_ack_buf, trans_resend_buf, cs_trans[1:0], data_count[1:0], byte_ready, led_out[0]};
            2'b11: LEDS = max_result_buf;
        endcase
    end
    
    /////////////////////////////////
    // Begin forward data transfer //
    /////////////////////////////////

    // Handles receiving serial uart data
    uart_recv recv(.uart_sampling_clk(uart_sampling_clk), .rst(rst), .USB_RX(USB_RX),
                   .byte_ready(byte_ready), .USB_CTS(USB_CTS), .state_out(recv_state), .uart_byte(uart_byte));

    // Handles byte level protocol
    uart_protocol #(784<<3) prot(.uart_sampling_clk(uart_sampling_clk), .rst(rst),
                                 .data_rdy(byte_ready), .uart_byte(uart_byte),
                                 .start(start), .train(train), .resend(resend),
                                 .label(label), .cs_out(cs), .data_count(data_count), .image(image));

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
                                .bp_done(done), .fp_done(done), .drawn(1'b1), 
                                .label_in(label_buf), .image_in(image_buf), 
                                .do_fp(do_fp), .do_bp(do_bp), .draw(draw), .ack(ack),
                                .label_out(label_out), .image_out(image_out), .cs_ctrl(cs_ctrl));

    //////////////////////////////////
    // Begin backward data transfer //
    //////////////////////////////////

    // Synchronizes ACK signal from control unit to uart
    control_trans_synch ct_syn(.clk(clk), .uart_sampling_clk(uart_sampling_clk),
                               .rst(rst), .ack(ack), .ack_out(ack_buf));

    // Handles transfer of ACKs and retries to sw over serial uart
    uart_trans trans(.uart_sampling_clk(uart_sampling_clk), .rst(rst), .ack(ack_buf),
                     .resend(resend), .USB_RTS(USB_RTS), .USB_TX(USB_TX), .resend_buf(trans_resend_buf),
                     .ack_buf(trans_ack_buf), .cs_trans(cs_trans));
    
    ////////////////////////////////
    // End backward data transfer //
    ////////////////////////////////
                         
    // HDMI stuff

    always_ff @(posedge uart_sampling_clk, posedge rst) begin
        if (rst) begin
            image_shift_buf <= 'd0;
            pred_image_buf <= 'd0;
        end
        else begin
            image_shift_buf <= (start) ? image :
                               ((shift_image) ? {image_shift_buf[7:0], image_shift_buf[(784<<3)-1:8]} : 
                                              image_shift_buf);
            // Shifts top to bottom bc image is reversed
            pred_image_buf <= (done) ? pred_image :
                               ((shift_pred) ? {pred_image_buf[(784<<3)-9:0], pred_image_buf[(784<<3)-1:(784<<3)-8]} : 
                                               pred_image_buf);
        end 
    end
    
    
    assign draw_image = (start || start_reg) && shift_count != 10'd784;
    assign draw_pred = (done || done_reg) && shift_pred_count != 10'd784;
    
    //write FSM
    always_ff @(posedge uart_sampling_clk, posedge rst) begin
        if (rst) begin
            we <= 1'b0;
            addr_w <= 19'd0;
            row_counter_small <= 0;
            col_counter_small <= 0;
            row_counter_large <= 0;
            col_counter_large <= 0;
            processingPixel <= 0;
            side <= 0;
            shift_image <= 0;
            shift_count <= 10'd0;
            shift_pred <= 0;
            shift_pred_count <= 10'd0;
            done_reg <= 1'b0;
            start_reg <= 1'b0;
        end
        else begin
            // Buffer start and done signals, deassert at end of drawing the image
            if (start) begin
                start_reg <= 1'b1;
            end
            if (done) begin
                done_reg <= 1'b1;
            end
            
            // Start drawing sent image
            if(draw_image) begin
                processingPixel <= 1;
                data_in <= {image_shift_buf[7:0], image_shift_buf[7:0], image_shift_buf[7:0]};
                we <= 1;
                side <= 1;
                shift_image <= 0;
                shift_count <= 10'd0;
                addr_w <= 72060 + col_counter_large*10 + row_counter_large*7200; // 72040 = 720*100+40
            end
            // Start drawing prediction image
            else if (draw_pred) begin
                processingPixel <= 1;
                data_in <= {pred_image_buf[(784<<3)-1:(784<<3)-8], pred_image_buf[(784<<3)-1:(784<<3)-8], pred_image_buf[(784<<3)-1:(784<<3)-8]};
                we <= 1;
                side <= 0;
                shift_pred <= 0;
                shift_pred_count <= 10'd0;
                addr_w <= 72379 + col_counter_large*10 + row_counter_large*7200; // 72040 = 720*100+40                           
            end

            // Still same pixel
            if(processingPixel && row_counter_small<10) begin                
                if(col_counter_small<9) begin
                    col_counter_small <= col_counter_small+1;
                    addr_w <= addr_w+1;
                end
                else begin // col_counter_small==10
                    col_counter_small <= 0;
                    addr_w <= addr_w+711;
                    row_counter_small <= row_counter_small+1;
                end
            end

            // Done with this pixel && still same row_large
            else if (processingPixel && row_counter_small==10 && col_counter_large<27 && row_counter_large<28) begin
                we <= 0;
                processingPixel <= 0; // wait for new uart_byte_buf
                col_counter_small <= 0;
                row_counter_small <= 0;
                col_counter_large <= col_counter_large+1;
                if (side) begin 
                    shift_image <= 1;
                    shift_count <= (shift_count == 10'd784) ? shift_count: shift_count + 10'd1;
                end else begin
                    shift_pred <= 1;
                    shift_pred_count <= (shift_pred_count == 10'd784) ? shift_pred_count: shift_pred_count + 10'd1;
                end
            end

            // Need to go to next row_large
            else if(processingPixel && row_counter_small==10 && col_counter_large==27 && row_counter_large<27) begin
                we <= 0;
                processingPixel <= 0; // wait for new uart_byte_buf
                col_counter_small <= 0;
                row_counter_small <= 0;
                col_counter_large <= 0;
                row_counter_large <= row_counter_large+1;
                if (side) begin 
                    shift_image <= 1;
                    shift_count <= (shift_count == 10'd784) ? shift_count: shift_count + 10'd1;
                end else begin
                    shift_pred <= 1;
                    shift_pred_count <= (shift_pred_count == 10'd784) ? shift_pred_count: shift_pred_count + 10'd1;
                end
            end

            // Done with this digit
            else if(processingPixel && row_counter_small==10 && col_counter_large==27 && row_counter_large==27) begin
                we <= 0;
                processingPixel <= 0; // wait for new uart_byte_buf
                col_counter_small <= 0;
                row_counter_small <= 0;
                col_counter_large <= 0;
                row_counter_large <= 0;              
                //shift_image <= 1;
                if (side) begin 
                    shift_count <= (shift_count == 10'd784) ? shift_count: shift_count + 10'd1;
                    start_reg <= (shift_count == 10'd784) ? 1'b0 : start_reg;
                end else begin
                    shift_pred_count <= (shift_pred_count == 10'd784) ? shift_pred_count: shift_pred_count + 10'd1;
                    done_reg <= (shift_pred_count == 10'd784) ? 1'b0 : done_reg;
                end
            end
        end
     end


     logic sysclk;  
              
     clock ck (.clk_in1 (clk), .clk_out1 (HDMI_TX_CLK), .clk_out2 (sysclk), .clk_out3(uart_sampling_clk),
                       .reset (rst));
  
     hdmi encoder (.clk (HDMI_TX_CLK), .rst (rst), .hsync (HDMI_TX_HS), .vsync (HDMI_TX_VS), 
                   .addr (addr), .de (HDMI_TX_DE));
     
     video_unit v (.clka(uart_sampling_clk), .clkb (HDMI_TX_CLK), .de (1'b1), .addr_r (addr), .data (HDMI_TX_D), 
                  .we (we), .data_in (data_in), .addr_w (addr_w));
     
     reg [4:0] outA;
     reg       stop;
     reg       _ack;
     
     reg [4:0] counter;
     reg          clk_reduced;
     // Divide 5 MHz clk by 20 to give 250 kHz I2C logic driver. 
     always @(posedge sysclk) begin
        counter = (counter == 5'd20) ? 5'd0 : counter + 5'h1;
        clk_reduced = (stop) ? 1'b0 : ((counter == 5'h0) ? ~clk_reduced : clk_reduced);
     end
     i2c bus(.stop (stop), .clk (clk_reduced), .rst (rst), .outA (outA), .SDA (I2C_SDA), .SCL (I2C_SCL), .ACK (_ack));
             
     assign en_bus = 1'b1;


   //---- TOP LEVEL NEURAL NETWORK MODULE INSTANTIATION -----//
   //-------------------------------------------------------------------------------------------------------------//
   deep dp (.clk (clk), .rst (rst), .do_fp (do_fp), .label_in (label_out),  .image_in (image_out), 
            .result (result), .done (done));                                        

   num_to_image n2i (.num(max_result_buf[3:0]), .image(pred_image));

   always_ff @(posedge clk, negedge rst) begin
       if (rst) begin
           max_result_buf <= 'd0;
       end
       else if (done) begin
           max_result_buf <= max_result;
       end
   end
    
    logic [31:0] max;
    integer 	i;
    always_comb begin
      max = result[0];
      max_result = 0;
      for (i = 1; i < 10; i++) begin
         if (result[i] > max) begin
            max = result[i];
            max_result = i;
         end 
      end
    end

endmodule: ChipInterface
