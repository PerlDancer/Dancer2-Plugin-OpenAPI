package OpenAPI::Operation;

use strict;
use warnings;

use Moo;
use Types::Standard qw/Str CodeRef/;

use namespace::autoclean;

has operation_id => (
    is => 'ro',
    isa => Str,
    required => 1,
);

has method => (
    is => 'ro',
    isa => Str,
    required => 1,
);

has url => (
    is => 'ro',
    isa => Str,
    required => 1,
);

has implementation => (
    is => 'rw',
    isa => CodeRef,
);

1;
