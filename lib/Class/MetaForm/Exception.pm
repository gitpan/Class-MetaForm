package Class::MetaForm::Exception;

use overload '""' => sub { shift->stringify };

use Moose;

use namespace::autoclean;

has field_name => (
  is       => 'rw',
  isa      => 'Str',
  required => 1,
);

has message => (
  is       => 'rw',
  isa      => 'Str',
  required => 1,
);

sub stringify {
  my ($self) = @_;

  return $self->message;
}

sub simple_message {
  my ($self) = @_;

  return "An unknown error occured";
}

1;

