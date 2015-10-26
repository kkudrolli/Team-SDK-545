#!/usr/bin/perl
if (!$::Driver) { use FindBin; exec("$FindBin::Bin/bootstrap.pl", @ARGV, $0); die; }
# DESCRIPTION: Verilator: Verilog Test driver/expect definition
#
# Copyright 2003 by Wilson Snyder. This program is free software; you can
# redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.

top_filename("t/t_inst_tree.v");

compile (
	 verilator_flags2 => ['+define+NOUSE_INLINE', '+define+USE_PUBLIC', '--stats'],
	 );

if ($Self->{vlt}) {
    file_grep ($Self->{stats}, qr/Optimizations, Combined CFuncs\s+(\d+)/i, 16);
}

execute (
	 check_finished=>1,
	 expect=>
'\] (%m|.*v\.ps): Clocked
',
     );

ok(1);
1;
