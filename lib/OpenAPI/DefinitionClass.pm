package OpenAPI::DefinitionClass;

use strict;
use warnings;

use Moo;
use Types::Standard qw/ArrayRef HashRef Str/;
use JSON::Schema::AsType;

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

=head2 json_schema

JSON schema as hash reference, used for validation of input
with L<JSON::Schema::AsType>.

=cut

has json_schema => (
    is => 'lazy',
    isa => HashRef,
);

sub _build_json_schema {
    my $self = shift;
    my %prop_schema;
    my %props_as_hash;

    # turn properties into a hash
    for my $prop (@{$self->properties}) {
        $props_as_hash{ $prop->name } = {
            type => $prop->type,
            format => $prop->format,
        };
    }

    return {
        properties => \%props_as_hash,
        required => $self->required,
    };
}

sub validate {
    my ($self, $vref) = @_;
    my %errors;

    my $json_schema = JSON::Schema::AsType->new(
        schema => $self->json_schema,,
        draft_version => 4,
    );

    if ( my $msg_array = $json_schema->validate_explain ( $vref )) {
        if ( @$msg_array >= 3 ) {
            my $reason = $msg_array->[1];

            if ($reason =~ /did not pass type constraint "Required\[(\w+)\]/) {
                $errors{$1} = 'Value missing for required property';
                return undef, \%errors;
            }
        }

        return 0, $msg_array->[1];
    }
    else {
        return 1;
    }
}

1;

