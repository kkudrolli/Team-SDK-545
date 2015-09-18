module lcd_top(SYSCLK_P, SYSCLK_N,
			   GPIO_SW_C,			   
			   GPIO_SW_E,			   
			   GPIO_SW_S,			   
			   GPIO_SW_W,			   
			   LCD_FPGA_RS, LCD_FPGA_RW, LCD_FPGA_E,
			   LCD_FPGA_DB7, LCD_FPGA_DB6, LCD_FPGA_DB5, LCD_FPGA_DB4);
		
	input	   SYSCLK_P, SYSCLK_N;
	/* switch C is reset, E is clear, S is resetFSM, W is nextString */
	input	   GPIO_SW_C, GPIO_SW_E, GPIO_SW_S, GPIO_SW_W;	
	output	   LCD_FPGA_RW, LCD_FPGA_RS, LCD_FPGA_E, LCD_FPGA_DB7, LCD_FPGA_DB6, LCD_FPGA_DB5, LCD_FPGA_DB4;

    wire USER_CLK;

IBUFDS #(
.DIFF_TERM("TRUE"),
.IBUF_LOW_PWR("TRUE"),
.IOSTANDARD("DEFAULT")
)
clk_ibufds (
.O(USER_CLK),
.I(SYSCLK_P),
.IB(SYSCLK_N)
);

	wire		[2:0]	control_out; //rs, rw, en
	wire		[3:0]   out;
	wire				reset;
	
	wire	writeStart;
	wire	writeDone;
	wire	initDone;
	wire[7:0]	data;
	wire	clearAll;
	wire	resetFSM;
	wire	nextString;
	
	assign reset = GPIO_SW_C;
	assign resetFSM = GPIO_SW_S;
	assign clearAll = GPIO_SW_E;
	assign nextString = GPIO_SW_W;
	
	assign LCD_FPGA_DB7 = out[3];
	assign LCD_FPGA_DB6 = out[2];
	assign LCD_FPGA_DB5 = out[1];
	assign LCD_FPGA_DB4 = out[0];	
	
	assign LCD_FPGA_RS = control_out[2];
	assign LCD_FPGA_RW = control_out[1];
	assign LCD_FPGA_E  = control_out[0];
	
	reg slowerCLK;
    reg [3:0] cnt;
    always @(posedge reset or posedge USER_CLK) begin
        if (reset) begin
            slowerCLK <= 1'b0;
            cnt <= 8'b0;
        end else begin
           cnt <= cnt+1;
           if(cnt) slowerCLK <= slowerCLK;
           else slowerCLK <= ~slowerCLK;
        end
    end
	
	lcd_control		lcd(.rst(reset), .clk(slowerCLK), .control(control_out), .sf_d(out),
							 .writeStart(writeStart), .initDone(initDone), .writeDone(writeDone), 
							 .dataIn(data), 
							 .clearAll(clearAll));
								
	testFSM			myTestFsm(.clkFSM(slowerCLK), .resetFSM(resetFSM), .data(data),
									 .initDone(initDone), .writeStart(writeStart),
									 .nextString(nextString),
									 .writeDone(writeDone));

endmodule
