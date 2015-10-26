#!/usr/bin/perl
if (!$::Driver) { use FindBin; exec("$FindBin::Bin/bootstrap.pl", @ARGV, $0); die; }
# DESCRIPTION: Verilator: Verilog Test driver/expect definition
#
# Copyright 2008 by Wilson Snyder. This program is free software; you can
# redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.

$Self->skip("Verilator only test") if !$Self->{vlt};

compile (
	 make_top_shell => 0,
	 make_main => 0,
	 verilator_make_gcc => 0,
	 v_flags2 => ["--lint-only t/t_vlt_warn.vlt"],
	 );

ok(1);
1;
