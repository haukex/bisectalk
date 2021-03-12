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
}

my $grammar = do { use Regexp::Grammars; qr{
	<nocontext:>
	\A <result=expr> \z
	<rule: expr>
		<MATCH=add> <.ws>
	<rule: add>
		<[term=mult]>+ % <[op=(\+|\-)]>
	<rule: mult>
		<[term=number]>+ % <[op=(\*|\/)]>
	<token: number>
		-? (?: \d+ (?: \.\d+ )? | \. \d+ )
}xms }->with_actions(Actions->new);

$input =~ $grammar or die "Failed to parse input.\n";
print $/{result};
print "\n" if is_interactive;
