package Class::MetaForm::Filter;

use Moose::Role;

use namespace::autoclean;

around BUILDARGS => sub {
  my ($next,$self,@args) = @_;

  my $params = $self->$next (@args);

  return $self->_form_filter ($params);
};

sub _form_filter {
  my ($self,$params) = @_;
 
  my $new_params = {};

  foreach my $key (keys %$params) {
    my $value = $params->{ $key };

    next unless defined $value && $value ne '';

    my @subkeys = split /\./,$key;

    $self->_assign_deeply ($new_params,$value,@subkeys);
  }

  return $new_params;
};

sub _assign_deeply {
  my ($self,$hash,$value,@subkeys) = @_;

  my $subkey = shift @subkeys;

  if (scalar @subkeys > 0) {
    my $subhash = $hash->{ $subkey } ||= {};

    $self->_assign_deeply ($subhash,$value,@subkeys);
  } else {
    $hash->{ $subkey } = $value;
  }

  return;
}

1;

