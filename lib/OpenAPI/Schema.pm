package OpenAPI::Schema;

use strict;
use warnings;

use Moo;
use JSON::Validator::OpenAPI;
use Types::Standard qw/HashRef/;
use OpenAPI::DefinitionClass;
use OpenAPI::DefinitionProperty;
use OpenAPI::Operation;
use OpenAPI::Path;

use namespace::autoclean;

has source => (
    is => 'ro',
    required => 1,
);

has _validator => (
    is => 'ro',
    default => sub { JSON::Validator::OpenAPI->new },
);

has definitions => (
    is => 'rwp',
    isa => HashRef,
    default => sub { {} },
);

has operations => (
    is => 'rwp',
    isa => HashRef,
    default => sub { {} },
);

has paths => (
    is => 'rwp',
    isa => HashRef,
    default => sub { {} },
);

#
# BUILD method
#

sub BUILD {
    my $self = shift;
    my $api_spec = $self->_validator->_load_schema( $self->source );

    # go through definitions
    my $defs = $api_spec->get('/definitions');
    my %def_objects;

    while (my ($name, $spec) = each %$defs) {
        # TODO
        next if exists $spec->{type} and $spec->{type} eq 'array';

        # create properties
        my $props = $spec->{properties};
        my @prop_objects;

        while (my ($prop_name, $prop_def) = each %$props) {
            push @prop_objects,
                OpenAPI::DefinitionProperty->new(
                    name => $prop_name,
                    %$prop_def,
                );
        }

        # create definition class
        my %def_class_params = (
            name => $name,
            properties => \@prop_objects,
            required => $spec->{required},
        );

        if (defined $spec->{type}) {
            $def_class_params{type} = $spec->{type};
        }

        $def_objects{$name} = OpenAPI::DefinitionClass->new(%def_class_params);
    }

    $self->_set_definitions(\%def_objects);

    my $paths = $api_spec->get('/paths');
    my %operations;

    while (my ($url, $method_spec) = each %$paths) {
        # adjust URLs like "/dancers/{dancerId}"
        # $url =~ s|/\{(.*?)\}|/:$1|g;

        while (my ($method, $spec) = each %{$method_spec}) {
            if ($spec->{operationId}) {
                # now register an operation
                my $operation = OpenAPI::Operation->new(
                    operation_id => $spec->{operationId},
                    method => $method,
                    url => $url,
                );

                $operations{$spec->{operationId}} = $operation;
            }
        }
    }

    $self->_set_operations(\%operations);
}

1;
