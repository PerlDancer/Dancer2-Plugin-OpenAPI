#! /usr/bin/env perl

use 5.006;
use strict;
use warnings;
use Test::More;
use File::Spec;
use JSON::Validator::OpenAPI;

my $validator = JSON::Validator::OpenAPI->new;
my $result = $validator->load_and_validate_schema(File::Spec->catfile('t', 'openapi-sample.json'));

isa_ok($result, 'JSON::Validator::OpenAPI');

done_testing;
