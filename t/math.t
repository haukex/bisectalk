#!/usr/bin/env perl
use warnings;
use 5.028;
use Test::More tests=>49;
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
is math('1+1+1'), '3';
is math('9+8+7+6+5+4+3+2+1'), '45';
is math(' 32 + 9 + -5 + 89 + -44 + 73541 + -10000 '), '63622';
badmath('+');
badmath('1+++3');

is math('2-1'), '1';
is math('10-3'), '7';
is math('4-20'), '-16';
is math(' -2 - 5 '), '-7';
is math(' -6- -20 '), '14';
is math('10-7-3-1'), '-1';
is math(' 352 - 64 + 45 - 341 - -20 + 60 + -40 '), '32';
badmath('1-- 3');
badmath('1---3');

is math('2*3'), '6';
is math('5*-7'), '-35';
is math(' 20 * 9 * 4 '), '720';
is math(' 3 * 4 + 5 '), '17';
is math(' 3 + 4 * 5 '), '23';
is math(' 3 + 4 * 5 + 6 '), '29';
is math(' 3 * 4 + 5 * 6 '), '42';

badmath('4/5');

is math('6^7'), '279936';
is math(' 2 ^ 10 '), '1024';
is math(' 2 ^ 3 ^ 2 '), '512';
is math('1^2^3^4'), '1';
is math(' 2 * 3 ^ 4 '), '162';
badmath('2^');
badmath('^5');
badmath('2^*4');

badmath('0.1');
badmath('(3)');
