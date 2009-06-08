package Class::MetaForm::Exception::Invalid;

use Moose;

use namespace::autoclean;

extends qw/Class::MetaForm::Exception/;

has reason => (
  is      => 'rw',
  isa     => 'Str',
  lazy    => 1,
  builder => '_build_reason',
);

sub _build_reason {
  my ($self) = @_;

  my ($reason) = $self->message =~ /because: (.*?)$/;

  return $reason;
}

sub simple_message {
  my ($self) = @_;

  return $self->field_name . " is invalid: " . $self->reason;
}

1;

