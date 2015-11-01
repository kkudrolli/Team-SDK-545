module register
  (clk, rst_l, in, out, en);

   parameter WIDTH = 32;
   
   always_ff @(posedge clk, negedge rst_l) begin
      if (~rst_l) out <= '0;
      else out <= en ? in : out;      
   end

endmodule: register
