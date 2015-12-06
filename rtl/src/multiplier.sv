module multiplier
  (input logic [31:0] in1, 
   input logic [31:0] in2,
   output logic [31:0] out);
   
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

   assign out = fixed_mult(in1, in2);

endmodule: multiplier

module multiplier_div8
  (input logic [31:0] in1, 
   input logic [31:0] in2,
   output logic [31:0] out);
   
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

   always_comb begin
      out = fixed_mult(in1, in2);
      out = {{3{out[31]}}, out[31:3]};
   end
   
endmodule: multiplier_div8
