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
   logic [7:0] 				 label_reg;
   
   logic 				 clear;
   logic [NUM_NEURONS-1:0] [31:0] 	 acc_lay0;
   logic [NUM_NEURONS-1:0] [31:0] 	 hidden;
   logic [OUTPUT_SZ-1:0]   [31:0] 	 acc_lay1;
   
   logic [$clog2(IMG_SZ):0] 		 lay0_idx;
   logic [$clog2(NUM_NEURONS):0] 	 lay1_idx;
   logic [$clog2(OUTPUT_SZ):0] 		 act_idx; 		 

   logic 				 enable_0, enable_1;
   logic 				 enable_delta;
   
   logic [NUM_NEURONS-1:0] [31:0] 	 delta_drv;

   logic [OUTPUT_SZ-1:0] [31:0] 	 delta_target;
   logic [OUTPUT_SZ-1:0] [31:0] 	 ideal;
   logic [OUTPUT_SZ-1:0] [31:0] 	 mult;

   logic [NUM_NEURONS-1:0] [31:0] 	 weight_matrix;
   logic [NUM_NEURONS-1:0] [31:0] 	 fprime_net;

   logic 				 bp;
   
   enum 				 logic [3:0] {S_IDLE, S_FPROP_LAYER1, S_FPROP_LAYER2, 
						      S_BPROP_LAYER1, S_BPROP_LAYER2, 
						      S_BPROP_CALCDELTA, S_INTER1, S_INTER2, 
						      S_DONE} cs, ns;
   

   always_ff @(posedge clk, posedge rst)
     if (rst) cs <= S_IDLE;
     else cs <= ns;

   always_ff @(posedge clk) begin
      if (start_fp || start_bp) image_reg <= image;
      if (start_bp) label_reg <= label;
   end
   
   always_ff @(posedge clk, posedge rst) begin
      if (rst) bp <= 1'b0;
      else if (start_fp) bp <= 1'b0;
      else if (start_bp) bp <= 1'b1;
   end
   
   integer 				 j;
   logic [9:0] [9:0] [3:0] 		 difference;
   assign difference = {{ 4'd0, 4'd13, 4'd10, 4'd12, 4'd13, 4'd10,  4'd9, 4'd12,  4'd8,  4'd9}, // 0
			{4'd13,  4'd0, 4'd14, 4'd14, 4'd10, 4'd14, 4'd14, 4'd10, 4'd14, 4'd14}, // 1
			{4'd10, 4'd14,  4'd0, 4'd10, 4'd14, 4'd10, 4'd11, 4'd12, 4'd13, 4'd12}, // 2
			{4'd12, 4'd14, 4'd10,  4'd0, 4'd12, 4'd11, 4'd13, 4'd14,  4'd8, 4'd12}, // 3
			{4'd13, 4'd10, 4'd14, 4'd12,  4'd0, 4'd13, 4'd14, 4'd14, 4'd14,  4'd7}, // 4
			{4'd10, 4'd14, 4'd10, 4'd11, 4'd13,  4'd0,  4'd9, 4'd11,  4'd9, 4'd10}, // 5
			{ 4'd9, 4'd14, 4'd11, 4'd13, 4'd14,  4'd9,  4'd0, 4'd12,  4'd9, 4'd12}, // 6
			{4'd12, 4'd10, 4'd12, 4'd14, 4'd14, 4'd11, 4'd12,  4'd0, 4'd13, 4'd10}, // 7
			{ 4'd8, 4'd14, 4'd13,  4'd8, 4'd14,  4'd9,  4'd9, 4'd13,  4'd0,  4'd9}, // 8
			{ 4'd9, 4'd14, 4'd12, 4'd12,  4'd8, 4'd10, 4'd12, 4'd10,  4'd8,  4'd0}};// 9   

   always_comb begin
      ideal = {10{32'h1}};

      for (j = 0; j < OUTPUT_SZ; j++) begin
	 if (j == label_reg) 
	   ideal[j] = 1 << 16;
	 else
	   ideal[j] = (1 << (20 - difference[label_reg][j]));
      end
      
      for (j = 0; j < OUTPUT_SZ; j++)
	delta_target[j] = ideal[j] - result[j];
   end
   

   genvar i;
   // Generate forward propagation neurons
   generate
      for (i = 0; i < NUM_NEURONS; i++) begin
         neuron layer0 (.clk(clk), .rst(rst), .clear(clear), .en (enable_0), .weight (weights0[i]), 
			.data (image_reg[lay0_idx]), .accum (acc_lay0[i]));
         sigmoid_approx_fn act_lay0(.clk(clk), .rst(rst), .enable(enable_0), .in (acc_lay0[i]), .out (hidden[i]));
      end
      for (i = 0; i < OUTPUT_SZ; i++) begin
         neuron layer1 (.clk(clk), .rst(rst), .clear(clear), .en (enable_1), .weight (weights1[i]),
			.data (hidden[lay1_idx]), .accum (acc_lay1[i]));
         sigmoid_approx_fn act_lay1(.clk(clk), .rst(rst), .enable(enable_1), .in (acc_lay1[i]), .out (result[i]));
      end
   endgenerate


   // Generate backwards propagation neurons / multipliers
   generate
      for (i = 0; i < NUM_NEURONS; i++) begin
	 sigmoid_approx_drv fnet(.clk, .rst, .en (1'b1), .in (acc_lay0[i]), .out (fprime_net[i]));
	 multiplier mult1(fprime_net[i], weight_matrix[i], delta_drv[i]);
	 multiplier_div8 mult2(delta_drv[i], image_reg[lay0_idx], wchange0[i]);
      end
      for (i = 0; i < OUTPUT_SZ; i++) begin
	 multiplier_div8 mult3(delta_target[i], hidden[lay1_idx], wchange1[i]);
	 multiplier mult4(weights1[i], delta_target[i], mult[i]);
      end
   endgenerate

   logic [31:0] sum;
   always_ff @(posedge clk, posedge rst) begin
      if (rst) weight_matrix <= '0;
      else if (clear) weight_matrix <= '0;
      else if (enable_delta) begin
	 sum = '0;
	 for (j = 0; j < OUTPUT_SZ; j++) sum += mult[j];
	 weight_matrix[lay1_idx] <= sum;
      end
   end

   integer z;
   always_comb begin
      done = 1'b0;
      clear = 1'b0;
      enable_0 = 1'b0;
      enable_1 = 1'b0;
      get_weights0 = 1'b0;
      get_weights1 = 1'b0;
      enable_delta = 1'b0;
      update0 = 1'b0;
      update1 = 1'b0;
      case (cs)
	S_IDLE: begin
	   clear = start_fp || start_bp;
	   ns = (start_fp || start_bp) ? S_FPROP_LAYER1 : S_IDLE;
	   get_weights0 = start_fp || start_bp;
	end

	S_FPROP_LAYER1: begin
	   ns = lay0_idx < IMG_SZ+2 ? S_FPROP_LAYER1 : S_FPROP_LAYER2;
	   get_weights1 = lay0_idx >= IMG_SZ+2;
	   enable_0 = 1;
	end

	S_FPROP_LAYER2: begin
	   enable_1 = 1;
	   ns = lay1_idx < NUM_NEURONS+2 ? S_FPROP_LAYER2 : (bp ? S_BPROP_LAYER2 : S_DONE);
	   update1 = bp && (lay1_idx >= NUM_NEURONS+2);
	end
	
	S_BPROP_LAYER2: begin
	   ns = lay1_idx < NUM_NEURONS-1 ? S_BPROP_LAYER2 : S_INTER1;
	end

	S_INTER1: begin
	   ns = S_BPROP_CALCDELTA;
	   get_weights1 = 1;
	end

	S_BPROP_CALCDELTA: begin
	   ns = lay1_idx < NUM_NEURONS-1 ? S_BPROP_CALCDELTA : S_INTER2;
	   enable_delta = 1;
	end
	
	S_INTER2: begin
	   ns = S_BPROP_LAYER1;
	   update0 = 1;
	   //if (clk == 1) for (z = 0; z < 128; z++) $display("v[%d] = %h", z, weight_matrix[z]);
	end
	
	S_BPROP_LAYER1: begin
	   ns = lay0_idx < IMG_SZ-1 ? S_BPROP_LAYER1 : S_DONE;
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
	 act_idx <= '0;
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
	      lay0_idx <= '0;
	      lay1_idx <= lay1_idx < NUM_NEURONS+2 ? lay1_idx + 1 : '0;
	   end

	   S_BPROP_LAYER2: begin
	      lay1_idx <= lay1_idx < NUM_NEURONS-1 ? lay1_idx + 1 : '0;
	   end

	   S_BPROP_CALCDELTA: begin
	      lay1_idx <= lay1_idx + 1;
	   end
	   
	   S_BPROP_LAYER1: begin
	      lay0_idx <= lay0_idx + 1;
	   end
	   
	   default: ; // Do nothing
	 endcase
      end
   end
   
endmodule: tile
