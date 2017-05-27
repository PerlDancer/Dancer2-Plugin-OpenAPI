#! /usr/bin/env perl

use 5.006;
use strict;
use warnings;
use Test::More;
use File::Spec;
use OpenAPI::Schema;;

my $schema = OpenAPI::Schema->new(
    source => File::Spec->catfile('t', 'openapi-sample.json')
);

isa_ok($schema, 'OpenAPI::Schema');

# test number of definitions
my $defs = $schema->definitions;
my $defs_ct = scalar(keys(%$defs));
my $expected = 3;

ok ($defs_ct == $expected, 'Number of definitions')
    || diag "Number of definitions is $defs_ct instead of $expected.";

done_testing;
