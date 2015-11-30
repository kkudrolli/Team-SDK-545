module neuron
  (clk, rst, clear, en, weight, data, accum);
   
   // Inputs
   input logic clk, rst, clear, en;
   input logic [31:0] weight, data;
   
   // Outputs
   output logic [31:0] accum;

   function logic [31:0] fixed_mult(logic [31:0] a,b);
      logic [63:0]     c;

      logic [31:0]     _a, _b;

      logic 	       sign;
      
      _a = a;
      _b = b;
      
      sign = a[31] ^ b[31];

      if (a[31]) _a = -_a;
      if (b[31]) _b = -_b;

      c = _a * _b;

      fixed_mult = c >> 16;
      fixed_mult = sign ? -fixed_mult : fixed_mult;
      
   endfunction   
   
   logic [31:0]        value;

   assign value = fixed_mult(data, weight);
   
   always_ff @(posedge clk, posedge rst) begin
      if (rst)        accum <= 32'b0;
      else if (clear) accum <= 32'b0;
      else if (en)    accum <= accum + value;
   end
   
endmodule: neuron
