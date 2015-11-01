module ones_comp_add(
    input  logic [7:0] A, B,
    output logic [7:0] C);

    logic [8:0] A_int, B_int, C_int;

    assign A_int = {1'b0, A};
    assign B_int = {1'b0, B};
    assign C_int = A_int + B_int;
    assign C = {7'h0, C_int[8]} + C_int[7:0];

endmodule: ones_comp_add
