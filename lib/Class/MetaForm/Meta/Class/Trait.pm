package Class::MetaForm::Meta::Class::Trait;

use Moose::Role;

use Data::Dumper;

around get_all_attributes => sub {
  my ($next,$self) = @_;

  return sort { $a->insertion_order <=> $b->insertion_order } $self->$next;
};

1;

