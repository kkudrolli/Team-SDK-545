module image_led
    #(IMG_SZ = 784<<3)
    (
    input  logic              clk, rst, push,
    input  logic [IMG_SZ-1:0] image,
    output logic [7:0]        LEDS
    );
     
    logic [IMG_SZ-1:0] image_buf;
    
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            LEDS <= 8'h00;
            image_buf <= image;
        end
        else begin
            LEDS <= image_buf[7:0];
            image_buf <= (push) ? {image_buf[7:0], image_buf[IMG_SZ-1:8]}: image_buf;
        end
    end
    
endmodule: image_led
