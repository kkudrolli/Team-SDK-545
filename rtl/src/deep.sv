/*
 * Authors: Kais Kudrolli, DJ Park, Sohil Shah
 *
 * Description: Main SystemVerilog RTL of our neural network. 
 *
 */
/*
module deep
  (clk, rst, do_fp, label_in, image_in, result, done);
   
   // Inputs
   input logic                clk, rst;
   input logic                do_fp;
   input logic [7:0] 	      label_in;
   input logic [783:0] [31:0] image_in;
   
   // Outputs
   output logic [319:0]       result;
   output logic 	      done;

   logic 		      get_weights0, get_weights1;
   
   logic [4095:0] 	      values_0;
   logic [319:0] 	      values_1;
   
   logic [127:0] [31:0]       weights0;
   logic [9:0] [31:0] 	      weights1;
   
   logic [783:0] [31:0]       image;
   
   assign weights0 = values_0;
   assign weights1 = values_1;
   
   integer 		      i;
   always_comb begin
      for (i = 0; i < 784; i++)
        image[i] = (image_in[i] << 9);
   end
   
   tile t (.clk, .rst, .start (do_fp), .done (done), .get_weights0, .get_weights1, 
	   .image (image), .weights0, .weights1, .result);
   
   weights wf (.clka (clk), .rst, .start_0 (get_weights0), .start_1 (get_weights1), 
               .values_0, .values_1);
   
endmodule: deep*/


module deep
  (clk, rst, start, label_in, image_in, result, done);
   
   // Inputs
   input logic clk, rst;
   input logic start;
   input logic [783:0] [31:0] image_in;
   input logic [7:0] 	      label_in;
   
   // Outputs
   output logic [9:0] [31:0]  result;
   output logic 	      done;
   
   logic 		      fp_done;
   logic 		      do_fp, do_bp, draw, ack;
   
   logic 		      get_weights0, get_weights1;
   
   logic [127:0] [31:0]       weights0;
   logic [9:0] [31:0] 	      weights1;

   assign done = fp_done;

   control_unit cu (.clk, .rst, .start, .train (1'b0), .bp_done (1'b0), .fp_done, 
		    .drawn (1'b1), .label_in (), .image_in (), .do_fp, .do_bp, 
		    .draw, .ack, .label_out (), .image_out ());
   
   tile t (.clk, .rst, .start (do_fp), .done (fp_done), .get_weights0, .get_weights1, 
	   .image (image_in), .weights0, .weights1, .result);
   
   weights wf (.clka (clk), .rst, .start_0 (get_weights0), .start_1 (get_weights1), 
	      .values_0 (weights0), .values_1 (weights1));
   
endmodule: deep
