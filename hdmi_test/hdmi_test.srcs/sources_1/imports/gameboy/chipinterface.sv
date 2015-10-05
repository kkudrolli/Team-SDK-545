
`define BUADRATE 9600
`define BUAD_COUNT(rate) (200000000 / (16*rate))

module ChipInterface
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
   output logic        	HDMI_TX_DE,
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
   logic [7:0] uart_byte;
   
   logic [18:0] addr, addr_w;
   logic [31:0] data_in;
   logic [7:0] tile_count;
   logic [3:0] we;   
   logic rx_probe;

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

   always_ff @(posedge uart_sampling_clk, posedge rst) begin
       if (rst) begin
           state <= S_IDLE;
           sample_count <= 4'd0;
           uart_byte <= 8'b0;
           we <= 1'b0;
           addr_w <= 19'd0;
           tile_count <= 0;
           LEDS <= 8'b0;
       end else begin
           case (state)

               S_IDLE: begin
                   // Wait until we see a start bit
                   state <= USB_RX ? S_IDLE : S_READ;
                   sample_count <= 4'd8;
                   bit_count <= 4'd0;
                   we <= 1'b0;
                   USB_CTS <= 1'b0;
               end
               
               S_READ: begin
                   sample_count <= sample_count + 1;
                   state <= (bit_count == 4'd9) ? S_WRITE : S_READ;
                   bit_count <= (sample_count == 4'd0) ? bit_count + 1 : bit_count;
                   uart_byte <= (sample_count == 4'd0) ? {uart_byte[6:0], USB_RX} : uart_byte;
                   we <= 1'b0;
                   USB_CTS <= 1'b0;
               end
               
               S_WRITE: begin
                   sample_count <= sample_count + 1;
                   state <= (sample_count == 4'd0) ? S_IDLE : S_WRITE;
                   LEDS <= (sample_count == 4'd0) ? ((LEDS == 27) ? 0 : LEDS + 1) : LEDS;
                   we <= 1'b1;
                   data_in <= uart_byte;
                   
                   if (sample_count == 4'd0) begin
                        if (addr_w < 344907 + tile_count*28) begin
                            addr_w <= (LEDS == 27) ? addr_w + 693 : addr_w + 1;
                        end else begin
                            addr_w <= (tile_count+1)*28;
                            tile_count <= tile_count + 1;
                        end
                   end
                   
                   USB_CTS <= 1'b1;
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
