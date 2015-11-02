module neuron
  (clk, rst, clear, en, weight, data, accum);
   
   // Inputs
   input logic clk, rst, clear, en;
   input logic [31:0] weight, data;
   
   // Outputs
   output logic [31:0] accum;
   
   always_ff @(posedge clk, posedge rst) begin
      if (rst) accum <= 32'b0;
      else if (clear) accum <= 32'b0;
      else
	accum <= accum + ((weight * data) >> 16);
   end
   
endmodule: neuron
