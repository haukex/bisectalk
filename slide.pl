#!/usr/bin/env perl
use warnings;
use 5.028;
use open qw/:std :utf8/;
use Term::Cap;
use Term::ReadKey;
use POSIX ();
use Term::ANSIColor qw/colored/;
use IO::Interactive 'is_interactive';
use Term::Size;
use FindBin;
use File::Spec::Functions qw/catfile tmpdir/;
use Data::Dump qw/dd pp/;
$|++;

# ##### Yet Another Terminal Slide Renderer #####

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

my ($COLS, $ROWS) = Term::Size::chars;
$COLS--; $ROWS-=2; # a bit of buffer
my $XMARGIN = 2;

my %SLIDE_KEYS = map {$_=>1} qw/ title render /;
my %RENDER_KEYS = map {$_=>1} qw/ x y color text pause /;

sub draw_slide {
	my ($slidenr,$slide,$bullet) = @_;
	$SLIDE_KEYS{$_} or die "Unknown slide key ".pp($_) for keys %$slide;
	die "Bad slide nr. ".pp($slidenr) unless $slidenr=~/\A\d+\z/ && $slidenr>0;
	
	print $terminal->Tputs('cl'); # clear_screen
	
	print # corners
		$terminal->Tgoto('cm', 0,     0    ), "\N{U+231C}",
		$terminal->Tgoto('cm', $COLS, 0    ), "\N{U+231D}",
		$terminal->Tgoto('cm', 0,     $ROWS), "\N{U+231E}",
		$terminal->Tgoto('cm', $COLS, $ROWS), "\N{U+231F}";
	# title & slide nr
	print $terminal->Tgoto('cm', $COLS/2 - length($slide->{title})/2, 0),
		colored( $slide->{title}, 'bold bright_white underline' );
	print $terminal->Tgoto('cm', $COLS - length($slidenr) - $XMARGIN, $ROWS),
		$slidenr;
	
	my ($x,$y) = ($XMARGIN,1);
	for my $i ( 0 .. $slide->{render}->$#* ) {
		my $r = $slide->{render}[$i];
		$RENDER_KEYS{$_} or die "Unknown render key ".pp($_) for keys %$r;
		if ( length $r->{pause} ) {
			die "Too many keys ".pp($r) if keys(%$r)>1;
			next unless is_interactive;
			print $terminal->Tgoto('cm', $COLS-$XMARGIN, $ROWS), ".";
			if ( $r->{pause} =~ /\A\d+\z/ ) { sleep $r->{pause} }
			elsif ( $r->{pause} eq 'key' ) { ReadKey }
			else { die "Unknown pause ".pp($r->{pause}) }
			print $terminal->Tgoto('cm', $COLS-$XMARGIN, $ROWS), " ";
			next;
		}
		my $len = length($r->{text}) or die "Text missing";
		if ( length $r->{y} ) {
			if ( $r->{y} =~ /\A\+(\d+)\z/ ) { $y += $1 }
			elsif ( $r->{y} =~ /\A\d+\z/ ) { $y = $r->{y} }
			else { die "Unknown y ".pp($r->{y}) }
		} else { $y++ }
		die "y too big: ".pp($y) if $y>$ROWS;
		if ( length $r->{x} ) {
			if ( $r->{x} eq 'c' ) { $x = $COLS/2 - $len/2 }
			elsif ( $r->{x} eq 'r' ) { $x = $COLS-$len-$XMARGIN }
			elsif ( $r->{x} eq 'l' ) { $x = $XMARGIN }
			elsif ( $r->{x} =~ /\A\+(\d+)\z/ ) { $x += $1; }
			elsif ( $r->{x} =~ /\A\d+\z/ ) { $x = $r->{x} }
			else { die "Unknown x ".pp($r->{x}) }
		} else { $x = $XMARGIN unless $r->{y} && $r->{y} eq '+0' }
		die "x too big: ".pp($x) if $x>$COLS;
		# the following isn't strictly needed, text will just wrap and be ugly
		#die "x+len too big: ".pp($x,$len) if $x+$len>$COLS;
		my $color = $r->{color} || 'bright_white';
		if ( $i==$bullet-1 ) {
			$color .= ' bold' unless $color=~/\bbold\b/i;
			print $terminal->Tgoto('cm', 0, $y), colored( "\N{U+2192}", $color );
		}
		print $terminal->Tgoto('cm', $x, $y), colored( $r->{text}, $color );
		$x += $len;
	}
	
	print $terminal->Tgoto('cm', $COLS, $ROWS), "\n";
}

die "Usage: $0 [SLIDEFILE] [SLIDENUM]\n" if @ARGV>2;
my $incfile = @ARGV>1 ? shift(@ARGV)
	: catfile($FindBin::Bin, 'slides.inc.pl');
our @SLIDES;
my $loadslides = sub {
	@SLIDES = ();
	unless ( my $return = do $incfile ) {
		die "couldn't parse $incfile: $@" if $@;
		die "couldn't do $incfile: $!" unless defined $return;
		die "couldn't run $incfile";
	}
	die "No slides in file $incfile" unless @SLIDES;
};
$loadslides->();

my $slidecache = catfile( tmpdir, '.lastslide' );
my $slide;
if ( @ARGV ) { $slide = shift(@ARGV) }
elsif ( open(my $fh, '<', $slidecache) ) {
	$slide = $1 if do { local $/; <$fh> } =~ /^(\d+)$/;
	$slide = 1 if $slide<1 || $slide>@SLIDES;
}
else { $slide = 1 }
END {
	if ( defined $slide && open(my $fh, '>', $slidecache) )
		{ print {$fh} $slide }
}
die "Bad slide number ".pp($slide) unless $slide=~/\A\d+\z/
	&& $slide>0 && $slide<=@SLIDES;

my $bullet=0;
my $input;
while (1) {
	draw_slide($slide, $SLIDES[$slide-1], $bullet);
	local $SIG{WINCH} = sub {
		# note this means size change will restart the slide's pauses too
		($COLS, $ROWS) = Term::Size::chars;
		$COLS--; $ROWS-=2;
		draw_slide($slide, $SLIDES[$slide-1], $bullet);
	};
	is_interactive or last;
	my $k = ReadKey;
	if ( lc $k eq 'q' || lc $k eq 'x' ) { last }
	elsif ( lc $k eq 'b' || lc $k eq 'p' ) { $bullet=0; --$slide>0 or $slide=1 }
	elsif ( $k eq ' ' || $k eq "\n" || lc $k eq 'n' ) { $bullet=0; ++$slide<=@SLIDES or last }
	elsif ( $k eq 's' ) { $bullet++ } # note: not compatible with pauses
	elsif ( $k eq 'a' ) { $bullet-- }
	elsif ( $k=~/\A[0-9]\z/ ) {
		$input .= $k;
		if ( length $input >= length(0+@SLIDES) ) {
			if ( $input>0 && $input<=@SLIDES )
				{ $bullet=0; $slide=0+$input }
			$input = '';
		}
	}
}
