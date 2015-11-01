/*
 * Authors: Kais Kudrolli, DJ Park, Sohil Shah
 *
 * Description: Main SystemVerilog RTL of our neural network. 
 *
 */

module deep
  (clk, rst, start, image, label_in, image_in);
   
   // Inputs
   input logic clk, rst;
   input logic start;
   input logic [31:0] [783:0] image_in;
   input logic [7:0] 	      label_in;
   
   // Outputs
   output logic [2351:0]      image;

   
   control_unit cu (.clk, .rst, .start, .train (1'b0), .bp_done, .fp_done, .drawn, 
		    .label_in, .image (image_in), .do_fp, .do_bp, .draw, .ack, 
		    .label_out, .image_out);

   tile t (.clk, .rst, );
   
endmodule: deep

