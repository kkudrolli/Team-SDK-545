// DESCRIPTION: Verilator: Connecting an interface array slice to a module's portmap
//
// This file ONLY is placed into the Public Domain, for any use,
// without warranty, 2015 by Todd Strader.

interface foo_intf;
   logic a;
endinterface

module foo_mod
  (
   foo_intf foo
   );
endmodule

module t (/*AUTOARG*/);

   localparam N = 4;

   foo_intf foos [N-1:0] ();
   //foo_intf foos ();

   foo_mod
     foo_mod
       (
	.foo (foos[2])
	//.foo (foos)
	);

   initial begin
      $write("*-* All Finished *-*\n");
      $finish;
   end

endmodule
