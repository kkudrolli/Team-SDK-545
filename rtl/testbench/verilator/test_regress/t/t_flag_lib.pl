#!/usr/bin/perl
if (!$::Driver) { use FindBin; exec("$FindBin::Bin/bootstrap.pl", @ARGV, $0); die; }

compile (
	 v_flags2 => ['-v', 't/t_flag_libinc.v'],
	 );

execute (
	 check_finished=>1,
     );

ok(1);
1;
