package Parse::CPAN::Authors;
use strict;
use Mail::Address;
use Parse::CPAN::Authors::Author;
use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors(qw( mailrc data ));
use vars qw($VERSION);
$VERSION = '2.20';

sub new {
  my $class = shift;
  my $filename = shift;
  my $self = {};
  bless $self, $class;

  $filename = '01mailrc.txt' if not defined $filename;

  if ($filename =~ /^alias /) {
    $self->mailrc($filename);
  } else {
    open(IN, $filename) || die "Failed to read $filename: $!";
    $self->mailrc(join '', <IN>);
    close(IN);
  }

  $self->parse;

  return $self;
}

sub parse {
  my $self = shift;
  my $data;

  foreach my $line (split "\n", $self->mailrc) {
    my($alias, $pauseid, $long) = split ' ', $line, 3;
    $long =~ s/^"//;
    $long =~ s/"$//;
    my $addr = (Mail::Address->parse($long))[0];
    my $name = $addr->phrase;
    my $email = $addr->address;

    my $a = Parse::CPAN::Authors::Author->new;
    $a->pauseid($pauseid);
    $a->name($name);
    $a->email($email);
    $data->{$pauseid} = $a;
  }
  $self->data($data);
}

sub author {
  my($self, $pauseid) = @_;
  return $self->data->{$pauseid};
}

sub authors {
  my($self) = @_;
  return values %{$self->data};
}

1;

__END__

=head1 NAME

Parse::CPAN::Authorss - Parse 01mailrc.txt.gz

=head1 SYNOPSIS

  use Parse::CPAN::Authors;

  # must have downloaded and un-gzip-ed
  my $p = Parse::CPAN::Authors->new("01mailrc.txt");
  # either a filename as above or pass in the contents of the file
  my $p = Parse::CPAN::Authors->new($mailrc_contents);

  my $a = $p->author('AASSAD');
  # $a is a Parse::CPAN::Authors::Author object
  print $a->pauseid, "\n"; # AASSAD
  print $a->name, "\n";    # Arnaud 'Arhuman' Assad
  print $a->email, "\n";   # arhuman@hotmail.com

  # all the author objects
  my @authors = $p->authors;

=head1 DESCRIPTION

The Comprehensive Perl Archive Network (CPAN) is a very useful
collection of Perl code. It has several indices of the files that it
hosts, including a file named "01mailrc.txt.gz" in the "authors"
directory. This file contains lots of useful information on CPAN
authors and this module provides a simple interface to the data
contained within.

Note that this module does not concern itself with downloading or
unpacking this file. You should do this yourself.

The constructor takes either the path to the 01mailrc.txt file or its
contains. It defaults to loading the file from the current
directory. You must download and un-gzip it yourself.

In a future release L<Parse::CPAN::Authors::Author> might have more
information.

=head1 AUTHOR

Leon Brocard <acme@astray.com>

=head1 COPYRIGHT

Copyright (C) 2004, Leon Brocard

This module is free software; you can redistribute it or modify it under
the same terms as Perl itself.
