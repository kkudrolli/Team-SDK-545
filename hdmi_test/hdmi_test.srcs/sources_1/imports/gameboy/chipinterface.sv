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
                         trans_ack_buf, trans_resend_buf, draw_image;
    logic [7:0]          uart_byte, label, label_buf, label_out, led_out;
    logic [2:0]          cs;
    logic [1:0]          recv_state, cs_ctrl, cs_trans;
    logic [(784<<3)-1:0] image, image_buf, image_out, image_shift_buf;
    
    logic [18:0] addr, addr_w;
    logic [31:0] data_in;
    logic [3:0]  we;
    
    logic shift_image;
    logic [9:0] shift_count, data_count;
    
    logic [3:0] col_counter_small,row_counter_small;
    logic [4:0] col_counter_large, row_counter_large;
    logic processingPixel;
    logic side, flip, rts_probe, rx_probe;
    
    assign rts_probe = USB_RTS;
    assign rx_probe = USB_RX;
    
    // Divide system clk to get slower uart_sampling_clk
    uart_clock_divider div(.clk(clk), .rst(rst), .uart_sampling_clk(uart_sampling_clk));
    
    always_comb begin
        case (sel)
            2'b00: LEDS = {recv_state[1:0], draw_image, cs_ctrl[1:0], cs[2:0]};
            2'b01: LEDS = data_count[9:2];
            2'b10: LEDS = {trans_ack_buf, trans_resend_buf, cs_trans[1:0], data_count[1:0], byte_ready, led_out[0]};
            2'b11: LEDS = uart_byte;
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
                                .bp_done(bp_done), .fp_done(fp_done), .drawn(drawn), 
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
    
    image_led #(784<<3) img_led (.clk(clk), .rst(rst), .push(push),
                         .image(image_buf), .LEDS(led_out));
                         
    // HDMI stuff

    always_ff @(posedge uart_sampling_clk, posedge rst) begin
        if (rst) begin
            image_shift_buf <= 'd0;
        end
        else begin
            image_shift_buf <= (start) ? image :
                               ((shift_image) ? {image_shift_buf[7:0], image_shift_buf[(784<<3)-1:8]} : image_shift_buf);
        end 
    end
    
    
    assign draw_image = (start || shift_image) && shift_count != 10'd784;
    
    
    // write FSM
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
                flip <= 0;
                shift_image <= 0;
                shift_count <= 10'd0;
            end
            else begin
                if(draw_image) begin
                    processingPixel <= 1;
                    data_in <= image_shift_buf[7:0];
                    we <= 1;
                    side = (flip) ? ~side : side;
                    flip <= 0;
                    shift_image <= 0;
                    shift_count <= 10'd0;
                    if (side == 0) 
                        addr_w <= 72039 + col_counter_large*10 + row_counter_large*6480; // 72040 = 720*100+40
                    else
                        addr_w <= 72399 + col_counter_large*10 + row_counter_large*6480; // 72040 = 720*100+40                                
                end
                           
                // Still same pixel
                if(processingPixel && row_counter_small<9) begin                
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
                else if (processingPixel && row_counter_small==9 && col_counter_large<27 && row_counter_large<28) begin
                    we <= 0;
                    processingPixel <= 0; // wait for new uart_byte_buf
                    col_counter_small <= 0;
                    row_counter_small <= 0;
                    col_counter_large <= col_counter_large+1;
                    shift_image <= 1;
                    shift_count <= (shift_count == 10'd784) ? shift_count: shift_count + 10'd1;
                end
                // Need to go to next row_large
                else if(processingPixel && row_counter_small==9 && col_counter_large==27 && row_counter_large<27) begin
                    we <= 0;
                    processingPixel <= 0; // wait for new uart_byte_buf
                    col_counter_small <= 0;
                    row_counter_small <= 0;
                    col_counter_large <= 0;
                    row_counter_large <= row_counter_large+1;
                    shift_image <= 1;
                    shift_count <= (shift_count == 10'd784) ? shift_count: shift_count + 10'd1;
                end
                // Done with this digit
                else if(processingPixel && row_counter_small==9 && col_counter_large==27 && row_counter_large==27) begin
                    we <= 0;
                    processingPixel <= 0; // wait for new uart_byte_buf
                    col_counter_small <= 0;
                    row_counter_small <= 0;
                    col_counter_large <= 0;
                    row_counter_large <= 0;              
                    flip <= 1;
                    shift_image <= 1;
                    shift_count <= (shift_count == 10'd784) ? shift_count: shift_count + 10'd1;
                end
            end
        end
        
         logic sysclk;  
                  
         clock_wrapper ck (.clk_in1 (clk), .clk_out1 (HDMI_TX_CLK), .clk_out2 (sysclk), .reset (rst));
      
         hdmi encoder (.clk (HDMI_TX_CLK), .rst (rst), .hsync (HDMI_TX_HS), .vsync (HDMI_TX_VS), 
                       .addr (addr), .de (HDMI_TX_DE));
         
         video_unit v (.clka(uart_sampling_clk), .clkb (HDMI_TX_CLK), .de (HDMI_TX_DE), .addr_r (addr), .data (HDMI_TX_D), 
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
                         

endmodule: ChipInterface


/*module ChipInterface
  (
   // clocks
   input logic	       	SYSCLK_P, SYSCLK_N,
   input logic          rst,
   
   input logic  [7:0]   SW,
   output logic [7:0]   LEDS,
   
   output logic         en_bus,
   
   // hdmi
   output logic		    I2C_SCL,
   inout tri 	       	I2C_SDA,
   output logic [35:0]  HDMI_TX_D,
   output logic        	HDMI_TX_CLK,
   output logic        	HDMI_TX_DE,uart_byte_buf
   output logic        	HDMI_TX_HS,
   output logic        	HDMI_TX_VS,
   
   input logic USB_RTS, USB_RX,
   output logic USB_CTS, USB_TX
   );
                
   logic sysclk;
   
   IBUFDS #(.DIFF_TERM("TRUE"), .IBUF_LOW_PWR("TRUE"), .IOSTANDARD("DEFAULT"))
            clk_ibufds (.O(sysclk), .I(SYSCLK_P), .IB(SYSCLK_N));

   enum logic [1:0] {S_IDLE, S_READ, S_WRITE} state;
   logic [3:0] sample_count;
   logic [3:0] bit_count;
   logic [7:0] uart_byte,uart_byte_buf;
   
   logic [18:0] addr, addr_w;
   logic [31:0] data_in;
   //logic [7:0] tile_count;
   logic [3:0] we;   
   logic rx_probe;
   
   logic [3:0] col_counter_small,row_counter_small;
   logic [4:0] col_counter_large, row_counter_large;
   logic startWrite;
   logic processingPixel;
   logic side, flip;

   logic [10:0] clock_divider;
   logic uart_sampling_clk;
   always_ff @(posedge sysclk, posedge rst) begin
       if (rst) begin
           uart_sampling_clk <= 1'b0;
           clock_divider <= 11'd0;
       end else begin
           uart_sampling_clk <= (clock_divider == `BUAD_COUNT(`BUADRATE)/2 || clock_divider == `BUAD_COUNT(`BUADRATE)) 
               ? ~uart_sampling_clk : uart_sampling_clk;
           clock_divider <= (clock_divider == `BUAD_COUNT(`BUADRATE)) ? 11'd0 : clock_divider + 1;
       end
   end

   assign rx_probe = USB_RX;

    // write FSM
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
            flip <= 0;
        end
        else begin
            if(startWrite) begin
                processingPixel <= 1;
                data_in <= uart_byte_buf;
                we <= 1;
                side = (flip) ? ~side : side;
                flip <= 0;
                if (side == 0) 
                    addr_w <= 72039 + col_counter_large*10 + row_counter_large*6480; // 72040 = 720*100+40
                else
                    addr_w <= 72399 + col_counter_large*10 + row_counter_large*6480; // 72040 = 720*100+40                                
            end
                       
            // Still same pixel
            if(processingPixel && row_counter_small<9) begin                
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
            else if (processingPixel && row_counter_small==9 && col_counter_large<27 && row_counter_large<28) begin
                we <= 0;
                processingPixel <= 0; // wait for new uart_byte_buf
                col_counter_small <= 0;
                row_counter_small <= 0;
                col_counter_large <= col_counter_large+1;
            end
            // Need to go to next row_large
            else if(processingPixel && row_counter_small==9 && col_counter_large==27 && row_counter_large<27) begin
                we <= 0;
                processingPixel <= 0; // wait for new uart_byte_buf
                col_counter_small <= 0;
                row_counter_small <= 0;
                col_counter_large <= 0;
                row_counter_large <= row_counter_large+1;
            end
            // Done with this digit
            else if(processingPixel && row_counter_small==9 && col_counter_large==27 && row_counter_large==27) begin
                we <= 0;
                processingPixel <= 0; // wait for new uart_byte_buf
                col_counter_small <= 0;
                row_counter_small <= 0;
                col_counter_large <= 0;
                row_counter_large <= 0;              
                flip <= 1;
            end
        end
    end

   always_ff @(posedge uart_sampling_clk, posedge rst) begin
       if (rst) begin
           state <= S_IDLE;
           sample_count <= 4'd0;
           uart_byte <= 8'b0;
           uart_byte_buf <= 8'hbe;
           //we <= 1'b0;
           //addr_w <= 19'd0;
           //tile_count <= 0;
           LEDS <= 8'b0;
           
       end else begin
           case (state)

               S_IDLE: begin
                   // Wait until we see a start bit
                   state <= USB_RX ? S_IDLE : S_READ;
                   sample_count <= 4'd8;
                   bit_count <= 4'd0;
                   //we <= 1'b0;
                   USB_CTS <= 1'b0;
               end
               
               S_READ: begin
                   sample_count <= sample_count + 1;
                   state <= (bit_count == 4'd9) ? S_WRITE : S_READ;
                   bit_count <= (sample_count == 4'd0) ? bit_count + 1 : bit_count;
                   uart_byte <= (sample_count == 4'd0) ? {uart_byte[6:0], USB_RX} : uart_byte;
                   //we <= 1'b0;
                   USB_CTS <= 1'b0;
               end
               
               S_WRITE: begin
                   sample_count <= sample_count + 1;
                   state <= (sample_count == 4'd0) ? S_IDLE : S_WRITE;
                   LEDS <= (sample_count == 4'd0) ? ((LEDS == 27) ? 0 : LEDS + 1) : LEDS;
                   
                   //we <= 1'b1;
                   //data_in <= uart_byte;
                   
//                   if (sample_count == 4'd0) begin
//                        if (addr_w < 344907 + tile_count*28) begin
//                            addr_w <= (LEDS == 27) ? addr_w + 693 : addr_w + 1;
//                        end else begin
//                            addr_w <= (tile_count+1)*28;
//                            tile_count <= tile_count + 1;
//                        end
//                   end
                   
                   USB_CTS <= 1'b1;
                   
                   // below are newly added
                   uart_byte_buf <= (sample_count == 4'd2) ? uart_byte : uart_byte_buf; 
                   startWrite <= (sample_count == 4'd2) ? 1 : 0;
               end
               
               default: ; // Do nothing
           endcase
       end
   end
   
   
   


   logic clk;  
            
   clock_wrapper ck (.clk_in1 (sysclk), .clk_out1 (HDMI_TX_CLK), .clk_out2 (clk), .reset (rst));

   hdmi encoder (.clk (HDMI_TX_CLK), .rst (rst), .hsync (HDMI_TX_HS), .vsync (HDMI_TX_VS), 
                 .addr (addr), .de (HDMI_TX_DE));
   
   video_unit v (.clk (HDMI_TX_CLK), .de (HDMI_TX_DE), .addr_r (addr), .data (HDMI_TX_D), 
                 .we (we), .data_in (data_in), .addr_w (addr_w));
   
   reg [4:0] outA;
   reg 	     stop;
   reg       ack;

   reg [4:0] counter;
   reg 	     clk_reduced;
   // Divide 5 MHz clk by 20 to give 250 kHz I2C logic driver. 
   always @(posedge clk) begin
      counter = (counter == 5'd20) ? 5'd0 : counter + 5'h1;
      clk_reduced = (stop) ? 1'b0 : ((counter == 5'h0) ? ~clk_reduced : clk_reduced);
   end
   i2c bus(.stop (stop), .clk (clk_reduced), .rst (rst), .outA (outA), .SDA (I2C_SDA), .SCL (I2C_SCL), .ACK (ack));
           
   assign en_bus = 1'b1;
      
endmodule: ChipInterface   
*/