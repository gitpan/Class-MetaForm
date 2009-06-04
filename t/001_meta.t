use Test::More;
use Test::Moose;

use strict;
use warnings;

plan tests => 1;

{
  package Foo;

  use Class::MetaForm;
}

meta_ok ('Foo');

