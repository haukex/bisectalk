#!/usr/bin/env perl
use warnings;
use strict;
use Data::Dumper;
$Data::Dumper::Useqq=1;

open my $ofh, '>', '/tmp/testdb.pl' or die $!;
print $ofh <<'END_SCRIPT';
#!/bin/perl -w
use strict;
$_ = shift // '';  # line 3
s{a([bc])}         # 4
 {d$1}g;           # 5
print;             # 6
END_SCRIPT
close $ofh;

my $listing = "/tmp/test-".time.".listing";
unlink($listing);
local $ENV{PERLDB_OPTS} = "NonStop AutoTrace LineInfo=$listing";
system($^X,'-Ilib','-d','/tmp/testdb.pl')==0 or die "\$?=$?";
my $o = do { open my $fh, '<', $listing or die $!; local $/; <$fh> };
my $x = $o =~ /^main::\([^)]+\.pl:5\):\s+{d\$1}g;\s+#\s+5\s*$/m; # good
my $y = $o =~ /^main::\([^)]+\.pl:6\):\s+print;\s+#\s+6\s*$/m;   # good
my $z = $o =~ /^main::\([^)]+\.pl:5\):\s+print;\s+#\s+6\s*$/m;   # bad
if ( $x && $y && !$z ) {
	print "$] GOOD\n";
	exit 0;
}
elsif ( !$x && !$y && $z ) {
	print "$] BAD\n";
	exit 1;
}
else {
	print STDERR Dumper($],$o,$x,$y,$z);
	die "What?";
}

__END__

Run from the perl5 source tree:

$ ./Porting/bisect.pl --start=v5.24.0 --end=v5.26.3               -- ./perl -Ilib /path/to/this.pl
# or, due to a bug in git 2.30 and 2.31 (https://public-inbox.org/git/YFDGX4EsrvHqZgPF@coredump.intra.peff.net/T/):
$ ./Porting/bisect.pl --start=be2c0c6 --end=92583df               -- ./perl -Ilib /path/to/this.pl

=> 6432a58ad9a504c2dc834eb0d131a10b4b6c886b
=> v5.25.7

$ ./Porting/bisect.pl --start=v5.26.0 --end=v5.28.3 --expect-fail -- ./perl -Ilib /path/to/this.pl
$ ./Porting/bisect.pl --start=95388f2 --end=ae49126 --expect-fail -- ./perl -Ilib /path/to/this.pl

=> 823ba440369100de3f2693420a3887a645a57d28
=> v5.27.10

