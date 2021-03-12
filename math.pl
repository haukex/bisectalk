#!/usr/bin/env perl
use warnings;
use 5.028;
use IO::Interactive 'is_interactive';

my $input = join ' ', @ARGV;

package Actions {
	use Math::BigFloat;
	sub new { bless {}, shift }
	sub add {
		my ($self, $match) = @_;
		my ($term, $op) = @$match{qw/term op/};
		my $out = Math::BigFloat->new( shift $term->@* );
		return $out if !$term->@* && !ref $op;
		die unless $term->@* == $op->@*;
		for my $i ( 0 .. $term->$#* ) {
			if ( $$op[$i] eq '+' ) { $out += $$term[$i] }
			elsif ( $$op[$i] eq '-' ) { $out -= $$term[$i] }
			elsif ( $$op[$i] eq '*' ) { $out *= $$term[$i] }
			elsif ( $$op[$i] eq '/' ) { $out /= $$term[$i] }
			else { die }
		}
		return $out;
	}
	*mult = *mult = \&add;
	sub pow {
		my ($self, $match) = @_;
		my $term = $$match{term};
		return $$term[0] if @$term==1 && !exists $$match{op};
		die unless $term->@* > 1 && $term->@* == $$match{op}->@*+1
			&& !grep {$_ ne '^'} $$match{op}->@*;
		$$term[-2] = Math::BigFloat->new( $$term[-2] );
		splice @$term, -2, 2, $$term[-2]**$$term[-1]
			while $term->@* > 1;
		return $$term[0];
	}
}

my $grammar = do { use Regexp::Grammars; qr{
	<nocontext:>
	\A <result=expr> \z
	<rule: expr>
		<MATCH=add> <.ws>
	<rule: add>
		<[term=mult]>+ % <[op=(\+|\-)]>
	<rule: mult>
		<[term=pow]>+ % <[op=(\*|\/)]>
	<rule: pow>
		<[term=paren]>+ % <[op=(\^)]>
	<rule: paren>
		<MATCH=number> | \( <MATCH=add> \)
	<token: number>
		-? (?: \d+ (?: \.\d+ )? | \. \d+ )
}xms }->with_actions(Actions->new);

$input =~ $grammar or die "Failed to parse input.\n";
print $/{result};
print "\n" if is_interactive;
