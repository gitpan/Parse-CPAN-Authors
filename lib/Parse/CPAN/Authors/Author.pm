package Parse::CPAN::Authors::Author;
use strict;
use base qw( Class::Accessor::Fast );
 __PACKAGE__->mk_accessors(qw( pauseid name email ));
use vars qw($VERSION);
$VERSION = '2.12';

sub new {
  my $class = shift;
  my $self = {};
  bless $self, $class;
  return $self;
}

1;
