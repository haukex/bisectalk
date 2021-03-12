#!/usr/bin/env perl
use warnings;
use 5.028;
use Test::More tests=>24;
use FindBin;
use File::Spec::Functions qw/catfile updir/;
use IPC::Run3::Shell
	[ math => { fail_on_stderr=>1, show_cmd=>Test::More->builder->output },
		$^X, catfile($FindBin::Bin, updir, 'math.pl') ];
sub exception (&) { eval { shift->(); 1 } ? undef : ($@ || die) }

sub badmath { my $m = shift; like exception { math($m) }, qr/\bfailed to parse\b/i }

is math('1'), '1';
is math('1234567'), '1234567';
is math('0'), '0';
is math('-1'), '-1';
is math('-987654'), '-987654';
is math(' 111 '), '111';
badmath('');
badmath('abc');
badmath('1+');
badmath('-');
badmath('- 1');

is math('1+1'), '2';
is math('123+456'), '579';
is math(' 9 + 777 '), '786';
is math(' -5 + 3 '), '-2';
is math(' 50 + -8 '), '42';
is math(' -33 + -44 '), '-77';
badmath('+');

badmath('2-1');
badmath('2*3');
badmath('4/5');
badmath('6^7');
badmath('0.1');
badmath('(3)');
