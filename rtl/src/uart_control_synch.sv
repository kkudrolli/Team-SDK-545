module uart_control_synch 
    #(IMG_SZ = 784<<3)
    (// Both clocks and reset
    input  logic              clk, uart_sampling_clk, rst,
    // Inputs
    input  logic              start, train,
    input  logic [IMG_SZ-1:0] image,
    // Outputs
    output logic              start_out, train_out,
    output logic [IMG_SZ-1:0] image_out);

    logic              start_mid, train_mid,
    logic [IMG_SZ-1:0] image_mid);
    
    // Clock first synch register at uart clock
    always_ff @(posedge uart_sampling_clk, posedge rst) begin
        if (rst) begin
            start_mid <= 1'b0;
            train_mid <= 1'b0;
            image_mid <= 'd0;
        end
        else begin
            start_mid <= start;
            train_mid <= train;
            image_mid <= image;
        end
    end
    
    // Clock second synch register at system clock
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            start_out <= 1'b0;
            train_out <= 1'b0;
            image_out <= 'd0;
        end
        else begin
            start_out <= start_mid;
            train_out <= train_mid;
            image_out <= image_mid;
        end
    end

endmodule: uart_control_synch

