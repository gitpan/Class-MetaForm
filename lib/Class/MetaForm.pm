package Class::MetaForm;

use Moose ();

use Moose::Exporter;
use Moose::Util::MetaRole;
use Moose::Util::TypeConstraints qw/coerce from via/;

use namespace::autoclean;

our $VERSION = '0.01_01';

Moose::Exporter->setup_import_methods;

sub init_meta {
  my ($self,%args) = @_;

  my $for_class = $args{ for_class };

  Moose->init_meta (%args);

  $for_class->meta->error_class ('Class::MetaForm::Error');

  Moose::Util::MetaRole::apply_metaclass_roles (
    for_class                 => $for_class,
    attribute_metaclass_roles => [ 'MooseX::MetaDescription::Meta::Trait' ],
  ); 

  Moose::Util::MetaRole::apply_base_class_roles(
    for_class => $for_class,
    roles     => [ 'Class::MetaForm::Filter' ],
  );

  coerce $for_class
    => from HashRef
      => via { $for_class->new ($_) };
  
  return $for_class->meta;
}

1;

__END__

=pod

=head1 NAME

Class::MetaForm - Gluing forms onto Moose

=head1 WARNING

This is a development version, treat it as such

=head1 SYNOPSIS

  package My::ContactForm;

  use Moose;
  use Class::MetaForm;

  has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has age => (
    is        => 'ro',
    isa       => 'Int',
    predicate => 'has_age',
  );

  has email => (
    is       => 'ro',
    isa      => 'EmailType',
    required => 1,
  );

# In a controller far, far away

my $form = My::ContactForm->new ($c->req->params);

# By the way, see Catalyst::Controller::MetaForm for more sugaring
# when using MetaForm with Catalyst.

=head1 DESCRIPTION

There are quite a few web form validation modules on CPAN. Some are
okay, most usually requires more effort using than what manual form
validation would require. For some time now, I've wanted to write a
form validator since I have yet to find one that I can really like.
As I just stated, most form validators requirse too much effort to use
and some want to run the entire show, trying to force your application
to be structured in a certain way. So my goals for a new validators
were to keep it simple and nonintrusive.

So how does it actually work? L<Class::MetaForm> is in itself just
a sugar module for setting up some roles and traits in your class. It
really doesn't do a whole lot:

=head2 Filtering

Empty strings are removed from the arguments. This is because when a
field is present in a form, an empty string is used to indicate that
the field has not been filled in by the user, and hence would be
equivalent to not providing the parameter in Moose.

It also converts an argument like:

  'foo.bar' => 42

Into:

  foo => { bar => 42 }

=head2 Exceptions

Moose errors are difficult to understand; For a computer program
at least. Moose itself should be throwing real exception objects. But
it doesn't so we install some sugar that tries it best to parse the
error messages that Moose spits out.

=head2 Hashref coercion

So you can take adventage of the above hash filtering to have
multiple form objects as children of the current one.

  package My::AddressForm;

  use Moose;
  use Class::MetaForm;

  has name => (
    is  => 'ro',
    isa => 'Str',
  );

  has zipcode => (
    is  => 'ro',
    isa => 'Str',
  );

  package My::RegisterForm;

  use Moose;
  use Class::MetaForm;

  has billing => (
    is       => 'ro',
    isa      => 'My::AddressForm',
    required => 1,
  );

Accepting the form parameters billing.name and billing.zipcode,
accessible as

  $form->billing->name

=head2 MooseX::MetaDescription

The trait provided by L<MooseX::MetaDescription> is added to your
attribute metaclass so you can provide additional descriptive
information in them. Most notably, the exception objects thrown will
use it to make the error message more human readable.

  has mysillyattributename => (
    is => 'ro',
    isa => 'Str',
    description => { label => 'mylesssillyname' },
  );

=head1 SEE ALSO

=over 4

=item L<HTML::FormFu>

=item L<HTML::FormHandler>

=item L<Moose>

=back

=head1 BUGS

Most software has bugs. This module probably isn't an exception. 
If you find a bug please either email me, or add the bug to cpan-RT.

=head1 AUTHOR

Anders Nor Berle E<lt>berle@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Modula AS

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut

