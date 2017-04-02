#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Dancer2::Plugin::OpenAPI' ) || print "Bail out!\n";
}

diag( "Testing Dancer2::Plugin::OpenAPI $Dancer2::Plugin::OpenAPI::VERSION, Perl $], $^X" );
