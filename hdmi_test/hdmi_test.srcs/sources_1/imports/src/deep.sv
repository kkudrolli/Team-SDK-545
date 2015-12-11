/*
 * Authors: Kais Kudrolli, DJ Park, Sohil Shah
 *
 * Description: Main SystemVerilog RTL of our neural network. 
 *
 */

module deep
  (clk, rst, do_fp, do_bp, label_in, image_in, result, done);
   
   // Inputs
   input logic                clk, rst;
   input logic                do_fp, do_bp;
   input logic [7:0] 	      label_in;
   input logic [6271:0]       image_in;
   
   // Outputs
   output logic [319:0]       result;
   output logic 	          done;

   logic 		              get_weights0, get_weights1;
   
   logic [4095:0]             values_0;
   logic [319:0] 	          values_1;
   
   logic [127:0] [31:0]         weights0;
   logic [9:0] [31:0]           weights1;

   logic [127:0] [31:0]         wchange0;
   logic [9:0] [31:0]           wchange1;

   logic               update0, update1;

   logic [783:0] [31:0]         image;
   logic [783:0] [7:0]          img_tmp;

   assign weights0 = values_0;
   assign weights1 = values_1;

   assign img_tmp = image_in;
   
   integer i;
   always_comb begin
       for (i = 0; i < 784; i++)
            image[i] = {15'd0, img_tmp[i], 9'd0};
   end
      
   tile t (.clk, .rst, .start_fp (do_fp), .start_bp (do_bp), .done (done), .get_weights0, 
           .get_weights1, .image (image), .weights0, .weights1, .result, .wchange0, .wchange1, 
           .update0, .update1, .label (label_in));
    
            
   weights wf (.clka (clk), .rst, .start_0 (get_weights0), .start_1 (get_weights1), 
               .values_0 (values_0), .values_1 (values_1), .update_0 (update0), 
               .update_1 (update1), .deltaWeights_0 (wchange0), .deltaWeights_1 (wchange1));

endmodule: deep

/*
module testbench();

    // Inputs
    logic                clk, rst;
    logic                do_fp, do_bp;
    logic [7:0]          label_in;
    logic [6271:0]       image_in;
    
    // Outputs
    logic [9:0] [31:0]   result;
    logic 	             done;

    assign image_in = ('h00000000000000000000000000000000000000000000000000000000000000000000000000000000000012cffe79000000000000000000000000000000000000000000000028dbfefe79000000000000000000000000000000000000000000000034fefef23d000000000000000000000000000000000000000000000034fefe8500000000000000000000000000000000000000000000000173fee01f00000000000000000000000000000000000000000000004dfefe26000000000000000000000000000000000000000000000023dbfecb030000000000000000000000000000000000000000000000a6fedd13000000000000000000000000000000000000000000000039f0fb4b000000000000000000000000000000000000000000000000b6fe7e0000000000000000000000000000000000000000000000003af8cd09000000000000000000000000000000000000000000000005bbfe850000000000000000000000000000000000000000000000003efef93b00000000000000000000000000000000000000000000002ceefe8100000000000000000000000000000000000000000000000053ffe916000000000000000000000000000000000000000000000012d1fd530000000000000000000000000000000000000000000000006afeec153b4343430e421100000000000000000000000000000000008cfefee5fafefefee1fee3a37248724300000000000000000000000034aac6c6c6c6c6c6c6c6f1fefefefede00000000000000000000000000000000000000000000243c979fb95400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000);
    deep DUT (.*);

    assign label_in = 8'h7;

    logic [7:0] max_result;
    logic [31:0] max;
    integer 	i;
    always_comb begin
      max = result[0];
      max_result = 0;
      for (i = 1; i < 10; i++) begin
         if (result[i] > max) begin
            max = result[i];
            max_result = i;
         end 
      end
    end
    
    initial begin
        clk <= 0;
        do_bp <= 0;
        do_fp <= 0;
        rst <= 1;
        #10;
        rst <= 0;
        forever #5 clk <= ~clk;
    end

    initial begin
        #50;
        do_bp <= 1;
        while (!done) begin
            @(posedge clk);
        end
        do_bp <= 0;
        #100;
        do_fp <= 1;
        while (!done) begin
            @(posedge clk);
        end
        do_fp <= 0;
        #100;                
        $finish;
    end

endmodule
*/