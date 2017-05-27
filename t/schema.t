#! /usr/bin/env perl

use 5.006;
use strict;
use warnings;
use Test::More;
use Test::Warnings;
use File::Spec;
use OpenAPI::Schema;
use Data::Dumper;

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

# test validation
my $new_dancer = $defs->{'NewDancer'};
my ($res, $errors) = $new_dancer->validate({});

ok(! $res, "Test whether validation fails");

if (ok(exists $errors->{name}, q{Test whether error for field "name" exists})) {
    ok($errors->{name} eq 'Value missing for required property', q{Test error message for field "name"})
        || diag "Error message: $errors->{name}";
}

($res, $errors) = $new_dancer->validate( { name => 'Salsa' } );

ok ($res, "Test whether validation succeeds.")
    || diag "Errors:" . Dumper($errors);

done_testing;
