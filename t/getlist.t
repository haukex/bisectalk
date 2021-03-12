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

my $data = decode_json( scalar getlist( 'https://github.com/Perl/perl5/raw/5d273ab/pod/perlhist.pod' ) );

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
