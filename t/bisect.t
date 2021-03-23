#!/usr/bin/env perl
use warnings;
use 5.028;
use FindBin;
use File::Spec::Functions qw/catfile/;
use File::Temp qw/tempfile/;

use IPC::Run3::Shell::CLIWrapper;
my $git = IPC::Run3::Shell::CLIWrapper->new( { fail_on_stderr=>1,
	show_cmd=>Test::More->builder->output, val_sep=>'=', chomp=>1 },
	'git');

use Test::More tests=>8;
my @tests = (
	[ 'adds.sh',      'fe1a1dec8251c16f2d650d9d87bb987edc5652f9' ],
	[ 'div.sh',       '8e17f4cc844dcedec5e547caa17066452f8330f1' ],
	[ 'float.sh',     '7d3e4c43d85f9ca35a0dc74a557838dc2612ec6b' ],
	[ 'paren.sh',     '1f38dbc4b990e2d5f28082fcb97a6a50c09b1773' ],
	[ 'posnum.sh',    '7d3e4c43d85f9ca35a0dc74a557838dc2612ec6b' ],
	[ 'pow_float.sh', 'e46d2ff96a3a89763351afbda4c1f43b73de5d4c' ],
	[ 'pow.sh',       '3fb0037d635031001f824b6f4540794dc1ba09b8' ],
	[ 'subtract.sh',  '65db5dac0f70dfc066f55a8d0eeaf13b084f76ef' ],
);

my $gitdir = $git->rev_parse('--show-toplevel');
chdir $gitdir or die "chdir $gitdir: $!";
note "chdir $gitdir";

my $oldest = $git->rev_list( [max_parents=>0], 'HEAD' );
note "oldest $oldest";

for my $test ( @tests ) {
	my $script = catfile('bisect', $test->[0]);
	my $expect = $test->[1];
	note explain "running $script expecting $expect";
	
	my ($tfh,$tfn) = tempfile(UNLINK=>1);
	print $tfh do { open my $fh, '<', $script or die "$script: $!"; local $/; <$fh> };
	close $tfh;
	chmod( (0755 & ~umask), $tfn ) or die "chmod $tfn: $!";
	$script = $tfn;
	die "Copy of bisect script to '$script' failed" unless -f -x $script;
	
	$git->bisect('start');
	$git->bisect('old', $oldest);
	$git->bisect('new', 'HEAD');
	$git->bisect('run', $script, {fail_on_stderr=>0, stderr=>Test::More->builder->output, stdout=>Test::More->builder->output});
	my @bisect = $git->bisect('log');
	$git->bisect('reset', {fail_on_stderr=>0, stderr=>Test::More->builder->output});
	
	like $bisect[-1], qr/^# first new commit: \Q[$expect]\E/
		or diag explain \@bisect;
}
