`define MAX_ROWS  60
/*`define GRAY      32'h00a0a0a0
`define RED       32'h00d00000
`define GREEN     32'h0000cc33
`define BLUE      32'h003366ff*/
`define BG_COLOR  32'h002080c0
`define BAR_WIDTH 5'd24
`define BASE      (720*449)+379

module bar_graph(
    input  logic             clk, rst, start_graph, done, 
    input  logic [7:0]       first, second, third,
    input  logic [9:0][31:0] result,
    output logic             graphing,
    output logic [3:0]       we,
    output logic [18:0]      addr_w,
    output logic [31:0]      data_in);

    logic [7:0]       first_buf, second_buf, third_buf; 
    logic [9:0][31:0] result, result_buf;

    logic [3:0] bar_count; // Which bar we're drawing
    logic [$clog2(`MAX_ROWS)-1:0] row_count; // Which row we're drawing
    logic [4:0] pix_count; // Which pixel in a row we're drawing

    logic [31:0] color, cur_result;
    logic [$clog2(`MAX_ROWS)-1:0] num_rows; 

    enum logic [1:0] {s_idle, s_graph, s_bar, s_row} state;

    // Register all result values on a done signal
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            first_buf <= 8'd0;
            second_buf <= 8'd0;
            third_buf <= 8'd0;
            result_buf <= 'd0;
        end else if (done) begin
            first_buf <= first;
            second_buf <= second;
            third_buf <= third;
            result_buf <= result;
        end
    end

    // FSM to control write to hdmi
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            graphing <= 1'd0;
            we <= 4'd0;
            addr_w <= 19'd0;
            data_in <= 32'd0;
        end else begin
        
            we <= 4'd0;
            addr_w <= 19'd0;
            data_in <= 32'd0;
            case (state) 

                s_idle: begin
                    state <= (start_graph) ? s_graph : s_idle;
                    bar_count <= 4'd0; 
                    row_count <= 'd0;
                    pix_count <= 5'd0;
                    graphing <= 1'd0;
                end

                s_graph: begin
                    state <= (bar_count == 4'd10) ? s_idle : s_bar;
                    row_count <= 'd0;
                    graphing <= 1'd1;
                end

                s_bar: begin
                    state <= (row_count == `MAX_ROWS) ? s_graph : s_row;
                    bar_count <= (row_count == `MAX_ROWS) ? bar_count + 4'd1 : bar_count;
                    pix_count <= 5'd0;
                end

                s_row: begin
                    state <= (pix_count == `BAR_WIDTH - 1) ? s_bar : s_row; 
                    row_count <= (pix_count == `BAR_WIDTH - 1) ? row_count + 'd1 : row_count;
                    pix_count <= pix_count + 5'd1;
                    we <= 4'd1;
                    addr_w <= `BASE + 2 + (bar_count*28) + pix_count - (row_count*720);
                    data_in <= (row_count > num_rows) ? `BG_COLOR : color;
                end

                default: state <= s_idle;
            endcase
        end
    end

    // Mux to get the current result being graphed
    assign cur_result = result_buf[bar_count];

    // Get the color of the current number being drawn
    /*always_comb begin
        if      (bar_count == first_buf[3:0])  color = `BLUE;
        else if (bar_count == second_buf[3:0]) color = `GREEN;
        else if (bar_count == third_buf[3:0])  color = `RED;
        else                                   color = `GRAY;
    end*/

    // Get the number of rows to draw for the number being graphed
    always_comb begin
        if (cur_result < 32'd2) begin
            num_rows = 'd1;
            color = 32'h00ffffff;
        end else if (cur_result < 32'd4400)  begin
            num_rows = 'd4;
            color = 32'h00fff9ef;
        end else if (cur_result < 32'd8800)  begin 
            num_rows = 'd8;
            color = 32'h00fff2cc;
        end else if (cur_result < 32'd13200) begin 
            num_rows = 'd12;
            color = 32'h00ffecb3;
        end else if (cur_result < 32'd17600) begin 
            num_rows = 'd16;
            color = 32'h00ffe699;
        end else if (cur_result < 32'd22000) begin
            num_rows = 'd20;
            color = 32'h00ffdf80;
        end else if (cur_result < 32'd26400) begin 
            num_rows = 'd24;
            color = 32'h00ffd966;
        end else if (cur_result < 32'd30800) begin 
            num_rows = 'd28;
            color = 32'h00ffd580;
        end else if (cur_result < 32'd35200) begin 
            num_rows = 'd32;
            color = 32'h00ffd24d;
        end else if (cur_result < 32'd39600) begin 
            num_rows = 'd36;
            color = 32'h00ffd012;
        end else if (cur_result < 32'd44000) begin 
            num_rows = 'd40;
            color = 32'h00ffcc33;
        end else if (cur_result < 32'd48400) begin 
            num_rows = 'd44;
            color = 32'h00ffca00;
        end else if (cur_result < 32'd52800) begin 
            num_rows = 'd48;
            color = 32'h00ffc61a;
        end else if (cur_result < 32'd57200) begin
            num_rows = 'd52;
            color = 32'h00ffc416;
        end else if (cur_result < 32'd61600) begin 
            num_rows = 'd56;
            color = 32'h00ffc107;
        end else begin
            num_rows = 'd60;
            color = 32'h00ffbf00;
        end
    end

endmodule: bar_graph
















