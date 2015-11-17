`define START 8'hff
`define TRAIN 8'hf0
`define TEST  8'h0f
//`define STOP  8'hff

module uart_protocol
    #(IMG_SZ = 784<<3)
    (
    input  logic              uart_sampling_clk, rst, data_rdy,
    input  logic [7:0]        uart_byte,
    output logic              start, train, resend,
    output logic [7:0]        label,
    output logic [2:0]        cs_out,
    output logic [9:0]        data_count,
    output logic [IMG_SZ-1:0] image);

    enum logic [2:0] {s_start=3'b111, s_train=3'b001, s_data=3'b010, s_label=3'b011, s_check=3'b100, s_stop=3'b101,
                      s_fill=3'b110} cs, ns;
    assign cs_out = cs;

    logic shift, inc, resent, set_resent, next_resent, set_label, clr_checksum, inc_data, clr_data, clr_image;
    logic [15:0] count, next_count; // 16 bits should be big enough for our IMG_SZs
    logic [7:0]  checksum, checksum_add, result, next_label;
    logic [10:0] timeout;
    
    always_ff @(posedge uart_sampling_clk, posedge rst) begin 
        if (rst) begin
            cs <= s_start;
            image <= '0;
            label <= 8'd0;
            count <= 16'd0;
            checksum <= 8'd0;
            resent <= 1'b0;
            data_count <= 10'd0;
        end
        else begin 
            cs <= ns;
            // Shift image data into this register
            image <= (clr_image) ? '0 : 
                     (shift) ? {uart_byte, image[IMG_SZ-1:8]} : image;
            label <= (set_label) ? next_label : label;
            count <= next_count;
            checksum <= (clr_checksum) ? 8'd0 : result;
            resent <= (set_resent) ? next_resent: resent;
            data_count <= (clr_data) ? 10'd0 : 
                          (inc_data) ? data_count + 10'd1 : data_count;

        end
    end

    // Use one's complement addition to calculate checksum because it's
    // better for catching errors
    ones_comp_add add (.A(checksum), .B(checksum_add), .C(result));
     
    always_comb begin
        shift = 1'b0;
        start = 1'b0;
        train = 1'b0;
        next_count = 16'd0;
        checksum_add = 8'd0;
        resend = 1'b0;
        set_resent = 1'b0;
        next_resent = 1'b0;
        set_label = 1'b0;
        next_label = 8'd0;
        clr_checksum = 1'b0;
        inc_data = 1'b0;
        clr_data = 1'b0;
        clr_image = 1'b0;

        case (cs)
            s_start: begin
                ns = (data_rdy && uart_byte == `START) ? s_train : s_start;
                clr_data = (data_rdy && uart_byte == `START) ? 1'b0 : 1'b1;
            end
            s_train: begin
                ns = (data_rdy && (uart_byte == `TRAIN || uart_byte == `TEST)) 
                     ? s_label : s_train;
                //ns = (data_rdy) ? s_data : s_train; // just goes even if not train or test, defaults to test
                // Asserted for one cycle, buffered and cleared in control unit
                train = (data_rdy && uart_byte == `TRAIN) ? 1'b1 : 1'b0;
                //shift = (data_rdy && uart_byte == `TRAIN) ? 1'b1 : 1'b0;
                clr_image = (data_rdy && uart_byte == `TRAIN) ? 1'b0 : 1'b1;
            end
            s_label: begin
                ns = (data_rdy) ? s_data : s_label; 
                set_label = (data_rdy) ? 1'b1 : 1'b0;
                next_label = (data_rdy) ? uart_byte : 8'd0;
                checksum_add = uart_byte;
            end
            s_data: begin
                // Shift in all the pixel data
                inc_data = (data_rdy) ? 1'b1 : 1'b0;
                ns = (data_rdy && data_count == 10'd783) ? s_check : s_data; 
                shift = (data_rdy) ? 1'b1 : 1'b0;
                next_count = (data_rdy) ? count + 16'd8 : count;
                checksum_add = uart_byte;
            end
            /*s_fill: begin
                // Shift in all the pixel data
                inc_data = 1;
                ns = (data_count == 10'd783) ? s_start : s_fill;
                start = (data_count = 10'd783) ? 1 : 0; 
                shift = 1;
                checksum_add = uart_byte;
            end*/
            s_check: begin
                /*ns = (~resent) ? ((data_rdy) ? 
                                 ((uart_byte == checksum) ? s_stop : s_start) :
                                 s_check) : s_stop;*/
                                 
                /*ns = (~resent) ? ((data_rdy) ? 
                                 ((uart_byte != checksum) ? s_stop : s_start) :
                                 s_check) : s_stop; //Wrong on purpose to bypass check*/
                ns = (~resent) ? 
                     ((data_rdy) ? s_start : s_check) 
                     : s_start;
                // Only resend once
                // Resend in the case checksum doesn't match given checksum
                /*resend = (~resent) ? ((data_rdy) ? 
                                     ((uart_byte == checksum) ? 1'b0 : 1'b1) 
                                     : 1'b0) : 1'b0;
                set_resent = (~resent) ? ((data_rdy) ? 
                                     ((uart_byte == checksum) ? 1'b0 : 1'b1) 
                                     : 1'b0) : 1'b0; // wrong maybe when uncommented
                next_resent = (~resent) ? ((data_rdy) ? 
                                     ((uart_byte == checksum) ? 1'b0 : 1'b1) 
                                     : 1'b0) : 1'b0;*/
                clr_checksum = (~resent) ? 
                               ((data_rdy) ? 1'b1 : 1'b0) 
                               : 1'b1;
                start = (data_rdy) ? 1'b1 : 1'b0;
            end
            /*s_stop: begin
                ns = (data_rdy && uart_byte == `STOP) ? s_start : s_stop;
                set_resent = (data_rdy && uart_byte == `STOP) ? 1'b1 : 1'b0;
                next_resent = 1'b0;
                // Asserted for one cycle, buffered and cleared in control unit
                start = (data_rdy && uart_byte == `STOP) ? 1'b1 : 1'b0;
                clr_checksum = (data_rdy && uart_byte == `STOP) ? 1'b1 : 1'b0;
            end*/
        endcase
    end

endmodule: uart_protocol
