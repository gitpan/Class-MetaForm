use Test::More;

use strict;
use warnings;

plan tests => 2;

{
  package Foo;

  use Moose;
  use Class::MetaForm;

  has bar => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has baz => (
    is        => 'ro',
    isa       => 'Int',
  );
}

eval { Foo->new };

isa_ok ($@,'Class::MetaForm::Exception::Required');

eval { Foo->new (bar => 'hello',baz => 'world') };

isa_ok ($@,'Class::MetaForm::Exception::Invalid'); 

