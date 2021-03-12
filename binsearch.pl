#!/usr/bin/env perl
use warnings;
use 5.028;
use Data::Dump qw/dd pp/;
use POSIX 'ceil';

die "Usage: $0 searchterm < data\n" unless @ARGV>0;
my $seek = shift;
chomp( my @data = <> ); # Input must be a sorted list of integers!
die "No data provided to search within\n" unless @data;

# https://en.wikipedia.org/wiki/Binary_search_algorithm#Alternative_procedure
my $l = 0;
my $r = $#data;
while ( $l != $r ) {
	my $m = ceil( ($l+$r)/2 );
	print "Searching $l to $r, middle is $m\n";
	if ( $data[$m] > $seek ) { $r = $m - 1 }
	else { $l = $m }
}
if ( $data[$l] == $seek ) { print "Found $seek at $l\n" }
else { print STDERR "Not found\n"; exit 1 }
