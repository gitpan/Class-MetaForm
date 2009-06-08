package Class::MetaForm::Exception::Required;

use Moose;

use namespace::autoclean;

extends qw/Class::MetaForm::Exception/;

sub simple_message {
  my ($self) = @_;

  return $self->field_name . " is required";
}
1;

