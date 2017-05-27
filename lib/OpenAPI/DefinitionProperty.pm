package OpenAPI::DefinitionProperty;

use strict;
use warnings;

use Moo;
use Types::Standard qw/ArrayRef Str/;

has name => (
    is => 'ro',
    isa => Str,
    required => 1,
);

has type => (
    is => 'ro',
    isa => Str,
    required => 1,
);

has format => (
    is => 'ro',
    isa => Str,
);

1;

