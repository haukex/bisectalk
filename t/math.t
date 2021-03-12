#!/usr/bin/env perl
use warnings;
use 5.028;
use Test::More tests=>1;
use FindBin;
use File::Spec::Functions qw/catfile updir/;
use IPC::Run3::Shell
	[ math => { fail_on_stderr=>1, show_cmd=>Test::More->builder->output },
		$^X, catfile($FindBin::Bin, updir, 'math.pl') ];
sub exception (&) { eval { shift->(); 1 } ? undef : ($@ || die) }

like exception { math('1+1') }, qr/\bunimplemented\b/i;
