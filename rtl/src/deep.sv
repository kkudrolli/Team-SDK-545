/*
 * Authors: Kais Kudrolli, DJ Park, Sohil Shah
 *
 * Description: Main SystemVerilog RTL of our neural network. 
 *
 */

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
		    .drawn (1'b0), .label_in (), .image_in (), .do_fp, .do_bp, 
		    .draw, .ack, .label_out (), .image_out ());
   
   tile t (.clk, .rst, .start (do_fp), .done (fp_done), .get_weights0, .get_weights1, 
	   .image (image_in), .weights0, .weights1, .result);
   
   weight wf (.clka (clk), .rst, .start_0 (get_weights0), .start_1 (get_weights1), 
	      .values_0 (weights0), .values_1 (weights1));
   
endmodule: deep

