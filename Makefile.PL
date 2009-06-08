use inc::Module::Install;
  
name           'Class-MetaForm';
all_from       'lib/Class/MetaForm.pm';

requires       'aliased'                 => 0;
requires       'Class::MOP'              => '0.84';
requires       'Moose'                   => '0.79';
requires       'MooseX::MetaDescription' => '0.03';
requires       'namespace::autoclean'    => 0;

test_requires  'Test::More'              => '0.42';

WriteAll;

