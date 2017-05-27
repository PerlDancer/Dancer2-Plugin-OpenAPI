package OpenAPI::Path;

use strict;
use warnings;

use Moo;
use Types::Standard qw/HashRef Str/;

has url => (
    is => 'ro',
    isa => Str,
    required => 1,
);

has operations => (
    is => 'rwp',
    isa => HashRef,
    default => sub { {} },
);

1;
