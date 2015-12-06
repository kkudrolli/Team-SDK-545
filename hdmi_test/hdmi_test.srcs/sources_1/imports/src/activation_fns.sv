`define FIXED_5       (5<<16)
`define FIXED_1       (1<<16)
`define FIXED_2_375   32'h26000
`define FIXED_0_84375 32'h0D800
`define FIXED_0_03125 32'h00800
`define FIXED_0_125   32'h02000
`define FIXED_0_625   32'h0A000
`define FIXED_0_25    32'h04000
`define FIXED_0_5     32'h08000
/*
module fixed_mult(input [31:0] a,b,
                  output logic [31:0] c);
    logic [63:0] a_64,b_64,c_64;
    always_comb begin
        a_64 = a;
        b_64 = b;
        c_64 = a_64*b_64;
        c_64 = (c_64>>16);
        c = c_64[31:0];
    end

endmodule: fixed_mult
*/
/*
module test_fixed_mult;

    logic [31:0] a,b,c;
    fixed_mult fm(a,b,c);

    initial begin
        a = 5<<16;
        b = 1<<16;
        #1;
        $display("c=%x",c);
        assert(c==32'h50000);
        a = 12<<16;
        b = 3<<16;
        #1;
        $display("c=%x",c);
        assert(c==32'h240000);
    end

endmodule: test_fixed_mult
*/
/*
module piecewise_sigmoid(input [31:0] in,
                         output logic [31:0] out);
    always_comb begin
        if(in>=FIXED_5) out = FIXED_1;
        else if ((in >= FIXED_2_375) && (in < FIXED_5)) out = fixed_mult(FIXED_0_03125, in) + FIXED_0_84375;
        else if ((in >= FIXED_1) && (in < FIXED_2_375)) out = fixed_mult(FIXED_0_125, in) + FIXED_0_625;
        else out = fixed_mult(FIXED_0_25, in) + FIXED_0_5;
    end
endmodule: piecewise_sigmoid
*/


module linear_fn(input [31:0] in,
                 output logic [31:0] out);

    assign out = in >> 5;
    
endmodule: linear_fn

module sigmoid_approx_fn(input logic clk, input logic rst,
                         input logic enable,
			             input logic [31:0]  in,
                         output logic [31:0] out);

   function logic [31:0] piecewise_sig_stage1(logic [31:0] in);
      if(in>=`FIXED_5) 
	piecewise_sig_stage1 = `FIXED_1;
      else if ((in >= `FIXED_2_375) && (in < `FIXED_5)) 
	piecewise_sig_stage1 = (in>>5);
      else if ((in >= `FIXED_1) && (in < `FIXED_2_375))
	piecewise_sig_stage1 = (in>>3);
      else 
	piecewise_sig_stage1 = (in>>2);
   endfunction

   function logic [31:0] piecewise_sig_stage2(logic [31:0] in, logic [31:0] temp);
      if(in>=`FIXED_5)
	piecewise_sig_stage2 = `FIXED_1;
      else if ((in >= `FIXED_2_375) && (in < `FIXED_5)) 
	piecewise_sig_stage2 = temp + `FIXED_0_84375;
      else if ((in >= `FIXED_1) && (in < `FIXED_2_375))
	piecewise_sig_stage2 = temp + `FIXED_0_625;
      else 
	piecewise_sig_stage2 = temp + `FIXED_0_5;
   endfunction

   
   logic [31:0] 			     temp1, temp2, result;
   logic 				     sign;  
   always_ff @(posedge clk, posedge rst) begin
      if (rst) begin
         temp1 <= 32'b0;
         temp2 <= 32'b0;
         result <= 32'b0;
         sign <= 1'b0;
      end else if (enable) begin
         temp1 <= in[31] ? piecewise_sig_stage1(~in+1) : piecewise_sig_stage1(in);
         temp2 <= in[31] ? ~in+1 : in;
         sign <= in[31];
         result <= sign ? `FIXED_1 - piecewise_sig_stage2(temp2, temp1) : piecewise_sig_stage2(temp2, temp1);
      end
   end

   always_comb begin
      if(result == 0) out = 1;
      else out = result;
   end

endmodule: sigmoid_approx_fn

/*
module sigmoid_approx_fn(input [31:0] in,
                         output logic [31:0] out);

	function logic [31:0] piecewise_sigmoid(logic [31:0] in);
			if(in>=`FIXED_5) 
				piecewise_sigmoid = `FIXED_1;
			else if ((in >= `FIXED_2_375) && (in < `FIXED_5)) 
				piecewise_sigmoid = (in>>5) + `FIXED_0_84375;
			else if ((in >= `FIXED_1) && (in < `FIXED_2_375))
				piecewise_sigmoid = (in>>3) + `FIXED_0_625;
			else
				piecewise_sigmoid = (in>>2) + `FIXED_0_5;
	endfunction

    logic sign;

    always_comb begin
        sign = in[31];
        if(sign) out = `FIXED_1 - piecewise_sigmoid(~in+1);
        else out = piecewise_sigmoid(in);
        if(out==0) out = 1;
        else out = out;
    end

endmodule: sigmoid_approx_fn*/

/*
module sigmoid_approx_drv(input [31:0] in,
                          output logic [31:0] out);

    logic [31:0] out_saf;

	function logic [31:0] fixed_mult(logic [31:0] a,b);
		logic [63:0] a_64,b_64,c_64;
		a_64 = a;
		b_64 = b;
		c_64 = a_64*b_64;
		c_64 = (c_64>>16);
		fixed_mult = c_64[31:0]; 
	endfunction

    sigmoid_approx_fn saf(in,out_saf);
    assign out = fixed_mult(out_saf,(`FIXED_1-out_saf));

endmodule: sigmoid_approx_drv*/
/*
module test;
    logic [31:0] in, out;

    sigmoid_approx_fn saf(in,out);

    initial begin
        in <= `FIXED_1;
        #1;
        $display("out=%x",out);
        assert(out==32'h0c000);

        in <= `FIXED_5;
        #1;
        $display("out=%x",out);
        assert(out==1<<16);

        in <= 100<<16;
        #1;
        $display("out=%x",out);
        assert(out==1<<16);

        in <= 0;
        #1;
        $display("out=%x",out);
        assert(out==`FIXED_0_5);

        in <= 32'h02c000;
        #1;
        $display("out=%x",out);
        assert(out==32'h0ee00);

        in <= 32'h06000;
        #1;
        $display("out=%x",out);
        assert(out==32'h09800);

        in <= 32'h06000000;
        #1;
        $display("out=%x",out);
        assert(out==1<<16);

        in <= 32'h018000;
        #1;
        $display("out=%x",out);
        assert(out==32'h0d000);

        in <= 32'hfffe8000;
        #1;
        $display("out=%x",out);
        assert(out==32'h03000);

        in <= 32'hffff0000;
        #1;
        $display("out=%x",out);
        assert(out==32'h04000);

        in <= 32'hffffe000;
        #1;
        $display("out=%x",out);
        assert(out==32'h07800);

        in <= 32'hfffd4000;
        #1;
        $display("out=%x",out);
        assert(out==32'h01200);

        in <= 32'hfffa0000;
        #1;
        $display("out=%x",out);
        assert(out==32'h0001);

        $finish;
    end

endmodule: test
*/
