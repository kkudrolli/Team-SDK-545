/*
 * Authors: Kais Kudrolli, DJ Park, Sohil Shah
 *
 * Description: Main SystemVerilog RTL of our neural network. 
 *
 */

module deep
  (clk, rst, do_fp, label_in, image_in, result, done);
   
   // Inputs
   input logic clk, rst;
   input logic do_fp;
   input logic [783:0] [7:0]  image_in;
   input logic [7:0] 	      label_in;
   
   // Outputs
   output logic [9:0] [31:0]  result;
   output logic 	          done;

   logic 		              get_weights0, get_weights1;
   
   logic [127:0] [31:0]       weights0;
   logic [9:0] [31:0] 	      weights1;

    logic [783:0] [31:0]      image;

   integer i;
   always_comb begin
       for (i = 0; i < 784; i++)
           image[i] = (image_in[i] << 9);
   end
   
   tile t (.clk, .rst, .start (do_fp), .done (done), .get_weights0, .get_weights1, 
	       .image (image), .weights0, .weights1, .result);
  
    assign weights0 = 32'hdead;
    assign weights1 = 32'hbeef;
   
   //weights wf (.clka (clk), .rst, .start_0 (get_weights0), .start_1 (get_weights1), 
//	           .values_0 (weights0), .values_1 (weights1));
   
endmodule: deep

