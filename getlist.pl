#!/usr/bin/env perl
use warnings;
use 5.028;
use Data::Dump qw/dd pp/;
use HTTP::Tiny;
use Time::Piece;
use JSON::PP;
use URI;

# ./getlist.pl `perldoc -l perlhist` | jq -r '.[].date' | tr -d '\-' | sort
# or: ./getlist.pl https://github.com/Perl/perl5/raw/blead/pod/perlhist.pod

die "Usage: $0 [FILE | URL]\n" unless @ARGV==1;
my $source = URI->new(shift);
my $pod;
if ( defined($source->scheme) && $source->scheme=~/^http/i ) {
	my $resp = HTTP::Tiny->new->get($source);
	die "$source: $resp->{status} $resp->{reason}" unless $resp->{success};
	$pod = $resp->{content};
}
else { # assume file
	open my $fh, '<', $source or die "$source: $!";
	$pod = do { local $/; <$fh> };
	close $fh;
}

my $verb = getverbatim($pod, qr/\b(?:the\s+records)\b/i);
my $rels = $$verb[0];
$rels =~ /\A\s*Pump-[^=]+\bkin(?:g|\b[^=]+\bHolder)\b/i or die pp($rels);

# https://www.perlmonks.org/?node_id=1179840
my ($date_re) = map {qr/\b\d{4}-(?i:$_)-\d\d\b/} join '|', map {quotemeta}
	sort { length $b <=> length $a or $a cmp $b } Time::Piece::mon_list();

my $REGEX = qr{
		^ \h+
		(?: (?<pumpking> \w[\w\h]*\w ) \h+ )?
		(?<version>
			  [1234]\.000
			| 5\.\d*[02468]\.0
			# Fiddle with the versions a bit to get one release per year.
			| 3\.041 | 4\.03[56]
			| 5\.00[01245] | 5\.004_05
			| 5\.6\.1 | 5\.8\.[16789] | 5\.10\.1
		)
		\h+ (?<date> $date_re )
		(?: \h+ (?<comment> \N+ ) )?
		\h* \n
	}msx;

my @rels;
while ( $rels=~/$REGEX/g ) {
	my %rel = %+;
	$rel{date} = Time::Piece->strptime($rel{date}, '%Y-%b-%d')->strftime('%Y-%m-%d');
	push @rels, \%rel;
}
my $json = JSON::PP->new->ascii->canonical->pretty;
print $json->encode(\@rels);

# https://github.com/haukex/Util-H2O/blob/6db2a1d4/xt/author.t#L101
use Pod::Simple::SimpleTree;
sub getverbatim {
	my ($data,$regex) = @_;
	my $tree = Pod::Simple::SimpleTree->new->parse_string_document($data)->root;
	my ($curhead,@v);
	for my $e (@$tree) {
		next unless ref $e eq 'ARRAY';
		if (defined $curhead) {
			if ($e->[0]=~/^\Q$curhead\E/) { $curhead = undef }
			elsif ($e->[0] eq 'Verbatim') { push @v, $e->[2] }
		}
		elsif ($e->[0]=~/^head\d\b/ && $e->[2]=~$regex)
			{ $curhead = $e->[0] }
	}
	return \@v;
}
