module top;

    logic [7:0] A, B, C;

    ones_comp_add add (.*);

    initial begin
        $monitor($stime,, "\n \
        Inputs:\n \
        A: %h B: %h\n \
        Outputs: \n \
        C: %h\n",
        A, B, C);
        
        A = 8'h00; B = 8'h00;
        #10 A = 8'h00; B = 8'h00;
        #10 assert(C == 8'h00);
        #10 A = 8'hff; B = 8'hff;
        #10 assert(C == 8'hff);
        #10 A = 8'h01; B = 8'h10;
        #10 assert(C == 8'h11);
        #10 A = 8'h1f; B = 8'hf0;
        #10 assert(C == 8'h10);
        #10 A = 8'hab; B = 8'hcd;
        #10 assert(C == 8'h79);
        #10 $display("Tests Passed!\n");
        #10 $finish;
    end

endmodule: top
