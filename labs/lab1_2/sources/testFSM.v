/* This example is an FSM that interacts with the lcd_control.v module.  
   It first sends the string "18545" to the LCD module
   It then waits for the nextString input to be asserted
   It then sends the string "ECE" to the LCD module
   It then waits forever.
 */
 
module testFSM(clkFSM,
					resetFSM,
					initDone,
					writeDone,
					nextString,
					data, 
					writeStart);
					
	input clkFSM;
	input resetFSM;
	input initDone;
	input writeDone;
	input	nextString;
	
	output [7:0]	data;
	output			writeStart;
	
	reg [7:0]		data;
	reg 		 		writeStart;
	reg [5:0] 		state,next_state;
	
	`define idle 	     6'b000000
	`define data1	     6'b000001
	`define wait1	     6'b100001
	`define data2	     6'b000010
	`define wait2	     6'b100010
	`define data3	     6'b000011
	`define wait3	     6'b100011
	`define data4	     6'b000100
	`define wait4	     6'b100100
	`define data5	     6'b000101
	`define wait5	     6'b100101
	`define data6	     6'b000110
	`define wait6	     6'b100110
	`define data7	     6'b000111
	`define wait7	     6'b100111
	`define data8	     6'b001000
	`define wait8	     6'b101000
	`define data9	     6'b001001
    `define wait9       6'b101001
    `define data10	     6'b001010
    `define wait10      6'b101010
    `define data11	     6'b001011
    `define wait11      6'b101011
    `define data12	     6'b001100
    `define wait12      6'b101100    
    `define data13	     6'b001101
    `define wait13      6'b101101    
	`define waitClear   6'b011111
	`define waitClear_1   6'b011110
	`define finish      6'b111111
	
	/* first write 18545, then write ECE to LCD */
	always @ (clkFSM or state or initDone or writeDone or nextString)
		begin
			next_state <= `idle;
			data = 8'b00000000;
			writeStart = 'b0;
			case(state)
				`idle : 
					begin
						if(initDone == 1'b1) 
							next_state <= `data1;
						else
							next_state <= `idle;
					end
				`data1 :
					begin
						data = 8'b01010011;		//S
						writeStart = 1'b1;
						next_state <= `wait1;
					end
				`wait1 :
					begin
						data = 8'b01010011;
						if(writeDone == 1'b1)
							next_state <= `data2;
						else
							next_state <= `wait1;
					end
				`data2 :
					begin
						data = 8'b01001111;		//O
						writeStart = 1'b1;
						next_state <= `wait2;
					end
				`wait2 :
					begin
						data = 8'b01001111;
						if(writeDone == 1'b1)
							next_state <= `data3;
						else
							next_state <= `wait2;
					end
				`data3 :
					begin
						data = 8'b01001000;		//H
						writeStart = 1'b1;
						next_state <= `wait3;
					end
				`wait3 :
					begin
						data = 8'b01001000;
						if(writeDone == 1'b1)
							next_state <= `data4;
						else
							next_state <= `wait3;
					end
				`data4 :
					begin
						data = 8'b01001001;		//I
						writeStart = 1'b1;
						next_state <= `wait4;
					end
				`wait4 :
					begin
						data = 8'b01001001;
						if(writeDone == 1'b1)
							next_state <= `data5;
						else
							next_state <= `wait4;
					end
				`data5 :
					begin
						data = 8'b01001100;		//L
						writeStart = 1'b1;
						next_state <= `wait5;
					end
				`wait5 :
					begin
						data = 8'b01001100;
						if(writeDone == 1'b1)
							next_state <= `waitClear;
						else
							next_state <= `wait5;
					end
				`waitClear :
					begin
						if(nextString == 'b1)
							begin
								next_state <= `data6;
							end
						else
							begin
								next_state <= `waitClear;
							end
					end
				`data6 :
					begin
						data = 8'b00100000;		//space
						writeStart = 1'b1;
						next_state <= `wait6;
					end
				`wait6 :
					begin
						data = 8'b00100000;
						if(writeDone == 1'b1)
							next_state <= `data7;
						else
							next_state <= `wait6;
					end
				`data7 :
					begin
						data = 8'b01001011;		//K
						writeStart = 1'b1;
						next_state <= `wait7;
					end
				`wait7 :
					begin
						data = 8'b01001011;
						if(writeDone == 1'b1)
							next_state <= `data8;
						else
							next_state <= `wait7;
					end
				`data8 :
					begin
						data = 8'b01000001;		//A
						writeStart = 1'b1;
						next_state <= `wait8;
					end
				`wait8 :
                    begin
                        data = 8'b01000001;
                        if(writeDone == 1'b1)
                            next_state <= `data9;
                        else
                            next_state <= `wait8;
                    end
                 `data9 :
                    begin
                        data = 8'b01001001;        //I
                        writeStart = 1'b1;
                        next_state <= `wait9;
                    end
                 `wait9 :
                    begin
                        data = 8'b01001001;
                        if(writeDone == 1'b1)
                            next_state <= `data10;
                        else
                            next_state <= `wait9;
                    end
                 `data10 :
                    begin
                        data = 8'b01010011;        //S
                        writeStart = 1'b1;
                        next_state <= `wait10;
                    end
               `wait10 :
                         begin
                             data = 8'b01010011;
                             if(writeDone == 1'b1)
                                 next_state <= `waitClear_1;
                             else
                                 next_state <= `wait10;
                         end
                 `waitClear_1 :
                    begin
                        if(nextString == 'b1)
                            begin
                                next_state <= `data11;
                            end
                        else
                            begin
                                next_state <= `waitClear_1;
                            end
                    end
                `data11 :
                    begin
                        data = 8'b00100000;        //space
                        writeStart = 1'b1;
                        next_state <= `wait11;
                    end
               `wait11 :
                    begin
                        data = 8'b00100000;
                        if(writeDone == 1'b1)
                            next_state <= `data12;
                        else
                            next_state <= `wait11;
                    end
               `data12 :
                    begin
                        data = 8'b01000100;        //D
                        writeStart = 1'b1;
                        next_state <= `wait12;
                    end
               `wait12 :
                    begin
                        data = 8'b01000100;
                        if(writeDone == 1'b1)
                            next_state <= `data13;
                        else
                            next_state <= `wait12;
                    end
               `data13 :
                    begin
                        data = 8'b01001010;        //J
                        writeStart = 1'b1;
                        next_state <= `wait13;
                    end
               `wait13 :
                    begin
                        data = 8'b01001010;
                        if(writeDone == 1'b1)
                            next_state <= `finish;
                        else
                            next_state <= `wait13;
                    end
				`finish :
					begin
						next_state <= `finish;
					end
			
			endcase	
		
		end
	
	//registers state variables
	always @ (posedge clkFSM)
		begin
			if (resetFSM) 
				begin
					state <= `idle;			
				end
			else 
				begin
					state <= next_state;			
				end
		end // always 
					
endmodule
