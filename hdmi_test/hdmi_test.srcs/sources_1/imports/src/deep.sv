/*
 * Authors: Kais Kudrolli, DJ Park, Sohil Shah
 *
 * Description: Main SystemVerilog RTL of our neural network. 
 *
 */

module deep
  (clk, rst, do_fp, label_in, image_in, result, done);
   
   // Inputs
   input logic                clk, rst;
   input logic                do_fp;
   input logic [7:0] 	      label_in;
   input logic [6271:0]       image_in;
   
   // Outputs
   output logic [319:0]       result;
   output logic 	          done;

   logic 		              get_weights0, get_weights1;
   
   logic [4095:0]             values_0;
   logic [319:0] 	          values_1;
   
   logic [128] [31:0]         weights0;
   logic [10] [31:0]          weights1;

   logic [784] [31:0]         image;
   logic [784] [7:0]          img_tmp;

   assign weights0 = values_0;
   assign weights1 = values_1;

   assign img_tmp = image_in;
   
   integer i;
   always_comb begin
       for (i = 0; i < 784; i++)
            image[i] = (img_tmp[i] << 9);
   end
   
   tile t (.clk, .rst, .start (do_fp), .done (done), .get_weights0, .get_weights1, 
	       .image (image), .weights0, .weights1, .result);
  
   weights wf (.clka (clk), .rst, .start_0 (get_weights0), .start_1 (get_weights1), 
               .values_0, .values_1);
   
endmodule: deep

