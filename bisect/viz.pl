#!/usr/bin/env perl
use warnings;
use 5.028;
use open qw/:std :utf8/;
use Term::Cap;
use Term::ReadKey;
use POSIX ();
use Cwd 'abs_path';
use Term::ANSIColor qw/colored/;
use IO::Interactive 'is_interactive';
use IPC::Run3::Shell::CLIWrapper;
use File::Temp qw/tempfile/;
use Data::Dump qw/dd pp/;

die "Usage: $0 BISECT_SCRIPT\n" unless @ARGV==1;
my $SCRIPT = abs_path(shift);
die "Bad bisect script '$SCRIPT'" unless -f -x $SCRIPT;

# Make a copy of the bisect script - see runner.sh for why
my ($tfh,$tfn) = tempfile(UNLINK=>1);
print $tfh do { open my $fh, '<', $SCRIPT or die "$SCRIPT: $!"; local $/; <$fh> };
close $tfh;
chmod( (0755 & ~umask), $tfn ) or die "chmod $tfn: $!";
$SCRIPT = abs_path($tfn);
die "Copy of bisect script to '$SCRIPT' failed" unless -f -x $SCRIPT;

my $git = IPC::Run3::Shell::CLIWrapper->new( { fail_on_stderr=>1,
	show_cmd=>1, val_sep=>'=', chomp=>1 }, 'git');

my @log = map { /^([a-fA-F0-9]{4,40})\t(.+)$/ or die pp($_); [lc $1, $2] }
	$git->log( [ pretty=>"%h\t%s" ], '-z', {irs=>"\0"} )
		or die "failed to get / parse log";

my $gitdir = $git->rev_parse('--show-toplevel');
chdir $gitdir or die "chdir $gitdir: $!";
$git->bisect('start');
$git->bisect('old', $git->rev_list( [max_parents=>0], 'HEAD' ) );
$git->bisect('new', 'HEAD');
$git->bisect('run', $SCRIPT, {fail_on_stderr=>0});
my @bisect = $git->bisect('log');
$git->bisect('reset', {fail_on_stderr=>0});

@bisect = grep { !/^#/ } @bisect;
shift @bisect eq 'git bisect start' or die "unexpected log output";
@bisect = map { /^git bisect (old|new) ([a-fA-F0-9]{4,40})$/ or die pp($_);
		[$1, $git->rev_parse('--short',$2, {show_cmd=>0})||die pp($2)] } @bisect;

my $terminal = do {
	my $termios = POSIX::Termios->new();
	$termios->getattr;
	Term::Cap->Tgetent({TERM=>undef, OSPEED=>$termios->getospeed }) };

$SIG{INT} = $SIG{TERM} = sub { exit };
END {
	ReadMode 'restore';
	print $terminal->Tputs('ve') if $terminal; # cursor_normal
}
ReadMode 'cbreak';
print $terminal->Tputs('vi'); # cursor_invisible

print "\n", colored("##### Visualization #####", 'bold bright_white'), "\n";

my %logmap = map { $log[$_][0] => $_ } 0..$#log;

my (%terms,%rterms);
my $shiftbi = sub {
	my $assign = shift;
	my $x = shift @bisect;
	die "not found in log: ".pp($$x[1])
		unless exists $logmap{$$x[1]};
	$terms{$$x[0]} = $$x[1] if $assign;
	$rterms{$$x[1]} = $$x[0];
	return $x->@*;
};
die "not enough bisect output ".pp(\@bisect) unless @bisect>2;
$shiftbi->(1);
$shiftbi->(1);

my $redraw = sub {
	my %opts = @_;
	die "Unexpected keys ".pp(\%terms) unless keys(%terms)==2;
	my ($lo,$hi) = $opts{last} ? ($logmap{$terms{new}}) x 2
		: sort {$a<=>$b} map { $logmap{$_} } values %terms;
	for my $i (0..$#log) {
		if ( $i>=$lo && $i<=$hi || $opts{arr} && $opts{arr} eq $log[$i][0] ) {
			print $opts{arr} && $opts{arr} eq $log[$i][0] ?
				colored( sprintf("%4s", '-->' ), 'bold bright_cyan') :
				colored( sprintf("%4s", $rterms{$log[$i][0]}//'' ), 'bold bright_blue'),
				" ", colored( $log[$i][0], ($opts{last}?'bold ':'').'bright_yellow' ),
				" ", colored( $log[$i][1], $opts{last} ? 'bright_green bold' : 'bright_white' );
		}
		else {
			print colored( sprintf("%4s", $rterms{$log[$i][0]}//'' ), 'white'),
				" ", colored( $log[$i][0], 'white' ),
				" ", colored( $log[$i][1], 'white' );
		}
		print $terminal->Tputs('ce'), "\n"; # clr_eol
	}
	if ( !$opts{last} ) {
		print $terminal->Tgoto('UP',0,0+@log);
		is_interactive ? ReadKey : sleep 1;
	}
};
$redraw->();
while (@bisect) {
	my ($t,$c) = $shiftbi->();
	$redraw->( arr => $c );
	$terms{$t} = $c;
	$redraw->();
}
$redraw->( last => 1 );
