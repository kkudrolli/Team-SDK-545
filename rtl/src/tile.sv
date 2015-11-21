module tile
  (clk, rst, start, done, get_weights0, get_weights1, image, 
   weights0, weights1, result);
   
   parameter NUM_NEURONS = 128;
   parameter IMG_SZ = 784;
   parameter OUTPUT_SZ = 10;   
   
   // Inputs
   input logic clk, rst;
   input logic start;
   input logic [IMG_SZ-1:0] [31:0] image;
   input logic [NUM_NEURONS-1:0] [31:0] weights0;
   input logic [OUTPUT_SZ-1:0] [31:0] 	weights1;   
   
   // Outputs
   output logic 			done;
   output logic 			get_weights0, get_weights1;
   output logic [OUTPUT_SZ-1:0] [31:0] 	result;
   
   
   logic [IMG_SZ-1:0] [31:0] 		image_reg;
   
   logic 				clear;
   logic [NUM_NEURONS-1:0] [31:0] 	acc_lay0;
   logic [NUM_NEURONS-1:0] [31:0] 	hidden;
   logic [OUTPUT_SZ-1:0]   [31:0] 	acc_lay1;
   
   logic [$clog2(IMG_SZ):0] 		lay0_idx;
   logic [$clog2(NUM_NEURONS):0] 	lay1_idx;

   logic 				enable_0, enable_1;
   
   enum logic [2:0] {S_IDLE, S_PROP_LAYER1, S_PROP_LAYER2, S_DONE} cs, ns;   


   always_ff @(posedge clk, posedge rst)
     if (rst) cs <= S_IDLE;
     else cs <= ns;

   always_ff @(posedge clk)
     if (start) image_reg <= image;   
   

   generate
      genvar i;
      for (i = 0; i < NUM_NEURONS; i++) begin
	 neuron layer0 (.clk, .rst, .clear, .en (enable_0), .weight (weights0[i]), 
			.data (image_reg[lay0_idx]), .accum (acc_lay0[i]));
	 sigmoid_approx_fn act_lay0(.clk, .rst, .in (acc_lay0[i]), .out (hidden[i]));
      end
      for (i = 0; i < OUTPUT_SZ; i++) begin
	 neuron layer1 (.clk, .rst, .clear, .en (enable_1), .weight (weights1[i]),
			.data (hidden[lay1_idx]), .accum (acc_lay1[i]));
	 sigmoid_approx_fn act_lay1(.clk, .rst, .in (acc_lay1[i]), .out (result[i]));
      end
   endgenerate

   integer j;
   always_comb begin
      done = 1'b0;
      clear = 1'b0;
      enable_0 = 1'b0;
      enable_1 = 1'b0;
      get_weights0 = 1'b0;
      get_weights1 = 1'b0;
      case (cs)
	S_IDLE: begin
	   clear = start;
	   ns = start ? S_PROP_LAYER1 : S_IDLE;
	   get_weights0 = start;
	end

	S_PROP_LAYER1: begin
	   ns = lay0_idx < IMG_SZ ? S_PROP_LAYER1 : S_PROP_LAYER2;
	   get_weights1 = lay0_idx >= IMG_SZ;
	   enable_0 = 1;
	end

	S_PROP_LAYER2: begin
	   enable_1 = 1;
	   ns = lay1_idx < NUM_NEURONS ? S_PROP_LAYER2 : S_DONE;
	end

	S_DONE: begin
	   done = 1'b1;
	   ns = S_IDLE;
	end

	default: ns = S_IDLE;	 
      endcase
   end

   always_ff @(posedge clk, posedge rst) begin
      if (rst) begin
	 lay0_idx <= '0;
	 lay1_idx <= '0;
      end
      else begin
	 case (cs)
	   S_IDLE, S_DONE: begin
	      lay0_idx <= '0;
	      lay1_idx <= '0;
	   end
	   
	   S_PROP_LAYER1: begin
	      lay0_idx <= lay0_idx + 1;
	   end
	   
	   S_PROP_LAYER2: begin	      
	      lay1_idx <= lay1_idx + 1;
	   end

	   default: ; // Do nothing
	 endcase
      end
   end
   
endmodule: tile
