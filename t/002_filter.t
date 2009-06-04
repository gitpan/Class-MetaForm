use Test::More;

use strict;
use warnings;

plan tests => 2;

{
  package Foo;

  use Moose;
  use Class::MetaForm;

  has bar => (
    is  => 'ro',
    isa => 'HashRef',
  );

  has baz => (
    is        => 'ro',
    isa       => 'Int',
    predicate => 'has_baz',
  );
}

my $foo = Foo->new (
  'bar.hello' => 'world',
  'baz'       => '',
);

is_deeply ($foo->bar,{ hello => 'world' });

ok (! $foo->has_baz);

