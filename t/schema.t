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

# check definitions and there types
my %expected = (
    NewDancer => {type => 'object'},
#    Dancers => {type => 'array'},
    Error => {type => ''},
    Dancer => {type => ''},
);

while (my ($def_name, $spec) = each %expected) {
    ok(exists $defs->{$def_name}, qq{Test if definition "$def_name" exists}) or next;
    ok($defs->{$def_name}->type eq $spec->{type}, "Test type for definition '$def_name'");
}

done_testing;
