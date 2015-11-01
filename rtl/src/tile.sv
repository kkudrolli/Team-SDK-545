module tile
  (clk, rst, start, done, get_weights, image, weights, result);
   
   parameter NUM_NEURONS = 128;
   parameter IMG_SZ = 784;
   parameter OUTPUT_SZ = 10;   
   
   // Inputs
   input logic clk, rst;
   input logic start;
   input logic [7:0] [IMG_SZ-1:0] image;
   input logic [NUM_NEURONS-1:0]  weights;
   
   
   // Outputs
   output logic 		  done;
   output logic 		  get_Weights;
   output logic [OUTPUT_SZ-1:0]   result;


   logic [7:0] [IMG_SZ-1:0] 	  image_reg;   
   
   enum logic [2:0] {S_IDLE, S_PROP_LAYER1, S_PROP_LAYER2, S_DONE} cs, ns;   

   logic clear;
   logic [31:0] acc_lay0, acc_lay1;   
   
   always_ff @(posedge clk, posedge rst)
     if (~rst) cs <= S_IDLE;
     else cs <= ns;

   always_ff @(posedge clk, posedge rst)
     if (rst) image_reg <= '0;
     else if (start) image_reg <= image;   
   

   genvar i;
   generate
      for (i = 0; i < NUM_NEURONS; i++) begin
	 neuron layer0 (.clk, .rst, .clear, .en (enable_0), .accum (acc_lay0));
      end
      for (i = 0; i < OUTPUT_SZ; i++) begin
	 neuron layer1 (.clk, .rst, .clear, .en (enable_1), .accum (acc_lay1));
      end
   endgenerate
   
   always_comb begin
      done = 1'b0;
      clear = 1'b0;
      enable_0 = 1'b0;
      enable_1 = 1'b0;      
      case (cs)
	S_IDLE: begin
	   clear = 1'b1;	   
	   ns = start ? S_PROP_LAYER1 : S_IDLE;	   
	end

	S_PROP_LAYER1: begin
	   enable_0 = 1'b1;	   
	end

	S_PROP_LAYER2: begin
	   enable_1 = 1'b1;	   
	end

	S_DONE: begin
	   done = 1'b1;
	   ns = S_IDLE;	   
	end
      endcase
   end
