#!perl
use warnings;
use strict;
use utf8; # Euro: €

our @SLIDES;

=head1 Preparation

Terminal size 120x37

 ./getlist.pl https://github.com/Perl/perl5/raw/blead/pod/perlhist.pod | jq -r '.[].date' | tr -d '\-' | sort > /tmp/list.txt
 screen
 # Set up screens: 1 pres, 2 perl5 (set title with Ctrl-A Shift-A)
 # On the perl5 screen, prep the command from the "Bisecting perl" demo
 # On the presentation screen:
 ./slide.pl 1
 # Detach the screen when ready
 asciinema rec ~/talk.cast -c 'screen -DR'

=cut

push @SLIDES, {
	title => "Welcome",
	render => [
		{ y=>'+4', x=>'c', color=>'bold bright_white',
			text => "Pinpointing Changes with Bisection‎" },
		{ y=>'+3', x=>'c', color=>'bold bright_green',
			text => "Hauke Dämpfling (haukex)" },
		{ y=>'+3', x=>'c', color=>'bright_blue',
			text=>'23. Deutscher Perl/Raku-Workshop 2021 Leipzig' },
		{ x=>'c', color=>'bright_blue', text=>'24. bis 26. März 2021' },
		{ y=>'+3', x=>'c', color=>'white',
			text=>'This talk is available at https://haukex.github.io/bisectalk' },
	], };

=head1 Welcome

=cut

push @SLIDES, {
	title => "Outline",
	render => [
		{ y=>'+2', text => "• Motivation" },
		{ y=>'+2', text => "• Binary Search" },
		{ y=>'+2', text => "• git bisect" },
		{ y=>'+2', text => "\t◦ Several examples" },
		{ y=>'+2', text => "• Bisecting Perl" },
		{ y=>'+2', text => "\t◦ Explanation of the Process" },
		{ y=>'+2', text => "\t◦ Several examples" },
	], };

=head1 Outline

=cut

push @SLIDES, {
	title => "Motivation",
	render => [
		{ y=>'+2', text => "▸ \"When was a bug introduced / fixed?\"" }, # Bullet: ‣
		{ y=>'+2', text => "\t▹ \"Where can I find details on the bug?\"" },
		{ y=>'+2', text => "▸ \"When was a feature added?\"" },
		{ y=>'+2', text => "\t▹ \"What was the discussion leading up to this change?\"" },
		{ y=>'+2', text => "▸ Pinpoint changes down to the git commit" },
		{ y=>'+2', text => "▸ Efficient binary search" },
		{ y=>'+2', text => "▸ Can be largely automated" },
	], };

=head1 Motivation

=cut

push @SLIDES, {
	title => "Binary Search",
	render => [
		{ y=>'+2', text => "• Efficient search in a sorted list" },
		{ y=>'+3', x=>'c', color=>'bold bright_red',
			text=>'Demo!' },
	], };

=head1 Binary Search

 cat /tmp/list.txt
 # mention list is sorted and we're seeking *only one* value
 ./binsearch_viz.pl 19941017 /tmp/list.txt

=cut

push @SLIDES, {
	title => "git bisect",
	render => [
		{ y=>'+2', text => "• Binary search in a git repository" },
		{ y=>'+3', x=>'c', color=>'bold bright_red',
			text=>'Demo!' },
	], };

=head1 C<git bisect>

 ./math.pl '1+2'
 ./math.pl ' (1+2) * 0.4 ^ 5 '
 git log --oneline --graph

 git help bisect
 # Talk about manual bisect briefly
 # Talk about how we want to use scripts instead ("bisect run")
 # Mention terms good/bad old/new etc. ("terms")

 cat bisect/subtract.sh

 cp bisect/subtract.sh /tmp/
 git bisect start
 git bisect old be83
 git bisect new HEAD
 git bisect run /tmp/subtract.sh
 git bisect reset

 cat bisect/runner.sh

 bisect/viz.pl bisect/subtract.sh

 git log --oneline --graph --author-date-order

 ./math.pl '+10'
 cat bisect/posnum.sh
 bisect/viz.pl bisect/posnum.sh
 git show 7d3e

 ls -l bisect

=cut

push @SLIDES, {
	title => "Bisecting perl",
	render => [
		{ y=>'+2', text => "• git bisect scripts can be any script/program" },
		{ y=>'+2', text => "• Perl source tree includes helper scripts" },
		{ y=>'+2', text => "\t◦ Runs Configure, make, and our test script" },
		{ y=>'+2', text => "\t◦ Applies patches as needed to get old versions to compile" },
		{ y=>'+2', text => "• Outline" },
		{ y=>'+2', text => "\t◦ Prerequisites" },
		{ y=>'+2', text => "\t◦ Boiling down your code" },
		{ y=>'+2', text => "\t◦ Preview with perlbrew" },
		{ y=>'+2', text => "\t◦ Running the bisect" },
		{ y=>'+2', text => "\t◦ Analyzing the result" },
		{ y=>'+2', text => "\t◦ Examples" },
		{ y=>'+2', text => "• Let's start a bisect now and inspect the output later" },
		{ y=>'+3', x=>'c', color=>'bold bright_red',
			text=>'Demo!' },
	], };

=head1 Bisecting C<perl>

 Porting/bisect.pl --start=v5.10.0 --end=v5.18.0 --expect-fail --target=miniperl -e 's///r'
 # or, due to current git bug, commits instead of tags:
 Porting/bisect.pl --start=aa00ea --end=a9acda --expect-fail --target=miniperl -e 's///r'
 # Takes about 6 min on my box, just barely the right time for the slides in between

=cut

push @SLIDES, {
	title => "Prerequisites",
	render => [
		{ y=>'+2', text => "• I've always used Linux" },
		{ text => "\t◦ Should work on most *NIX OSes" },
		{ text => "\t◦ I haven't tried on Windows" },
		{ y=>'+2', text => "• git clone https://github.com/Perl/perl5.git ~/perl5/src" },
		{ y=>'+2', text => "• Libraries needed to build Perl, e.g. on Debian/Ubuntu:" },
		{ text => "\t◦ sudo apt-get install build-essential" },
		{ text => "\t◦ sudo apt-get build-dep perl" },
		{ y=>'+2', text => "• perlbrew (strongly recommended)" },
	], };

=head1 Prerequisites

=cut

push @SLIDES, {
	title => "Preparation",
	render => [
		{ y=>'+2', text => "• Boiling down your code" },
		{ y=>'+2', text => "\t◦ Must be stable, beware of false positives" },
		{ y=>'+2', text => "\t◦ Shorter is better to avoid multiple variables" },
		{ y=>'+2', text => "\t◦ Only important thing is perl's exit code, not output" },
		{ y=>'+2', text => "\t◦ Remember backwards-compatibility of test code" },
		{ y=>'+2', text => "\t◦ Using non-core modules is possible but not easy" },
		{ y=>'+2', text => "\t◦ Sometimes \"clever\" solutions are required (e.g. calling another perl with `\$^X`)" },
		{ y=>'+2', text => "• Preview with perlbrew exec" },
		{ y=>'+2', text => "\t◦ Is a good check of your test case" },
		{ y=>'+2', text => "\t◦ Can narrow down versions to test" },
		{ y=>'+2', text => "\t◦ Useful to detect multiple changes" },
		{ text => "\t  Remember, only one change in behavior can be detected!" },
		{ y=>'+2', text => "• Also check perl*delta for documentation" },
	], };

=head1 Preparation

=cut

push @SLIDES, {
	title => "Running the Bisection",
	render => [
		{ y=>'+2', text => "• Documentation: perldoc ./Porting/bisect-runner.pl" },
		{ y=>'+2', text => "\t◦ but the script we run is ./Porting/bisect.pl !" },
		{ y=>'+2', text => "• Some frequently-used options:" },
		{ y=>'+2', text => "\t◦ --start=... and --end=... to limit search range (use `git tag` to get list)" },
		{ y=>'+2', text => "\t◦ --expect-fail if you are looking for a transition from failing to succeeding" },
		{ text => "\t  (default is to look for a transition from succeeding to failing)" },
		{ y=>'+2', text => "\t◦ --target=miniperl if you don't need any modules (testing syntax only)" },
		{ y=>'+2', text => "\t◦ Oneliners: -e 's///r'" },
		{ y=>'+2', text => "\t◦ Scripts: -- ./perl -Ilib /path/to/script.pl" },
		{ y=>'+2', text => "• Can take up to several hours" },
	], };

=head1 Running the Bisection

=cut

push @SLIDES, {
	title => "Analyzing the Results",
	render => [
		{ y=>'+2', text => "• Look up the commit, e.g. https://github.com/Perl/perl5/commit/COMMITHASH" },
		{ y=>'+2', text => "• Does this commit make sense as the result? Red herrings are possible!" },
		{ y=>'+2', text => "• Bug numbers are often named in commit or the diff" },
		{ text => "\t◦ https://github.com/Perl/perl5/issues" },
		{ text => "\t◦ Remember GitHub and RT issues have different numberings" },
		{ text => "\t◦ RT bugs can be found in GitHub issues via \"RT12345\"" },
		{ y=>'+2', text => "• git tag --contains COMMITHASH" },
		{ y=>'+2', text => "• Check perl*delta again for bug number" },
		{ y=>'+2', text => "• Check perlhist for age of Perl version" },
	], };

=head1 Analyzing the Results

=cut

push @SLIDES, {
	title => "Example 1: s///r",
	render => [
		{ y=>'+2', text => "• The command we started earlier should now be done" },
		{ y=>'+2', text => "• Porting/bisect.pl --start=v5.10.0 --end=v5.18.0 --expect-fail --target=miniperl -e 's///r'" },
		{          text => "                            (aa00ea)      (a9acda)" },
		{ y=>'+3', x=>'c', color=>'bold bright_red',
			text=>'Demo!' },
	], };

=head1 Example 1: s///r

 git tag --contains 4f4d75
 # => v5.13.2
 perldoc perl5140delta
 git bisect reset
 git checkout blead

=cut

push @SLIDES, {
	title => "Example 2: Bug in Threaded 5.10.0 + ?PATTERN?",
	render => [
		{ y=>'+2', text => "• https://www.perlmonks.org/?node_id=1217469" },
		{ y=>'+2', text => "• On a threaded 5.10.0, eval ' \"x\" =~ ?x? ' was throwing an exception" },
		{ y=>'+2', text => "• Porting/bisect.pl -Dusethreads --target=miniperl --expect-fail \\" },
		{ text => "    --start=v5.10.0 --end=v5.26.0 -e 'eval q(\"x\"=~?x?)'" },
		{ y=>'+2', text => "• ⇒ \"9cddf794fc52f08a145668164b1e3c15c91a713f is the first bad commit\"" },
		{ y=>'+2', text => "• git tag --contains 9cddf794fc5 ⇒  perl-5.10.1" },
		{ y=>'+2', text => "• This commit can be used as a patch!" },
		{ text => "\t◦ git checkout v5.10.0" },
		{ text => "\t◦ cpanm Devel::PatchPerl; patchperl  # to get older Perl to build on newer machine" },
		{ text => "\t◦ git show 9cddf794fc5 | git apply" },
		{ text => "\t◦ sh Configure -des -Dusethreads" },
		{ text => "\t◦ make miniperl" },
		{ text => "\t◦ ./miniperl -e 'eval q( \"x\" =~ ?x? ) and print \"OK!\\n\"'" },
		{ text => "\t◦ ⇒ \"OK!\"" },
	], };

=head1 Example 2: Bug in Threaded 5.10.0 + ?PATTERN?

Note that not every commit can be used as a patch.

=cut

push @SLIDES, {
	title => "Example 3: Red Herring",
	render => [
		{ y=>'+2', text => "• https://www.perlmonks.org/?node_id=1176900" },
		{ y=>'+2', text => "• Bug on Perls 5.22 and 5.24: my \@x = split /o/, \"oo\"; \$#x = 1; \$x[-1] = 0;" },
		{ text => "  ⇒ \"Modification of a read-only value attempted\"" },
		{ y=>'+2', text => "• ⇒ commit 4ecee209, \"op.c: Distangle split and common-vars\"" },
		{ y=>'+2', text => "• dave_the_m: \"The bisect is misleading; the issue is with split when it is optimised to split " },
		{ text => "  directly to an array (rather than just returning a list which later gets assigned to something)." },
		{ text => "  When exactly this optimisation is enabled has changed between releases, and that commit is one" },
		{ text => "  of those changes. The real issue was introduced in perl 5.19.4, and I've just fixed in it in" },
		{ text => "  blead with [commit 71ca73e5f]\"" },
		{ y=>'+2', text => "• Sometimes, knowing the details of the internals is necessary" },
		{ y=>'+2', text => "\t◦ But as long as the bisect isn't too misleading, it can still help bug reports" },
	], };

=head1 Example 3: Red Herring

=cut

push @SLIDES, {
	title => "Example 4: List Constant Inlining",
	render => [
		{ y=>'+2', text => "• Based on https://www.perlmonks.org/?node_id=1218903" },
		{ y=>'+2', text => "• ⇒ commit f815dc14d7c, \"Inline list constants\"" },
		{ y=>'+3', x=>'c', color=>'bold bright_red',
			text=>'Demo!' },
	], };

=head1 Example 4: List Constant Inlining

 # in perl5 src:
 perl -MO=Deparse -e 'use constant X=>3,4; @x[X]'
 perlbrew exec perl -MO=Deparse -e 'use constant X=>3,4; @x[X]'
 perlbrew exec perl -MO=Concise -e 'use constant X=>3,4; @x[X]'
 perl -e 'print `$^X -Ilib -MO=Concise -e "use constant X=>3,4; \@x[X]"`'
 perlbrew exec perl -e 'print `$^X -Ilib -MO=Concise -e "use constant X=>3,4; \@x[X]"`'
 perlbrew exec perl -e '`$^X -Ilib -MO=Concise -e "use constant X=>3,4; \@x[X]"` =~ /entersub/ or die'
 ./Porting/bisect.pl --start=v5.18.0 --end=v5.20.3 -e '`$^X -Ilib -MO=Concise -e "use constant X=>3,4; \@x[X]"` =~ /entersub/ or die'
 # due to current git bug, we need to use commits instead of tags
 git show v5.18.0

=cut

push @SLIDES, {
	title => "Example 5: Bug in Debugger Line Numbering",
	render => [
		{ y=>'+2', text => "• https://www.perlmonks.org/?node_id=11110616" },
		{ y=>'+3', x=>'c', color=>'bold bright_red',
			text=>'Demo!' },
	], };

=head1 Example 5: Bug in Debugger Line Numbering

 cat examples/11110568.pl
 perl -d examples/11110568.pl
 # use "l" command, then "q"
 perlbrew exec --with perl-5.26.3 perl -d examples/11110568.pl
 # same, and line numbers are incorrect

 view examples/11110616.pl

 perlbrew list
 perlbrew exec -q perl examples/11110616.pl

 view examples/11110616.pl

 # in perl5 src:
 git show 823ba44
 # point out bug number

=cut

push @SLIDES, {
	title => "Conclusion",
	render => [
		{ y=>'+2', text => "• This talk was inspired by my node \"How to Bisect Perl\" on PerlMonks" },
		{ color=>'blue', text => "\t◦ https://www.perlmonks.org/?node_id=11110663" },
		{ text => "\t◦ Contains several links to more examples" },
		{ y=>'+2', text=>'• This talk is available at https://haukex.github.io/bisectalk' },
		{ y=>'+4', x=>'c', color=>'bold bright_yellow',
			text=>'❓ Questions ❓' },
		{ y=>'+4', x=>'c', color=>'bold bright_green',
			text=>'Thank You! ☺ ' },
	], };

=head1 Conclusion

=cut

