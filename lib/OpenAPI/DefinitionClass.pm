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

sub validate {
    my ($self, $vref) = @_;
    my %errors;

    for my $req (@{$self->{required}}) {
        unless (exists $vref->{$req} && defined $vref->{$req} && $vref->{$req} =~ /\S/) {
            $errors{$req} = 'Value missing for required property';
        }
    }

    if (keys %errors) {
        return undef, \%errors;
    }

    return 1;
}

1;

