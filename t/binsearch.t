#!/usr/bin/env perl
use warnings;
use 5.028;
use Test::More tests=>2;
use FindBin;
use File::Spec::Functions qw/catfile updir/;
use IPC::Run3::Shell
	[ binsearch => { fail_on_stderr=>1, show_cmd=>Test::More->builder->output },
		$^X, catfile($FindBin::Bin, updir, 'binsearch.pl') ];

# idx   0   1   2   3   4   5   6   7   8   9
# data  1   2   3   4   5   6   7   8   9   10   seek 8
#       L=0                 M=5             R=9  => data[5]>seek => 6>8 no  => L=M
#                           L=5     M=7     R=9  => data[7]>seek => 8>8 no  => L=M
#                                   L=7 M=8 R=9  => data[8]>seek => 9>8 yes => R=M-1
#                                   L=R=7        => done
is binsearch('8', {stdin=>\join("", map {"$_\n"} 1..10)} ), <<'END';
Searching 0 to 9, middle is 5
Searching 5 to 9, middle is 7
Searching 7 to 9, middle is 8
Found 8 at 7
END

# idx   0   1   2   3   4   5   6   7   8
# data  1   2   3   4   5   6   7   8   9    seek 3
#       L=0             M=4             R=8  => data[4]>seek => 5>3 yes => R=M-1
#       L=0     M=2 R=3                      => data[2]>seek => 3>3 no  => L=M
#               L=2 R=M=3                    => data[3]>seek => 4>3 yes => R=M-1
#               L=R=2                        => done
is binsearch('3', {stdin=>\join("", map {"$_\n"} 1..9)} ), <<'END';
Searching 0 to 8, middle is 4
Searching 0 to 3, middle is 2
Searching 2 to 3, middle is 3
Found 3 at 2
END
