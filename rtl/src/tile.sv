module tile
  (clk, rst, start_fp, start_bp, done, get_weights0, get_weights1, image, 
   weights0, weights1, result, label, wchange1, wchange0, update0, update1);
   
   parameter NUM_NEURONS = 128;
   parameter IMG_SZ = 784;
   parameter OUTPUT_SZ = 10;
   
   // Inputs
   input logic clk, rst;
   input logic start_fp, start_bp;
   input logic [IMG_SZ-1:0] [31:0] image;
   input logic [NUM_NEURONS-1:0] [31:0] weights0;
   input logic [OUTPUT_SZ-1:0] [31:0] 	weights1;
   input logic [7:0] 			label;
   
   // Outputs
   output logic 			done;
   output logic 			get_weights0, get_weights1;
   output logic [OUTPUT_SZ-1:0] [31:0] 	result;
   output logic [OUTPUT_SZ-1:0] [31:0] 	wchange1;
   output logic [NUM_NEURONS-1:0] [31:0] wchange0;
   output logic 			 update0, update1;   
   
   
   logic [IMG_SZ-1:0] [31:0] 		 image_reg;
   
   logic 				 clear;
   logic [NUM_NEURONS-1:0] [31:0] 	 acc_lay0;
   logic [NUM_NEURONS-1:0] [31:0] 	 hidden;
   logic [OUTPUT_SZ-1:0]   [31:0] 	 acc_lay1;
   
   logic [$clog2(IMG_SZ):0] 		 lay0_idx;
   logic [$clog2(NUM_NEURONS):0] 	 lay1_idx;

   logic 				 enable_0, enable_1;

   logic [NUM_NEURONS-1:0] [31:0] 	 delta_drv;
   
   logic [OUTPUT_SZ-1:0] [31:0] 	 delta_target;
   logic [OUTPUT_SZ-1:0] [31:0] 	 ideal;
   
   enum 				 logic [2:0] {S_IDLE, S_FPROP_LAYER1, S_FPROP_LAYER2, 
						      S_BPROP_LAYER1, S_BPROP_LAYER2, 
						      S_BPROP_CALCDELTA, S_DONE} cs, ns;
   

   always_ff @(posedge clk, posedge rst)
     if (rst) cs <= S_IDLE;
     else cs <= ns;

   always_ff @(posedge clk)
     if (start_fp || start_bp) image_reg <= image;


   integer 				 j;
   always_comb begin
      ideal = '0;
      ideal[label] = `FIXED_1;
      
      for (j = 0; j < OUTPUT_SZ; j++)
	delta_target[j] = ideal[j] - result[j];
   end
   

   genvar i;
   // Generate forward propagation neurons
   generate
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


   // Generate backwards propagation multipliers
   generate
      for (i = 0; i < NUM_NEURONS; i++) begin
	 neuron delta1(.clk, .rst, .clear, .en (), .weight, .data, .accum);
	 sigmoid_approx_drv fnet();
	 multiplier mult1();
	 multiplier mult2(delta_drv[i], image_reg[lay0_idx], wchange0[i]);
      end
      for (i = 0; i < OUTPUT_SZ; i++) begin
	 multiplier mult3(delta_target[i], hidden[lay1_idx], wchange1[i]);
      end
   endgenerate

   
   always_comb begin
      done = 1'b0;
      clear = 1'b0;
      enable_0 = 1'b0;
      enable_1 = 1'b0;
      get_weights0 = 1'b0;
      get_weights1 = 1'b0;
      case (cs)
	S_IDLE: begin
	   clear = start_fp || start_bp;
	   ns = (start_fp || start_bp) ? S_FPROP_LAYER1 : S_IDLE;
	   get_weights0 = start_fp || start_bp;
	end

	S_FPROP_LAYER1: begin
	   ns = lay0_idx < IMG_SZ ? S_FPROP_LAYER1 : S_FPROP_LAYER2;
	   get_weights1 = lay0_idx >= IMG_SZ;
	   enable_0 = 1;
	end

	S_FPROP_LAYER2: begin
	   enable_1 = 1;
	   ns = lay1_idx < NUM_NEURONS ? S_FPROP_LAYER2 : S_DONE;
	end

	S_BPROP_LAYER2: begin
	   ns = lay1_idx < NUM_NEURONS-1 ? S_BPROP_LAYER2 : S_BPROP_LAYER1;
	end

	S_BPROP_CALCDELTA: begin

	end
	
	S_BPROP_LAYER1: begin

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
	   
	   S_FPROP_LAYER1: begin
	      lay0_idx <= lay0_idx + 1;
	   end
	   
	   S_FPROP_LAYER2: begin
	      lay1_idx <= '0;	      
	      lay1_idx <= lay1_idx < NUM_NEURONS : lay1_idx + 1 : '0;
	   end

	   S_BPROP_LAYER2: begin
	      lay1_idx < lay1_idx + 1;
	   end

	   S_BPROP_CALCDELTA: begin
	      // Do nothing
	   end

	   S_BPROP_LAYER1: begin
	      lay0_idx <= lay0_idx + 1;
	   end
	   
	   default: ; // Do nothing
	 endcase
      end
   end
   
endmodule: tile
