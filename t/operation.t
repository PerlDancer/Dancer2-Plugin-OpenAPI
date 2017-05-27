# tests for OpenAPI::Operation class

use strict;
use warnings;

use Test::More;
use Test::Warnings;

use OpenAPI::Operation;

# create object
my $op = OpenAPI::Operation->new( operation_id => 'fooBar' , method => 'get', url => '/operation' );
isa_ok($op, 'OpenAPI::Operation');

done_testing;
