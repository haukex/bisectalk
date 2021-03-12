#!/usr/bin/env perl
use warnings;
use 5.028;
use IO::Interactive 'is_interactive';

my $input = join ' ', @ARGV;

my $grammar = do { use Regexp::Grammars; qr{
	<nocontext:>
	\A <result=expr> \z
	<rule: expr>
		(?: <MATCH=number> | <MATCH=add> ) <.ws>
	<rule: add>
		<[number]>+ % <[op=(\+)]>
		(?{ $MATCH=0; $MATCH+=$_ for $MATCH{number}->@* })
	<token: number>
		[-+]?\d+
}xms };

$input =~ $grammar or die "Failed to parse input.\n";
print $/{result};
print "\n" if is_interactive;
