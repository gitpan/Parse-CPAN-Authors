use strict;
use lib 'lib';
use Test::More tests => 6;
use_ok('Parse::CPAN::Authors');
my $p = Parse::CPAN::Authors->new("t/01mailrc.txt");

my $a = $p->author('AASSAD');
is($a->pauseid, "AASSAD");
is($a->name, "Arnaud 'Arhuman' Assad");
is($a->email, 'arhuman@hotmail.com');

is_deeply([sort map { $_->pauseid } $p->authors], [ qw(AADLER AALLAN
AANZLOVAR AAR AARDEN AARONJJ AARONSCA AASSAD ABARCLAY) ]);

open(IN, "t/01mailrc.txt");
my $mailrc = join '', <IN>;
close(IN);

$p = Parse::CPAN::Authors->new("t/01mailrc.txt");

is_deeply([sort map { $_->pauseid } $p->authors], [ qw(AADLER AALLAN
AANZLOVAR AAR AARDEN AARONJJ AARONSCA AASSAD ABARCLAY) ]);
