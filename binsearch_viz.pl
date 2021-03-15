#!/usr/bin/env perl
use warnings;
use 5.028;
use open qw/:std :utf8/;
use POSIX 'ceil';
use Term::Cap;
use Term::ReadKey;
use POSIX ();
use Term::ANSIColor qw/colored/;
use List::Util qw/max/;
use IO::Interactive 'is_interactive';

# use the example at the top of getlist.pl to generate list.txt
# ./binsearch_viz.pl 19941017 list.txt

die "Usage: $0 searchterm < data\n" unless @ARGV>0;
my $seek = shift;
chomp( my @data = <> ); # Input must be a sorted list of integers!
die "No data provided to search within\n" unless @data;

my $terminal = do {
	my $termios = POSIX::Termios->new();
	$termios->getattr;
	Term::Cap->Tgetent({TERM=>undef, OSPEED=>$termios->getospeed }) };

my $maxlen = max map {length} @data;

my $RARR = colored(" \N{U+21D2}  ",'bold bright_white');
my $CSEEK = colored($seek,'bold bright_magenta');
my $GT = colored(">",'bold bright_white');
my $LE = colored("\N{U+2264}",'bold bright_white');

$SIG{INT} = $SIG{TERM} = sub { exit };
END {
	ReadMode 'restore';
	print $terminal->Tputs('ve') if $terminal; # cursor_normal
}
ReadMode 'cbreak';
print $terminal->Tputs('vi'); # cursor_invisible

print colored("Seeking",'bold bright_white'), " $CSEEK\n";
my $l = 0;
my $r = $#data;
my $redraw = sub {
	my %opts = @_;
	for my $i (0..$#data) {
		print colored(sprintf(' %*d', length $#data, $i), 'bold bright_white' );
		print colored(sprintf('  %-*s ', $maxlen, $data[$i]),
			$i>=$l && $i<=$r ? $opts{c}//'bright_yellow' : 'white' );
		if ( $i==$l ) {
			print colored(" \N{U+2190}  L",'bold bright_blue') if !defined $opts{last};
			print " ",$opts{ltxt} if defined $opts{ltxt};
		}
		if ( $i==$r ) {
			print colored(" \N{U+2190}  R",'bold bright_blue') if !defined $opts{last};
			print " ",$opts{rtxt} if defined $opts{rtxt};
		}
		if ( defined $opts{m} && $i==$opts{m} ) {
			print colored(" \N{U+2190}  M",'bold bright_cyan');
			print " ",$opts{mtxt} if defined $opts{mtxt};
		}
		print $terminal->Tputs('ce'), "\n"; # clr_eol
	}
	unless ( $opts{last} ) {
		print $terminal->Tgoto('UP',0,0+@data);
		is_interactive ? ReadKey : sleep 1;
	}
};
while (1) {
	$redraw->(ltxt=>colored("= $l",'bright_blue'), rtxt=>colored("= $r",'bright_blue'));
	last if $l==$r;
	my $m = ceil( ($l+$r)/2 );
	$redraw->(ltxt=>colored("= $l",'bright_blue'), rtxt=>colored("= $r",'bright_blue')
		.$RARR.colored("M = \N{U+2308}(",'bright_cyan').colored("L+R",'bright_blue')
			.colored(")/2\N{U+2309} = $m",'bright_cyan') );
	$redraw->(m=>$m);
	if ( $data[$m] > $seek ) {
		$redraw->(m=>$m, mtxt=>"$GT $CSEEK" );
		$redraw->(m=>$m, mtxt=>"$GT $CSEEK$RARR"
			.colored("R = ",'bright_blue').colored("M - 1",'bright_cyan') );
		$r = $m - 1;
	}
	else {
		$redraw->(m=>$m, mtxt=>"$LE $CSEEK" );
		$redraw->(m=>$m, mtxt=>"$LE $CSEEK$RARR"
			.colored("L = ",'bright_blue').colored("M",'bright_cyan') );
		$l = $m;
	}
}

if ( $data[$l] == $seek ) {
	$redraw->(last=>1, c=>'bold bright_green', rtxt=>colored('<-- Found!','bright_green'));
}
else {
	$redraw->(last=>1, c=>'bright_red', rtxt=>colored('--- Not found!','bright_red'));
}
