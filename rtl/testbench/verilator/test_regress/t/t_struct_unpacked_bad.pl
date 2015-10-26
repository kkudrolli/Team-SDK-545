#!/usr/bin/perl
if (!$::Driver) { use FindBin; exec("$FindBin::Bin/bootstrap.pl", @ARGV, $0); die; }
# DESCRIPTION: Verilator: Verilog Test driver/expect definition
#
# Copyright 2003 by Wilson Snyder. This program is free software; you can
# redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.

compile (
	 fails=>$Self->{v3},
	 expect=>
q{%Warning-UNPACKED: t/t_struct_unpacked_bad.v:\d+: Unsupported: Unpacked struct/union
%Warning-UNPACKED: Use .*
.*%Error: Exiting due to.*},
	 );

ok(1);
1;
