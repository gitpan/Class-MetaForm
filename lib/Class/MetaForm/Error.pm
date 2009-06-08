package Class::MetaForm::Error;

use Moose;

use aliased 'Class::MetaForm::Exception::Invalid';
use aliased 'Class::MetaForm::Exception::Required';
use Moose::Error::Default;

use namespace::autoclean;

sub new {
  my $class = shift;

  my %args = @_;

  my $e;

  my $message = $args{message};

  if ($message =~ /^Attribute \((.*?)\) is required/) {
    $args{ field_name } = $class->_resolve_field_label ($1,$args{ metaclass });

    $e = Required->new (%args);
  } elsif ($message =~ /^Attribute \((.*?)\) does not pass the type constraint/) {
    $args{ field_name } = $class->_resolve_field_label ($1,$args{ metaclass });

    $e = Invalid->new (%args);
  } else {
    $e = Moose::Error::Default->new (%args);
  }

  return $e;
}

sub _resolve_field_label {
  my ($class,$field,$meta) = @_;

  my $attribute = $meta->get_attribute ($field) or return $field;

  if ($attribute->does ('MooseX::MetaDescription::Meta::Trait')) {
    if (my $label = $attribute->description->{ label }) {
      return $label;
    }
  }

  return $field;
}


1;

