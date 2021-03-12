#!/usr/bin/env perl
use warnings;
use 5.028;
use Test::More tests=>1;
use FindBin;
use File::Spec::Functions qw/catfile updir/;
use JSON::PP 'decode_json';
use IPC::Run3::Shell [ getlist =>
	{ fail_on_stderr=>1, show_cmd=>Test::More->builder->output },
	$^X, catfile($FindBin::Bin, updir, 'getlist.pl') ];
use File::Temp qw/tempfile/;

my ($fh,$fn) = tempfile(UNLINK=>1);
print $fh <DATA>;
close $fh;
my $data = decode_json( scalar getlist($fn) );

my $expect = [
	{ pumpking=>'Larry',    version=>'1.000',    date=>'1987-12-18' },
	{ pumpking=>'Larry',    version=>'2.000',    date=>'1988-06-05' },
	{ pumpking=>'Larry',    version=>'3.000',    date=>'1989-10-18' },
	{                       version=>'3.041',    date=>'1990-11-13' },
	{ pumpking=>'Larry',    version=>'4.000',    date=>'1991-03-21' },
	{                       version=>'4.035',    date=>'1992-06-23' },
	{ pumpking=>'Larry',    version=>'4.036',    date=>'1993-02-05', comment=>'Very stable.' },
	{ pumpking=>'Larry',    version=>'5.000',    date=>'1994-10-17' },
	{ pumpking=>'Larry',    version=>'5.001',    date=>'1995-03-13' },
	{ pumpking=>'Larry',    version=>'5.002',    date=>'1996-02-29', comment=>'Prototypes.' },
	{ pumpking=>'Chip',     version=>'5.004',    date=>'1997-05-15', comment=>'A major maintenance release.' },
	{                       version=>'5.004_05', date=>'1999-04-29' },
	{ pumpking=>'Sarathy',  version=>'5.005',    date=>'1998-07-22', comment=>'Oneperl.' },
	{ pumpking=>'Sarathy',  version=>'5.6.0',    date=>'2000-03-22' },
	{                       version=>'5.6.1',    date=>'2001-04-08' },
	{ pumpking=>'Jarkko',   version=>'5.8.0',    date=>'2002-07-18' },
	{                       version=>'5.8.1',    date=>'2003-09-25' },
	{                       version=>'5.8.6',    date=>'2004-11-27' },
	{                       version=>'5.8.7',    date=>'2005-05-30' },
	{                       version=>'5.8.8',    date=>'2006-01-31' },
	{                       version=>'5.8.9',    date=>'2008-12-14' },
	{ pumpking=>'Rafael',   version=>'5.10.0',   date=>'2007-12-18' },
	{                       version=>'5.10.1',   date=>'2009-08-22' },
	{ pumpking=>'Jesse',    version=>'5.12.0',   date=>'2010-04-12' },
	{ pumpking=>'Jesse',    version=>'5.14.0',   date=>'2011-05-14', comment=>'The 5.14 maintenance track' },
	{ pumpking=>'Ricardo',  version=>'5.16.0',   date=>'2012-05-20', comment=>'The 5.16 maintenance track' },
	{ pumpking=>'Ricardo',  version=>'5.18.0',   date=>'2013-05-18' },
	{ pumpking=>'Ricardo',  version=>'5.20.0',   date=>'2014-05-27' },
	{ pumpking=>'Ricardo',  version=>'5.22.0',   date=>'2015-06-01' },
	{ pumpking=>'Ricardo',  version=>'5.24.0',   date=>'2016-05-09' },
	{ pumpking=>'Sawyer X', version=>'5.26.0',   date=>'2017-05-30' },
	{ pumpking=>'Sawyer X', version=>'5.28.0',   date=>'2018-06-22' },
	{ pumpking=>'Sawyer X', version=>'5.30.0',   date=>'2019-05-22' },
	{ pumpking=>'Sawyer X', version=>'5.32.0',   date=>'2020-06-20' },
];

is_deeply $data, $expect or diag explain $data;

# the following is https://github.com/Perl/perl5/raw/5d273ab/pod/perlhist.pod
__DATA__
=encoding utf8

=head1 NAME

perlhist - the Perl history records

=head1 DESCRIPTION

This document aims to record the Perl source code releases.

=head1 INTRODUCTION

Perl history in brief, by Larry Wall:

   Perl 0 introduced Perl to my officemates.
   Perl 1 introduced Perl to the world, and changed /\(...\|...\)/ to
       /(...|...)/.  \(Dan Faigin still hasn't forgiven me. :-\)
   Perl 2 introduced Henry Spencer's regular expression package.
   Perl 3 introduced the ability to handle binary data (embedded nulls).
   Perl 4 introduced the first Camel book.  Really.  We mostly just
       switched version numbers so the book could refer to 4.000.
   Perl 5 introduced everything else, including the ability to
       introduce everything else.

=head1 THE KEEPERS OF THE PUMPKIN

Larry Wall, Andy Dougherty, Tom Christiansen, Charles Bailey, Nick
Ing-Simmons, Chip Salzenberg, Tim Bunce, Malcolm Beattie, Gurusamy
Sarathy, Graham Barr, Jarkko Hietaniemi, Hugo van der Sanden,
Michael Schwern, Rafael Garcia-Suarez, Nicholas Clark, Richard Clamp,
Leon Brocard, Dave Mitchell, Jesse Vincent, Ricardo Signes, Steve Hay,
Matt S Trout, David Golden, Florian Ragwitz, Tatsuhiko Miyagawa,
Chris C<BinGOs> Williams, Zefram, Ævar Arnfjörð Bjarmason, Stevan
Little, Dave Rolsky, Max Maischein, Abigail, Jesse Luehrs, Tony Cook,
Dominic Hargreaves, Aaron Crane, Aristotle Pagaltzis, Matthew Horsfall,
Peter Martini, Sawyer X, Chad 'Exodist' Granum, Renee Bäcker, Eric Herman,
John SJ Anderson, Karen Etheridge, Zak B. Elep, Tom Hukins, and Richard
Leach.

=head2 PUMPKIN?

[from Porting/pumpkin.pod in the Perl source code distribution]

=for disclaimer orking cows is hazardous, and not legal in all jurisdictions

Chip Salzenberg gets credit for that, with a nod to his cow orker,
David Croy.  We had passed around various names (baton, token, hot
potato) but none caught on.  Then, Chip asked:

[begin quote]

   Who has the patch pumpkin?

To explain:  David Croy once told me that at a previous job,
there was one tape drive and multiple systems that used it for backups.
But instead of some high-tech exclusion software, they used a low-tech
method to prevent multiple simultaneous backups: a stuffed pumpkin.
No one was allowed to make backups unless they had the "backup pumpkin".

[end quote]

The name has stuck.  The holder of the pumpkin is sometimes called
the pumpking (keeping the source afloat?) or the pumpkineer (pulling
the strings?).

=head1 THE RECORDS

 Pump-  Release         Date            Notes
 kin                                    (by no means
 Holder                                  comprehensive,
                                         see Changes*
                                         for details)
 ======================================================================

 Larry   0              Classified.     Don't ask.

 Larry   1.000          1987-Dec-18

          1.001..10     1988-Jan-30
          1.011..14     1988-Feb-02
 Schwern  1.0.15        2002-Dec-18     Modernization
 Richard  1.0_16        2003-Dec-18

 Larry   2.000          1988-Jun-05

          2.001         1988-Jun-28

 Larry   3.000          1989-Oct-18

          3.001         1989-Oct-26
          3.002..4      1989-Nov-11
          3.005         1989-Nov-18
          3.006..8      1989-Dec-22
          3.009..13     1990-Mar-02
          3.014         1990-Mar-13
          3.015         1990-Mar-14
          3.016..18     1990-Mar-28
          3.019..27     1990-Aug-10     User subs.
          3.028         1990-Aug-14
          3.029..36     1990-Oct-17
          3.037         1990-Oct-20
          3.040         1990-Nov-10
          3.041         1990-Nov-13
          3.042..43     1991-Jan-??
          3.044         1991-Jan-12

 Larry   4.000          1991-Mar-21

          4.001..3      1991-Apr-12
          4.004..9      1991-Jun-07
          4.010         1991-Jun-10
          4.011..18     1991-Nov-05
          4.019         1991-Nov-11     Stable.
          4.020..33     1992-Jun-08
          4.034         1992-Jun-11
          4.035         1992-Jun-23
 Larry    4.036         1993-Feb-05     Very stable.

          5.000alpha1   1993-Jul-31
          5.000alpha2   1993-Aug-16
          5.000alpha3   1993-Oct-10
          5.000alpha4   1993-???-??
          5.000alpha5   1993-???-??
          5.000alpha6   1994-Mar-18
          5.000alpha7   1994-Mar-25
 Andy     5.000alpha8   1994-Apr-04
 Larry    5.000alpha9   1994-May-05     ext appears.
          5.000alpha10  1994-Jun-11
          5.000alpha11  1994-Jul-01
 Andy     5.000a11a     1994-Jul-07     To fit 14.
          5.000a11b     1994-Jul-14
          5.000a11c     1994-Jul-19
          5.000a11d     1994-Jul-22
 Larry    5.000alpha12  1994-Aug-04
 Andy     5.000a12a     1994-Aug-08
          5.000a12b     1994-Aug-15
          5.000a12c     1994-Aug-22
          5.000a12d     1994-Aug-22
          5.000a12e     1994-Aug-22
          5.000a12f     1994-Aug-24
          5.000a12g     1994-Aug-24
          5.000a12h     1994-Aug-24
 Larry    5.000beta1    1994-Aug-30
 Andy     5.000b1a      1994-Sep-06
 Larry    5.000beta2    1994-Sep-14     Core slushified.
 Andy     5.000b2a      1994-Sep-14
          5.000b2b      1994-Sep-17
          5.000b2c      1994-Sep-17
 Larry    5.000beta3    1994-Sep-??
 Andy     5.000b3a      1994-Sep-18
          5.000b3b      1994-Sep-22
          5.000b3c      1994-Sep-23
          5.000b3d      1994-Sep-27
          5.000b3e      1994-Sep-28
          5.000b3f      1994-Sep-30
          5.000b3g      1994-Oct-04
 Andy     5.000b3h      1994-Oct-07
 Larry?   5.000gamma    1994-Oct-13?

 Larry   5.000          1994-Oct-17

 Andy     5.000a        1994-Dec-19
          5.000b        1995-Jan-18
          5.000c        1995-Jan-18
          5.000d        1995-Jan-18
          5.000e        1995-Jan-18
          5.000f        1995-Jan-18
          5.000g        1995-Jan-18
          5.000h        1995-Jan-18
          5.000i        1995-Jan-26
          5.000j        1995-Feb-07
          5.000k        1995-Feb-11
          5.000l        1995-Feb-21
          5.000m        1995-Feb-28
          5.000n        1995-Mar-07
          5.000o        1995-Mar-13?

 Larry   5.001          1995-Mar-13

 Andy     5.001a        1995-Mar-15
          5.001b        1995-Mar-31
          5.001c        1995-Apr-07
          5.001d        1995-Apr-14
          5.001e        1995-Apr-18     Stable.
          5.001f        1995-May-31
          5.001g        1995-May-25
          5.001h        1995-May-25
          5.001i        1995-May-30
          5.001j        1995-Jun-05
          5.001k        1995-Jun-06
          5.001l        1995-Jun-06     Stable.
          5.001m        1995-Jul-02     Very stable.
          5.001n        1995-Oct-31     Very unstable.
          5.002beta1    1995-Nov-21
          5.002b1a      1995-Dec-04
          5.002b1b      1995-Dec-04
          5.002b1c      1995-Dec-04
          5.002b1d      1995-Dec-04
          5.002b1e      1995-Dec-08
          5.002b1f      1995-Dec-08
 Tom      5.002b1g      1995-Dec-21     Doc release.
 Andy     5.002b1h      1996-Jan-05
          5.002b2       1996-Jan-14
 Larry    5.002b3       1996-Feb-02
 Andy     5.002gamma    1996-Feb-11
 Larry    5.002delta    1996-Feb-27

 Larry   5.002          1996-Feb-29     Prototypes.

 Charles  5.002_01      1996-Mar-25

         5.003          1996-Jun-25     Security release.

          5.003_01      1996-Jul-31
 Nick     5.003_02      1996-Aug-10
 Andy     5.003_03      1996-Aug-28
          5.003_04      1996-Sep-02
          5.003_05      1996-Sep-12
          5.003_06      1996-Oct-07
          5.003_07      1996-Oct-10
 Chip     5.003_08      1996-Nov-19
          5.003_09      1996-Nov-26
          5.003_10      1996-Nov-29
          5.003_11      1996-Dec-06
          5.003_12      1996-Dec-19
          5.003_13      1996-Dec-20
          5.003_14      1996-Dec-23
          5.003_15      1996-Dec-23
          5.003_16      1996-Dec-24
          5.003_17      1996-Dec-27
          5.003_18      1996-Dec-31
          5.003_19      1997-Jan-04
          5.003_20      1997-Jan-07
          5.003_21      1997-Jan-15
          5.003_22      1997-Jan-16
          5.003_23      1997-Jan-25
          5.003_24      1997-Jan-29
          5.003_25      1997-Feb-04
          5.003_26      1997-Feb-10
          5.003_27      1997-Feb-18
          5.003_28      1997-Feb-21
          5.003_90      1997-Feb-25     Ramping up to the 5.004 release.
          5.003_91      1997-Mar-01
          5.003_92      1997-Mar-06
          5.003_93      1997-Mar-10
          5.003_94      1997-Mar-22
          5.003_95      1997-Mar-25
          5.003_96      1997-Apr-01
          5.003_97      1997-Apr-03     Fairly widely used.
          5.003_97a     1997-Apr-05
          5.003_97b     1997-Apr-08
          5.003_97c     1997-Apr-10
          5.003_97d     1997-Apr-13
          5.003_97e     1997-Apr-15
          5.003_97f     1997-Apr-17
          5.003_97g     1997-Apr-18
          5.003_97h     1997-Apr-24
          5.003_97i     1997-Apr-25
          5.003_97j     1997-Apr-28
          5.003_98      1997-Apr-30
          5.003_99      1997-May-01
          5.003_99a     1997-May-09
          p54rc1        1997-May-12     Release Candidates.
          p54rc2        1997-May-14

 Chip    5.004          1997-May-15     A major maintenance release.

 Tim      5.004_01-t1   1997-???-??     The 5.004 maintenance track.
          5.004_01-t2   1997-Jun-11     aka perl5.004m1t2
          5.004_01      1997-Jun-13
          5.004_01_01   1997-Jul-29     aka perl5.004m2t1
          5.004_01_02   1997-Aug-01     aka perl5.004m2t2
          5.004_01_03   1997-Aug-05     aka perl5.004m2t3
          5.004_02      1997-Aug-07
          5.004_02_01   1997-Aug-12     aka perl5.004m3t1
          5.004_03-t2   1997-Aug-13     aka perl5.004m3t2
          5.004_03      1997-Sep-05
          5.004_04-t1   1997-Sep-19     aka perl5.004m4t1
          5.004_04-t2   1997-Sep-23     aka perl5.004m4t2
          5.004_04-t3   1997-Oct-10     aka perl5.004m4t3
          5.004_04-t4   1997-Oct-14     aka perl5.004m4t4
          5.004_04      1997-Oct-15
          5.004_04-m1   1998-Mar-04     (5.004m5t1) Maint. trials for 5.004_05.
          5.004_04-m2   1998-May-01
          5.004_04-m3   1998-May-15
          5.004_04-m4   1998-May-19
          5.004_05-MT5  1998-Jul-21
          5.004_05-MT6  1998-Oct-09
          5.004_05-MT7  1998-Nov-22
          5.004_05-MT8  1998-Dec-03
 Chip     5.004_05-MT9  1999-Apr-26
          5.004_05      1999-Apr-29

 Malcolm  5.004_50      1997-Sep-09     The 5.005 development track.
          5.004_51      1997-Oct-02
          5.004_52      1997-Oct-15
          5.004_53      1997-Oct-16
          5.004_54      1997-Nov-14
          5.004_55      1997-Nov-25
          5.004_56      1997-Dec-18
          5.004_57      1998-Feb-03
          5.004_58      1998-Feb-06
          5.004_59      1998-Feb-13
          5.004_60      1998-Feb-20
          5.004_61      1998-Feb-27
          5.004_62      1998-Mar-06
          5.004_63      1998-Mar-17
          5.004_64      1998-Apr-03
          5.004_65      1998-May-15
          5.004_66      1998-May-29
 Sarathy  5.004_67      1998-Jun-15
          5.004_68      1998-Jun-23
          5.004_69      1998-Jun-29
          5.004_70      1998-Jul-06
          5.004_71      1998-Jul-09
          5.004_72      1998-Jul-12
          5.004_73      1998-Jul-13
          5.004_74      1998-Jul-14     5.005 beta candidate.
          5.004_75      1998-Jul-15     5.005 beta1.
          5.004_76      1998-Jul-21     5.005 beta2.

 Sarathy  5.005         1998-Jul-22     Oneperl.

 Sarathy  5.005_01      1998-Jul-27     The 5.005 maintenance track.
          5.005_02-T1   1998-Aug-02
          5.005_02-T2   1998-Aug-05
          5.005_02      1998-Aug-08
 Graham   5.005_03-MT1  1998-Nov-30
          5.005_03-MT2  1999-Jan-04
          5.005_03-MT3  1999-Jan-17
          5.005_03-MT4  1999-Jan-26
          5.005_03-MT5  1999-Jan-28
          5.005_03-MT6  1999-Mar-05
          5.005_03      1999-Mar-28
 Leon     5.005_04-RC1  2004-Feb-05
          5.005_04-RC2  2004-Feb-18
          5.005_04      2004-Feb-23
          5.005_05-RC1  2009-Feb-16

 Sarathy  5.005_50      1998-Jul-26     The 5.6 development track.
          5.005_51      1998-Aug-10
          5.005_52      1998-Sep-25
          5.005_53      1998-Oct-31
          5.005_54      1998-Nov-30
          5.005_55      1999-Feb-16
          5.005_56      1999-Mar-01
          5.005_57      1999-May-25
          5.005_58      1999-Jul-27
          5.005_59      1999-Aug-02
          5.005_60      1999-Aug-02
          5.005_61      1999-Aug-20
          5.005_62      1999-Oct-15
          5.005_63      1999-Dec-09
          5.5.640       2000-Feb-02
          5.5.650       2000-Feb-08     beta1
          5.5.660       2000-Feb-22     beta2
          5.5.670       2000-Feb-29     beta3
          5.6.0-RC1     2000-Mar-09     Release candidate 1.
          5.6.0-RC2     2000-Mar-14     Release candidate 2.
          5.6.0-RC3     2000-Mar-21     Release candidate 3.

 Sarathy  5.6.0         2000-Mar-22

 Sarathy  5.6.1-TRIAL1  2000-Dec-18     The 5.6 maintenance track.
          5.6.1-TRIAL2  2001-Jan-31
          5.6.1-TRIAL3  2001-Mar-19
          5.6.1-foolish 2001-Apr-01     The "fools-gold" release.
          5.6.1         2001-Apr-08
 Rafael   5.6.2-RC1     2003-Nov-08
          5.6.2         2003-Nov-15     Fix new build issues

 Jarkko   5.7.0         2000-Sep-02     The 5.7 track: Development.
          5.7.1         2001-Apr-09
          5.7.2         2001-Jul-13     Virtual release candidate 0.
          5.7.3         2002-Mar-05
          5.8.0-RC1     2002-Jun-01
          5.8.0-RC2     2002-Jun-21
          5.8.0-RC3     2002-Jul-13

 Jarkko   5.8.0         2002-Jul-18

 Jarkko   5.8.1-RC1     2003-Jul-10     The 5.8 maintenance track
          5.8.1-RC2     2003-Jul-11
          5.8.1-RC3     2003-Jul-30
          5.8.1-RC4     2003-Aug-01
          5.8.1-RC5     2003-Sep-22
          5.8.1         2003-Sep-25
 Nicholas 5.8.2-RC1     2003-Oct-27
          5.8.2-RC2     2003-Nov-03
          5.8.2         2003-Nov-05
          5.8.3-RC1     2004-Jan-07
          5.8.3         2004-Jan-14
          5.8.4-RC1     2004-Apr-05
          5.8.4-RC2     2004-Apr-15
          5.8.4         2004-Apr-21
          5.8.5-RC1     2004-Jul-06
          5.8.5-RC2     2004-Jul-08
          5.8.5         2004-Jul-19
          5.8.6-RC1     2004-Nov-11
          5.8.6         2004-Nov-27
          5.8.7-RC1     2005-May-18
          5.8.7         2005-May-30
          5.8.8-RC1     2006-Jan-20
          5.8.8         2006-Jan-31
          5.8.9-RC1     2008-Nov-10
          5.8.9-RC2     2008-Dec-06
          5.8.9         2008-Dec-14

 Hugo     5.9.0         2003-Oct-27     The 5.9 development track
 Rafael   5.9.1         2004-Mar-16
          5.9.2         2005-Apr-01
          5.9.3         2006-Jan-28
          5.9.4         2006-Aug-15
          5.9.5         2007-Jul-07
          5.10.0-RC1    2007-Nov-17
          5.10.0-RC2    2007-Nov-25

 Rafael   5.10.0        2007-Dec-18

 David M  5.10.1-RC1    2009-Aug-06     The 5.10 maintenance track
          5.10.1-RC2    2009-Aug-18
          5.10.1        2009-Aug-22

 Jesse    5.11.0        2009-Oct-02     The 5.11 development track
          5.11.1        2009-Oct-20
 Leon     5.11.2        2009-Nov-20
 Jesse    5.11.3        2009-Dec-20
 Ricardo  5.11.4        2010-Jan-20
 Steve    5.11.5        2010-Feb-20
 Jesse    5.12.0-RC0    2010-Mar-21
          5.12.0-RC1    2010-Mar-29
          5.12.0-RC2    2010-Apr-01
          5.12.0-RC3    2010-Apr-02
          5.12.0-RC4    2010-Apr-06
          5.12.0-RC5    2010-Apr-09

 Jesse    5.12.0        2010-Apr-12

 Jesse    5.12.1-RC2    2010-May-13     The 5.12 maintenance track
          5.12.1-RC1    2010-May-09
          5.12.1        2010-May-16
          5.12.2-RC2    2010-Aug-31
          5.12.2        2010-Sep-06
 Ricardo  5.12.3-RC1    2011-Jan-09
 Ricardo  5.12.3-RC2    2011-Jan-14
 Ricardo  5.12.3-RC3    2011-Jan-17
 Ricardo  5.12.3        2011-Jan-21
 Leon     5.12.4-RC1    2011-Jun-08
 Leon     5.12.4        2011-Jun-20
 Dominic  5.12.5        2012-Nov-10

 Leon     5.13.0        2010-Apr-20     The 5.13 development track
 Ricardo  5.13.1        2010-May-20
 Matt     5.13.2        2010-Jun-22
 David G  5.13.3        2010-Jul-20
 Florian  5.13.4        2010-Aug-20
 Steve    5.13.5        2010-Sep-19
 Miyagawa 5.13.6        2010-Oct-20
 BinGOs   5.13.7        2010-Nov-20
 Zefram   5.13.8        2010-Dec-20
 Jesse    5.13.9        2011-Jan-20
 Ævar     5.13.10       2011-Feb-20
 Florian  5.13.11       2011-Mar-20
 Jesse    5.14.0RC1     2011-Apr-20
 Jesse    5.14.0RC2     2011-May-04
 Jesse    5.14.0RC3     2011-May-11

 Jesse    5.14.0        2011-May-14     The 5.14 maintenance track
 Jesse    5.14.1        2011-Jun-16
 Florian  5.14.2-RC1    2011-Sep-19
          5.14.2        2011-Sep-26
 Dominic  5.14.3        2012-Oct-12
 David M  5.14.4-RC1    2013-Mar-05
 David M  5.14.4-RC2    2013-Mar-07
 David M  5.14.4        2013-Mar-10

 David G  5.15.0        2011-Jun-20     The 5.15 development track
 Zefram   5.15.1        2011-Jul-20
 Ricardo  5.15.2        2011-Aug-20
 Stevan   5.15.3        2011-Sep-20
 Florian  5.15.4        2011-Oct-20
 Steve    5.15.5        2011-Nov-20
 Dave R   5.15.6        2011-Dec-20
 BinGOs   5.15.7        2012-Jan-20
 Max M    5.15.8        2012-Feb-20
 Abigail  5.15.9        2012-Mar-20
 Ricardo  5.16.0-RC0    2012-May-10
 Ricardo  5.16.0-RC1    2012-May-14
 Ricardo  5.16.0-RC2    2012-May-15

 Ricardo  5.16.0        2012-May-20     The 5.16 maintenance track
 Ricardo  5.16.1        2012-Aug-08
 Ricardo  5.16.2        2012-Nov-01
 Ricardo  5.16.3-RC1    2013-Mar-06
 Ricardo  5.16.3        2013-Mar-11

 Zefram   5.17.0        2012-May-26     The 5.17 development track
 Jesse L  5.17.1        2012-Jun-20
 TonyC    5.17.2        2012-Jul-20
 Steve    5.17.3        2012-Aug-20
 Florian  5.17.4        2012-Sep-20
 Florian  5.17.5        2012-Oct-20
 Ricardo  5.17.6        2012-Nov-20
 Dave R   5.17.7        2012-Dec-18
 Aaron    5.17.8        2013-Jan-20
 BinGOs   5.17.9        2013-Feb-20
 Max M    5.17.10       2013-Mar-21
 Ricardo  5.17.11       2013-Apr-20

 Ricardo  5.18.0-RC1    2013-May-11     The 5.18 maintenance track
 Ricardo  5.18.0-RC2    2013-May-12
 Ricardo  5.18.0-RC3    2013-May-13
 Ricardo  5.18.0-RC4    2013-May-15
 Ricardo  5.18.0        2013-May-18
 Ricardo  5.18.1-RC1    2013-Aug-01
 Ricardo  5.18.1-RC2    2013-Aug-03
 Ricardo  5.18.1-RC3    2013-Aug-08
 Ricardo  5.18.1        2013-Aug-12
 Ricardo  5.18.2        2014-Jan-06
 Ricardo  5.18.3-RC1    2014-Sep-17
 Ricardo  5.18.3-RC2    2014-Sep-27
 Ricardo  5.18.3        2014-Oct-01
 Ricardo  5.18.4        2014-Oct-01

 Ricardo   5.19.0       2013-May-20     The 5.19 development track
 David G   5.19.1       2013-Jun-21
 Aristotle 5.19.2       2013-Jul-22
 Steve     5.19.3       2013-Aug-20
 Steve     5.19.4       2013-Sep-20
 Steve     5.19.5       2013-Oct-20
 BinGOs    5.19.6       2013-Nov-20
 Abigail   5.19.7       2013-Dec-20
 Ricardo   5.19.8       2014-Jan-20
 TonyC     5.19.9       2014-Feb-20
 Aaron     5.19.10      2014-Mar-20
 Steve     5.19.11      2014-Apr-20

 Ricardo   5.20.0-RC1   2014-May-16     The 5.20 maintenance track
 Ricardo   5.20.0       2014-May-27
 Steve     5.20.1-RC1   2014-Aug-25
 Steve     5.20.1-RC2   2014-Sep-07
 Steve     5.20.1       2014-Sep-14
 Steve     5.20.2-RC1   2015-Jan-31
 Steve     5.20.2       2015-Feb-14
 Steve     5.20.3-RC1   2015-Aug-22
 Steve     5.20.3-RC2   2015-Aug-29
 Steve     5.20.3       2015-Sep-12

 Ricardo   5.21.0       2014-May-27     The 5.21 development track
 Matthew H 5.21.1       2014-Jun-20
 Abigail   5.21.2       2014-Jul-20
 Peter     5.21.3       2014-Aug-20
 Steve     5.21.4       2014-Sep-20
 Abigail   5.21.5       2014-Oct-20
 BinGOs    5.21.6       2014-Nov-20
 Max M     5.21.7       2014-Dec-20
 Matthew H 5.21.8       2015-Jan-20
 Sawyer X  5.21.9       2015-Feb-20
 Steve     5.21.10      2015-Mar-20
 Steve     5.21.11      2015-Apr-20

 Ricardo   5.22.0-RC1   2015-May-19     The 5.22 maintenance track
 Ricardo   5.22.0-RC2   2015-May-21
 Ricardo   5.22.0       2015-Jun-01
 Steve     5.22.1-RC1   2015-Oct-31
 Steve     5.22.1-RC2   2015-Nov-15
 Steve     5.22.1-RC3   2015-Dec-02
 Steve     5.22.1-RC4   2015-Dec-08
 Steve     5.22.1       2015-Dec-13
 Steve     5.22.2-RC1   2016-Apr-10
 Steve     5.22.2       2016-Apr-29
 Steve     5.22.3-RC1   2016-Jul-17
 Steve     5.22.3-RC2   2016-Jul-25
 Steve     5.22.3-RC3   2016-Aug-11
 Steve     5.22.3-RC4   2016-Oct-12
 Steve     5.22.3-RC5   2017-Jan-02
 Steve     5.22.3       2017-Jan-14
 Steve     5.22.4-RC1   2017-Jul-01
 Steve     5.22.4       2017-Jul-15

 Ricardo   5.23.0       2015-Jun-20     The 5.23 development track
 Matthew H 5.23.1       2015-Jul-20
 Matthew H 5.23.2       2015-Aug-20
 Peter     5.23.3       2015-Sep-20
 Steve     5.23.4       2015-Oct-20
 Abigail   5.23.5       2015-Nov-20
 David G   5.23.6       2015-Dec-21
 Stevan    5.23.7       2016-Jan-20
 Sawyer X  5.23.8       2016-Feb-20
 Abigail   5.23.9       2016-Mar-20

 Ricardo   5.24.0-RC1   2016-Apr-13     The 5.24 maintenance track
 Ricardo   5.24.0-RC2   2016-Apr-23
 Ricardo   5.24.0-RC3   2016-Apr-26
 Ricardo   5.24.0-RC4   2016-May-02
 Ricardo   5.24.0-RC5   2016-May-04
 Ricardo   5.24.0       2016-May-09
 Steve     5.24.1-RC1   2016-Jul-17
 Steve     5.24.1-RC2   2016-Jul-25
 Steve     5.24.1-RC3   2016-Aug-11
 Steve     5.24.1-RC4   2016-Oct-12
 Steve     5.24.1-RC5   2017-Jan-02
 Steve     5.24.1       2017-Jan-14
 Steve     5.24.2-RC1   2017-Jul-01
 Steve     5.24.2       2017-Jul-15
 Steve     5.24.3-RC1   2017-Sep-10
 Steve     5.24.3       2017-Sep-22
 Steve     5.24.4-RC1   2018-Mar-24
 Steve     5.24.4       2018-Apr-14

 Ricardo   5.25.0       2016-May-09     The 5.25 development track
 Sawyer X  5.25.1       2016-May-20
 Matthew H 5.25.2       2016-Jun-20
 Steve     5.25.3       2016-Jul-20
 BinGOs    5.25.4       2016-Aug-20
 Stevan    5.25.5       2016-Sep-20
 Aaron     5.25.6       2016-Oct-20
 Chad      5.25.7       2016-Nov-20
 Sawyer X  5.25.8       2016-Dec-20
 Abigail   5.25.9       2017-Jan-20
 Renee     5.25.10      2017-Feb-20
 Sawyer X  5.25.11      2017-Mar-20
 Sawyer X  5.25.12      2017-Apr-20

 Sawyer X  5.26.0-RC1   2017-May-11     The 5.26 maintenance track
 Sawyer X  5.26.0-RC2   2017-May-23
 Sawyer X  5.26.0       2017-May-30
 Steve     5.26.1-RC1   2017-Sep-10
 Steve     5.26.1       2017-Sep-22
 Steve     5.26.2-RC1   2018-Mar-24
 Steve     5.26.2       2018-Apr-14
 Steve     5.26.3-RC1   2018-Nov-08
 Steve     5.26.3       2018-Nov-29

 Sawyer X  5.27.0       2017-May-31     The 5.27 development track
 Eric      5.27.1       2017-Jun-20
 Aaron     5.27.2       2017-Jul-20
 Matthew H 5.27.3       2017-Aug-21
 John      5.27.4       2017-Sep-20
 Steve     5.27.5       2017-Oct-20
 Ether     5.27.6       2017-Nov-20
 BinGOs    5.27.7       2017-Dec-20
 Abigail   5.27.8       2018-Jan-20
 Renee     5.27.9       2018-Feb-20
 Todd      5.27.10      2018-Mar-20
 Sawyer X  5.27.11      2018-Apr-20

 Sawyer X  5.28.0-RC1   2018-May-21     The 5.28 maintenance track
 Sawyer X  5.28.0-RC2   2018-Jun-06
 Sawyer X  5.28.0-RC3   2018-Jun-18
 Sawyer X  5.28.0-RC4   2018-Jun-19
 Sawyer X  5.28.0       2018-Jun-22
 Steve     5.28.1-RC1   2018-Nov-08
 Steve     5.28.1       2018-Nov-29
 Steve     5.28.2-RC1   2019-Apr-05
 Steve     5.28.2       2019-Apr-19
 Steve     5.28.3-RC1   2020-May-18
 Steve     5.28.3       2020-Jun-01

 Sawyer X  5.29.0       2018-Jun-26     The 5.29 development track
 Steve     5.29.1       2018-Jul-20
 BinGOs    5.29.2       2018-Aug-20
 John      5.29.3       2018-Sep-20
 Aaron     5.29.4       2018-Oct-20
 Ether     5.29.5       2018-Nov-20
 Abigail   5.29.6       2018-Dec-18
 Abigail   5.29.7       2019-Jan-20
 Nicolas R 5.29.8       2019-Feb-20
 Zak Elep  5.29.9       2019-Mar-20
 Sawyer X  5.29.10      2019-Apr-20

 Sawyer X  5.30.0-RC1   2019-May-11     The 5.30 maintenance track
 Sawyer X  5.30.0-RC2   2019-May-17
 Sawyer X  5.30.0       2019-May-22
 Steve     5.30.1-RC1   2019-Oct-27
 Steve     5.30.1       2019-Nov-10
 Steve     5.30.2-RC1   2020-Feb-29
 Steve     5.30.2       2020-Mar-14
 Steve     5.30.3-RC1   2020-May-18
 Steve     5.30.3       2020-Jun-01

 Sawyer X  5.31.0       2019-May-24     The 5.31 development track
 Ether     5.31.1       2019-Jun-20
 Steve     5.31.2       2019-Jul-20
 Tom H     5.31.3       2019-Aug-20
 Max M     5.31.4       2019-Sep-20
 Steve     5.31.5       2019-Oct-20
 BinGOs    5.31.6       2019-Nov-20
 Nicolas R 5.31.7       2019-Dec-20
 Matthew H 5.31.8       2020-Jan-20
 Renee     5.31.9       2020-Feb-20
 Sawyer X  5.31.10      2020-Mar-20
 Sawyer X  5.31.11      2020-Apr-28

 Sawyer X  5.32.0-RC0   2020-May-30     The 5.32 maintenance track
 Sawyer X  5.32.0-RC1   2020-Jun-07
 Sawyer X  5.32.0       2020-Jun-20
 Steve     5.32.1-RC1   2021-Jan-09
 Steve     5.32.1       2021-Jan-23

 Sawyer X  5.33.0       2020-Jul-17     The 5.33 development track
 Ether     5.33.1       2020-Aug-20
 Sawyer X  5.33.2       2020-Sep-20
 Steve     5.33.3       2020-Oct-20
 Tom H     5.33.4       2020-Nov-20
 Max M     5.33.5       2020-Dec-20
 Richard L 5.33.6       2021-Jan-20
 Renee     5.33.7       2021-Feb-20

=head2 SELECTED RELEASE SIZES

For example the notation "core: 212  29" in the release 1.000 means that
it had in the core 212 kilobytes, in 29 files.  The "core".."doc" are
explained below.

 release        core       lib         ext        t         doc
 ======================================================================

 1.000           212  29      -   -      -    -     38   51     62   3
 1.014           219  29      -   -      -    -     39   52     68   4
 2.000           309  31      2   3      -    -     55   57     92   4
 2.001           312  31      2   3      -    -     55   57     94   4
 3.000           508  36     24  11      -    -     79   73    156   5
 3.044           645  37     61  20      -    -     90   74    190   6
 4.000           635  37     59  20      -    -     91   75    198   4
 4.019           680  37     85  29      -    -     98   76    199   4
 4.036           709  37     89  30      -    -     98   76    208   5
 5.000alpha2     785  50    114  32      -    -    112   86    209   5
 5.000alpha3     801  50    117  33      -    -    121   87    209   5
 5.000alpha9    1022  56    149  43    116   29    125   90    217   6
 5.000a12h       978  49    140  49    205   46    152   97    228   9
 5.000b3h       1035  53    232  70    216   38    162   94    218  21
 5.000          1038  53    250  76    216   38    154   92    536  62
 5.001m         1071  54    388  82    240   38    159   95    544  29
 5.002          1121  54    661 101    287   43    155   94    847  35
 5.003          1129  54    680 102    291   43    166  100    853  35
 5.003_07       1231  60    748 106    396   53    213  137    976  39
 5.004          1351  60   1230 136    408   51    355  161   1587  55
 5.004_01       1356  60   1258 138    410   51    358  161   1587  55
 5.004_04       1375  60   1294 139    413   51    394  162   1629  55
 5.004_05       1463  60   1435 150    394   50    445  175   1855  59
 5.004_51       1401  61   1260 140    413   53    358  162   1594  56
 5.004_53       1422  62   1295 141    438   70    394  162   1637  56
 5.004_56       1501  66   1301 140    447   74    408  165   1648  57
 5.004_59       1555  72   1317 142    448   74    424  171   1678  58
 5.004_62       1602  77   1327 144    629   92    428  173   1674  58
 5.004_65       1626  77   1358 146    615   92    446  179   1698  60
 5.004_68       1856  74   1382 152    619   92    463  187   1784  60
 5.004_70       1863  75   1456 154    675   92    494  194   1809  60
 5.004_73       1874  76   1467 152    762  102    506  196   1883  61
 5.004_75       1877  76   1467 152    770  103    508  196   1896  62
 5.005          1896  76   1469 152    795  103    509  197   1945  63
 5.005_03       1936  77   1541 153    813  104    551  201   2176  72
 5.005_50       1969  78   1842 301    795  103    514  198   1948  63
 5.005_53       1999  79   1885 303    806  104    602  224   2002  67
 5.005_56       2086  79   1970 307    866  113    672  238   2221  75
 5.6.0          2820  79   2626 364   1096  129    863  280   2840  93
 5.6.1          2946  78   2921 430   1171  132   1024  304   3330 102
 5.6.2          2947  78   3143 451   1247  127   1303  387   3406 102
 5.7.0          2977  80   2801 425   1250  132    975  307   3206 100
 5.7.1          3351  84   3442 455   1944  167   1334  357   3698 124
 5.7.2          3491  87   4858 618   3290  298   1598  449   3910 139
 5.7.3          3299  85   4295 537   2196  300   2176  626   4171 120
 5.8.0          3489  87   4533 585   2437  331   2588  726   4368 125
 5.8.1          3674  90   5104 623   2604  353   2983  836   4625 134
 5.8.2          3633  90   5111 623   2623  357   3019  848   4634 135
 5.8.3          3625  90   5141 624   2660  363   3083  869   4669 136
 5.8.4          3653  90   5170 634   2684  368   3148  885   4689 137
 5.8.5          3664  90   4260 303   2707  369   3208  898   4689 138
 5.8.6          3690  90   4271 303   3141  396   3411  925   4709 139
 5.8.7          3788  90   4322 307   3297  401   3485  964   4744 141
 5.8.8          3895  90   4357 314   3409  431   3622 1017   4979 144
 5.8.9          4132  93   5508 330   3826  529   4364 1234   5348 152
 5.9.0          3657  90   4951 626   2603  354   3011  841   4609 135
 5.9.1          3580  90   5196 634   2665  367   3186  889   4725 138
 5.9.2          3863  90   4654 312   3283  403   3551  973   4800 142
 5.9.3          4096  91   5318 381   4806  597   4272 1214   5139 147
 5.9.4          4393  94   5718 415   4578  642   4646 1310   5335 153
 5.9.5          4681  96   6849 479   4827  671   5155 1490   5572 159
 5.10.0         4710  97   7050 486   4899  673   5275 1503   5673 160
 5.10.1         4858  98   7440 519   6195  921   6147 1751   5151 163
 5.12.0         4999 100   1146 121  15227 2176   6400 1843   5342 168
 5.12.1         5000 100   1146 121  15283 2178   6407 1846   5354 169
 5.12.2         5003 100   1146 121  15404 2178   6413 1846   5376 170
 5.12.3         5004 100   1146 121  15529 2180   6417 1848   5391 171
 5.14.0         5328 104   1100 114  17779 2479   7697 2130   5871 188
 5.16.0         5562 109   1077  80  20504 2702   8750 2375   4815 152
 5.18.0         5892 113   1088  79  20077 2760   9365 2439   4943 154
 5.20.0         6243 115   1187  75  19499 2701   9620 2457   5145 159
 5.22.0         7819 115   1284  77  19121 2635   9772 2434   5615 176
 5.24.0         7922 113   1287  77  19535 2677   9994 2465   5702 177
 5.26.0         9140 121  24925 1200 40643 3017  10514 2614   7854 211
 5.28.0        13056 128  27267 1230 41745 3130  10952 2715   8185 218
 5.30.0        13535 128  26294 1237 39643 3080  11083 2711   8252 222
 5.32.0        14147 127  25562 1255 40869 3098  11334 2734   8407 225

The "core"..."doc" mean the following files from the Perl source code
distribution.  The glob notation ** means recursively, (.) means
regular files.

 core   *.[hcy]
 lib    lib/**/*.p[ml]
 ext    ext/**/*.{[hcyt],xs,pm} (for -5.10.1) or
        {dist,ext,cpan}/**/*.{[hcyt],xs,pm} (for 5.12.0-)
 t      t/**/*(.) (for 1-5.005_56) or **/*.t (for 5.6.0-5.7.3)
 doc    {README*,INSTALL,*[_.]man{,.?},pod/**/*.pod}

Here are some statistics for the other subdirectories and one file in
the Perl source distribution for somewhat more selected releases.

 ======================================================================
   Legend:  kB   #

                  1.014      2.001      3.044

 Configure      31    1    37    1    62    1
 eg              -    -    34   28    47   39
 h2pl            -    -     -    -    12   12
 msdos           -    -     -    -    41   13
 os2             -    -     -    -    63   22
 usub            -    -     -    -    21   16
 x2p           103   17   104   17   137   17

 ======================================================================

                  4.000      4.019      4.036

 atarist         -    -     -    -   113   31
 Configure      73    1    83    1    86    1
 eg             47   39    47   39    47   39
 emacs          67    4    67    4    67    4
 h2pl           12   12    12   12    12   12
 hints           -    -     5   42    11   56
 msdos          57   15    58   15    60   15
 os2            81   29    81   29   113   31
 usub           25    7    43    8    43    8
 x2p           147   18   152   19   154   19

 ======================================================================

                5.000a2  5.000a12h   5.000b3h      5.000     5.001m

 apollo          8    3     8    3     8    3     8    3     8    3
 atarist       113   31   113   31     -    -     -    -     -    -
 bench           -    -     0    1     -    -     -    -     -    -
 Bugs            2    5    26    1     -    -     -    -     -    -
 dlperl         40    5     -    -     -    -     -    -     -    -
 do            127   71     -    -     -    -     -    -     -    -
 Configure       -    -   153    1   159    1   160    1   180    1
 Doc             -    -    26    1    75    7    11    1    11    1
 eg             79   58    53   44    51   43    54   44    54   44
 emacs          67    4   104    6   104    6   104    1   104    6
 h2pl           12   12    12   12    12   12    12   12    12   12
 hints          11   56    12   46    18   48    18   48    44   56
 msdos          60   15    60   15     -    -     -    -     -    -
 os2           113   31   113   31     -    -     -    -     -    -
 U               -    -    62    8   112   42     -    -     -    -
 usub           43    8     -    -     -    -     -    -     -    -
 vms             -    -    80    7   123    9   184   15   304   20
 x2p           171   22   171   21   162   20   162   20   279   20

 ======================================================================

                  5.002      5.003   5.003_07

 Configure     201    1   201    1   217    1
 eg             54   44    54   44    54   44
 emacs         108    1   108    1   143    1
 h2pl           12   12    12   12    12   12
 hints          73   59    77   60    90   62
 os2            84   17    56   10   117   42
 plan9           -    -     -    -    79   15
 Porting         -    -     -    -    51    1
 utils          87    7    88    7    97    7
 vms           500   24   475   26   505   27
 x2p           280   20   280   20   280   19

 ======================================================================

                  5.004   5.004_04   5.004_62   5.004_65   5.004_68

 beos            -    -     -    -     -    -      1   1      1   1
 Configure     225    1   225    1   240    1    248   1    256   1
 cygwin32       23    5    23    5    23    5     24   5     24   5
 djgpp           -    -     -    -    14    5     14   5     14   5
 eg             81   62    81   62    81   62     81  62     81  62
 emacs         194    1   204    1   212    2    212   2    212   2
 h2pl           12   12    12   12    12   12     12  12     12  12
 hints         129   69   132   71   144   72    151  74    155  74
 os2           121   42   127   42   127   44    129  44    129  44
 plan9          82   15    82   15    82   15     82  15     82  15
 Porting        94    2   109    4   203    6    234   8    241   9
 qnx             1    2     1    2     1    2      1   2      1   2
 utils         112    8   118    8   124    8    156   9    159   9
 vms           518   34   524   34   538   34    569  34    569  34
 win32         285   33   378   36   470   39    493  39    575  41
 x2p           281   19   281   19   281   19    282  19    281  19

 ======================================================================

               5.004_70   5.004_73   5.004_75      5.005   5.005_03

 apollo          -    -     -    -     -    -     -    -      0   1
 beos            1    1     1    1     1    1     1    1      1   1
 Configure     256    1   256    1   264    1   264    1    270   1
 cygwin32       24    5    24    5    24    5    24    5     24   5
 djgpp          14    5    14    5    14    5    14    5     15   5
 eg             86   65    86   65    86   65    86   65     86  65
 emacs         262    2   262    2   262    2   262    2    274   2
 h2pl           12   12    12   12    12   12    12   12     12  12
 hints         157   74   157   74   159   74   160   74    179  77
 mint            -    -     -    -     -    -     -    -      4   7
 mpeix           -    -     -    -     5    3     5    3      5   3
 os2           129   44   139   44   142   44   143   44    148  44
 plan9          82   15    82   15    82   15    82   15     82  15
 Porting       241    9   253    9   259   10   264   12    272  13
 qnx             1    2     1    2     1    2     1    2      1   2
 utils         160    9   160    9   160    9   160    9    164   9
 vms           570   34   572   34   573   34   575   34    583  34
 vos             -    -     -    -     -    -     -   -     156  10
 win32         577   41   585   41   585   41   587   41    600  42
 x2p           281   19   281   19   281   19   281   19    281  19

 ======================================================================

                  5.6.0      5.6.1      5.6.2      5.7.3

 apollo          8    3     8    3     8    3     8    3
 beos            5    2     5    2     5    2     6    4
 Configure     346    1   361    1   363    1   394    1
 Cross           -    -     -    -     -    -     4    2
 djgpp          19    6    19    6    19    6    21    7
 eg            112   71   112   71   112   71     -    -
 emacs         303    4   319    4   319    4   319    4
 epoc           29    8    35    8    35    8    36    8
 h2pl           24   15    24   15    24   15    24   15
 hints         242   83   250   84   321   89   272   87
 mint           11    9    11    9    11    9    11    9
 mpeix           9    4     9    4     9    4     9    4
 NetWare         -    -     -    -     -    -   423   57
 os2           214   59   224   60   224   60   357   66
 plan9          92   17    92   17    92   17    85   15
 Porting       361   15   390   16   390   16   425   21
 qnx             5    3     5    3     5    3     5    3
 utils         228   12   221   11   222   11   267   13
 uts             -    -     -    -     -    -    12    3
 vmesa          25    4    25    4    25    4    25    4
 vms           686   38   627   38   627   38   649   36
 vos           227   12   249   15   248   15   281   17
 win32         755   41   782   42   801   42  1006   50
 x2p           307   20   307   20   307   20   345   20

 ======================================================================

                  5.8.0      5.8.1      5.8.2      5.8.3      5.8.4

 apollo          8    3     8    3     8    3     8    3     8    3
 beos            6    4     6    4     6    4     6    4     6    4
 Configure     472    1   493    1   493    1   493    1   494    1
 Cross           4    2    45   10    45   10    45   10    45   10
 djgpp          21    7    21    7    21    7    21    7    21    7
 emacs         319    4   329    4   329    4   329    4   329    4
 epoc           33    8    33    8    33    8    33    8    33    8
 h2pl           24   15    24   15    24   15    24   15    24   15
 hints         294   88   321   89   321   89   321   89   348   91
 mint           11    9    11    9    11    9    11    9    11    9
 mpeix          24    5    25    5    25    5    25    5    25    5
 NetWare       488   61   490   61   490   61   490   61   488   61
 os2           361   66   445   67   450   67   488   67   488   67
 plan9          85   15   325   17   325   17   325   17   321   17
 Porting       479   22   537   32   538   32   539   32   538   33
 qnx             5    3     5    3     5    3     5    3     5    3
 utils         275   15   258   16   258   16   263   19   263   19
 uts            12    3    12    3    12    3    12    3    12    3
 vmesa          25    4    25    4    25    4    25    4    25    4
 vms           648   36   654   36   654   36   656   36   656   36
 vos           330   20   335   20   335   20   335   20   335   20
 win32        1062   49  1125   49  1127   49  1126   49  1181   56
 x2p           347   20   348   20   348   20   348   20   348   20

 ======================================================================

                  5.8.5      5.8.6      5.8.7      5.8.8      5.8.9

 apollo          8    3     8    3     8    3     8    3     8    3
 beos            6    4     6    4     8    4     8    4     8    4
 Configure     494    1   494    1   495    1   506    1   520    1
 Cross          45   10    45   10    45   10    45   10    46   10
 djgpp          21    7    21    7    21    7    21    7    21    7
 emacs         329    4   329    4   329    4   329    4   406    4
 epoc           33    8    33    8    33    8    34    8    35    8
 h2pl           24   15    24   15    24   15    24   15    24   15
 hints         350   91   352   91   355   94   360   94   387   99
 mint           11    9    11    9    11    9    11    9    11    9
 mpeix          25    5    25    5    25    5    49    6    49    6
 NetWare       488   61   488   61   488   61   490   61   491   61
 os2           488   67   488   67   488   67   488   67   552   70
 plan9         321   17   321   17   321   17   322   17   324   17
 Porting       538   34   548   35   549   35   564   37   625   41
 qnx             5    3     5    3     5    3     5    3     5    3
 utils         265   19   265   19   266   19   267   19   281   21
 uts            12    3    12    3    12    3    12    3    12    3
 vmesa          25    4    25    4    25    4    25    4    25    4
 vms           657   36   658   36   662   36   664   36   716   35
 vos           335   20   335   20   335   20   336   21   345   22
 win32        1183   56  1190   56  1199   56  1219   56  1484   68
 x2p           349   20   349   20   349   20   349   19   350   19

 ======================================================================

                  5.9.0      5.9.1      5.9.2      5.9.3      5.9.4

 apollo          8    3     8    3     8    3     8    3     8    3
 beos            6    4     6    4     8    4     8    4     8    4
 Configure     493    1   493    1   495    1   508    1   512    1
 Cross          45   10    45   10    45   10    45   10    46   10
 djgpp          21    7    21    7    21    7    21    7    21    7
 emacs         329    4   329    4   329    4   329    4   329    4
 epoc           33    8    33    8    33    8    34    8    34    8
 h2pl           24   15    24   15    24   15    24   15    24   15
 hints         321   89   346   91   355   94   359   94   366   96
 mad             -    -     -    -     -    -     -    -   174    6
 mint           11    9    11    9    11    9    11    9    11    9
 mpeix          25    5    25    5    25    5    49    6    49    6
 NetWare       489   61   487   61   487   61   489   61   489   61
 os2           444   67   488   67   488   67   488   67   488   67
 plan9         325   17   321   17   321   17   322   17   323   17
 Porting       537   32   536   33   549   36   564   38   576   38
 qnx             5    3     5    3     5    3     5    3     5    3
 symbian         -    -     -    -     -    -   293   53   293   53
 utils         258   16   263   19   268   20   273   23   275   24
 uts            12    3    12    3    12    3    12    3    12    3
 vmesa          25    4    25    4    25    4    25    4    25    4
 vms           660   36   547   33   553   33   661   33   696   33
 vos            11    7    11    7    11    7    11    7    11    7
 win32        1120   49  1124   51  1191   56  1209   56  1719   90
 x2p           348   20   348   20   349   20   349   19   349   19

 ======================================================================

                  5.9.5     5.10.0     5.10.1     5.12.0     5.12.1

 apollo          8    3     8    3     0    3     0    3     0    3
 beos            8    4     8    4     4    4     4    4     4    4
 Configure     518    1   518    1   533    1   536    1   536    1
 Cross         122   15   122   15   119   15   118   15   118   15
 djgpp          21    7    21    7    17    7    17    7    17    7
 emacs         329    4   406    4   402    4   402    4   402    4
 epoc           34    8    35    8    31    8    31    8    31    8
 h2pl           24   15    24   15    12   15    12   15    12   15
 hints         377   98   381   98   385  100   368   97   368   97
 mad           182    8   182    8   174    8   174    8   174    8
 mint           11    9    11    9     3    9     -    -     -    -
 mpeix          49    6    49    6    45    6    45    6    45    6
 NetWare       489   61   489   61   465   61   466   61   466   61
 os2           552   70   552   70   507   70   507   70   507   70
 plan9         324   17   324   17   316   17   316   17   316   17
 Porting       627   40   632   40   933   53   749   54   749   54
 qnx             5    3     5    4     1    4     1    4     1    4
 symbian       300   54   300   54   290   54   288   54   288   54
 utils         260   26   264   27   268   27   269   27   269   27
 uts            12    3    12    3     8    3     8    3     8    3
 vmesa          25    4    25    4    21    4    21    4    21    4
 vms           690   32   722   32   693   30   645   18   645   18
 vos            19    8    19    8    16    8    16    8    16    8
 win32        1482   68  1485   68  1497   70  1841   73  1841   73
 x2p           349   19   349   19   345   19   345   19   345   19

 ======================================================================

                 5.12.2     5.12.3      5.14.0     5.16.0       5.18.0

 apollo          0    3     0    3      -    -     -    -      -     -
 beos            4    4     4    4      5    4     5    4      -     -
 Configure     536    1   536    1    539    1   547    1    550     1
 Cross         118   15   118   15    118   15   118   15    118    15
 djgpp          17    7    17    7     18    7    18    7     18     7
 emacs         402    4   402    4      -    -     -    -      -     -
 epoc           31    8    31    8     32    8    30    8      -     -
 h2pl           12   15    12   15     15   15    15   15     13    15
 hints         368   97   368   97    370   96   371   96    354    91
 mad           174    8   174    8    176    8   176    8    174     8
 mpeix          45    6    45    6     46    6    46    6      -     -
 NetWare       466   61   466   61    473   61   472   61    469    61
 os2           507   70   507   70    518   70   519   70    510    70
 plan9         316   17   316   17    319   17   319   17    318    17
 Porting       750   54   750   54    855   60  1093   69   1149    70
 qnx             1    4     1    4      2    4     2    4      1     4
 symbian       288   54   288   54    292   54   292   54    290    54
 utils         269   27   269   27    249   29   245   30    246    31
 uts             8    3     8    3      9    3     9    3      -     -
 vmesa          21    4    21    4     22    4    22    4      -     -
 vms           646   18   644   18    639   17   571   15    564    15
 vos            16    8    16    8     17    8     9    7      8     7
 win32        1841   73  1841   73   1833   72  1655   67   1157    62
 x2p           345   19   345   19    346   19   345   19    344    20

 ======================================================================

                  5.20.0           5.22.0          5.24.0

 Configure    552      1       570      1      586      1
 Cross        118     15       118     15      118     15
 djgpp         18      7        17      7       17      7
 h2pl          13     15        13     15       13     15
 hints        355     90       356     87      362     87
 mad          174      8         -      -        -      -
 NetWare      467     61       466     61      467     61
 os2          510     70       510     70      510     70
 plan9        316     17       317     17      314     17
 Porting     1204     68      1393     71     1321     71
 qnx            1      4         1      4        1      4
 symbian      290     54       291     54      292     54
 utils        241     27       242     27      679     53
 vms          538     12       532     12      524     12
 vos            8      7         8      7        8      7
 win32       1183     64      1201     64     1268     65
 x2p          341     19         -      -        -      -

 ======================================================================

                  5.26.0           5.28.0           5.30.0

 Configure    593      1       580      1       587      1
 Cross        122     15       125     15       126     15
 djgpp         21      7        21      7        21      7
 h2pl          24     15        24     15        24     15
 hints        376     87       364     85       372     86
 mad            -      -         -      -         -      -
 NetWare      499     61       493     61       493     61
 os2          552     70       552     70       552     70
 plan9        322     17       309     17       308     17
 Porting     1380     73      1462     75      1460     74
 qnx            5      4         5      4         5      4
 symbian      315     54       315     54       315     54
 utils        578     50       584     50       587     50
 vms          527     12       526     12       526     12
 vos           12      7        12      7        12      7
 win32       1313     65      1326     65      1331     65
 x2p            -      -         -      -         -      -

                   5.32.0

 Configure:    588      1
 Cross    :    126     15
 djgpp    :     21      7
 h2pl     :     24     15
 hints    :    363     86
 NetWare  :    484     61
 os2      :    552     70
 plan9    :    308     17
 Porting  :   1482     75
 qnx      :      5      4
 symbian  :    307     54
 utils    :    583     52
 vms      :    527     12
 vos      :     12      7
 win32    :   1011     47

=head2 SELECTED PATCH SIZES

The "diff lines kB" means that for example the patch 5.003_08, to be
applied on top of the 5.003_07 (or whatever was before the 5.003_08)
added lines for 110 kilobytes, it removed lines for 19 kilobytes, and
changed lines for 424 kilobytes.  Just the lines themselves are
counted, not their context.  The "+ - !" become from the diff(1)
context diff output format.

 Pump-  Release         Date              diff lines kB
 king                                     -------------
                                          +     -     !
 ======================================================================

 Chip     5.003_08      1996-Nov-19     110    19   424
          5.003_09      1996-Nov-26      38     9   248
          5.003_10      1996-Nov-29      29     2    27
          5.003_11      1996-Dec-06      73    12   165
          5.003_12      1996-Dec-19     275     6   436
          5.003_13      1996-Dec-20      95     1    56
          5.003_14      1996-Dec-23      23     7   333
          5.003_15      1996-Dec-23       0     0     1
          5.003_16      1996-Dec-24      12     3    50
          5.003_17      1996-Dec-27      19     1    14
          5.003_18      1996-Dec-31      21     1    32
          5.003_19      1997-Jan-04      80     3    85
          5.003_20      1997-Jan-07      18     1   146
          5.003_21      1997-Jan-15      38    10   221
          5.003_22      1997-Jan-16       4     0    18
          5.003_23      1997-Jan-25      71    15   119
          5.003_24      1997-Jan-29     426     1    20
          5.003_25      1997-Feb-04      21     8   169
          5.003_26      1997-Feb-10      16     1    15
          5.003_27      1997-Feb-18      32    10    38
          5.003_28      1997-Feb-21      58     4    66
          5.003_90      1997-Feb-25      22     2    34
          5.003_91      1997-Mar-01      37     1    39
          5.003_92      1997-Mar-06      16     3    69
          5.003_93      1997-Mar-10      12     3    15
          5.003_94      1997-Mar-22     407     7   200
          5.003_95      1997-Mar-25      41     1    37
          5.003_96      1997-Apr-01     283     5   261
          5.003_97      1997-Apr-03      13     2    34
          5.003_97a     1997-Apr-05      57     1    27
          5.003_97b     1997-Apr-08      14     1    20
          5.003_97c     1997-Apr-10      20     1    16
          5.003_97d     1997-Apr-13       8     0    16
          5.003_97e     1997-Apr-15      15     4    46
          5.003_97f     1997-Apr-17       7     1    33
          5.003_97g     1997-Apr-18       6     1    42
          5.003_97h     1997-Apr-24      23     3    68
          5.003_97i     1997-Apr-25      23     1    31
          5.003_97j     1997-Apr-28      36     1    49
          5.003_98      1997-Apr-30     171    12   539
          5.003_99      1997-May-01       6     0     7
          5.003_99a     1997-May-09      36     2    61
          p54rc1        1997-May-12       8     1    11
          p54rc2        1997-May-14       6     0    40

        5.004           1997-May-15       4     0     4

 Tim      5.004_01      1997-Jun-13     222    14    57
          5.004_02      1997-Aug-07     112    16   119
          5.004_03      1997-Sep-05     109     0    17
          5.004_04      1997-Oct-15      66     8   173

=head3 The patch-free era

In more modern times, named releases don't come as often, and as progress
can be followed (nearly) instantly (with rsync, and since late 2008, git)
patches between versions are no longer provided. However, that doesn't
keep us from calculating how large a patch could have been. Which is
shown in the table below. Unless noted otherwise, the size mentioned is
the patch to bring version x.y.z to x.y.z+1.

 Sarathy  5.6.1         2001-Apr-08     531    44   651
 Rafael   5.6.2         2003-Nov-15      20    11  1819

 Jarkko   5.8.0         2002-Jul-18    1205    31   471   From 5.7.3

          5.8.1         2003-Sep-25     243   102  6162
 Nicholas 5.8.2         2003-Nov-05      10    50   788
          5.8.3         2004-Jan-14      31    13   360
          5.8.4         2004-Apr-21      33     8   299
          5.8.5         2004-Jul-19      11    19   255
          5.8.6         2004-Nov-27      35     3   192
          5.8.7         2005-May-30      75    34   778
          5.8.8         2006-Jan-31     131    42  1251
          5.8.9         2008-Dec-14     340   132 12988

 Hugo     5.9.0         2003-Oct-27     281   168  7132   From 5.8.0
 Rafael   5.9.1         2004-Mar-16      57   250  2107
          5.9.2         2005-Apr-01     720    57   858
          5.9.3         2006-Jan-28    1124   102  1906
          5.9.4         2006-Aug-15     896    60   862
          5.9.5         2007-Jul-07    1149   128  1062

          5.10.0        2007-Dec-18      50    31 13111   From 5.9.5


=head1 THE KEEPERS OF THE RECORDS

Jarkko Hietaniemi <F<jhi@iki.fi>>.

Thanks to the collective memory of the Perlfolk.  In addition to the
Keepers of the Pumpkin also Alan Champion, Mark Dominus,
Andreas KE<0xf6>nig, John Macdonald, Matthias Neeracher, Jeff Okamoto,
Michael Peppler, Randal Schwartz, and Paul D. Smith sent corrections
and additions. Abigail added file and patch size data for the 5.6.0 - 5.10
era.

=cut
