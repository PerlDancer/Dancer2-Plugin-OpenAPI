package OpenAPI::DefinitionClass;

use strict;
use warnings;

use Moo;
use Types::Standard qw/ArrayRef Str/;

has name => (
    is => 'ro',
    isa => Str,
    required => 1,
);

has required => (
    is => 'ro',
    isa => ArrayRef,
    default => sub { [] },
);

has type => (
    is => 'ro',
    isa => Str,
    default => sub { '' },
);

has properties => (
    is => 'ro',
    isa => ArrayRef,
    required => 1,
);

1;

