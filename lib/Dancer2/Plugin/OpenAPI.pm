package Dancer2::Plugin::OpenAPI;

use 5.006;
use strict;
use warnings;

use JSON::Validator::OpenAPI;
use Dancer2::Plugin;

=head1 NAME

Dancer2::Plugin::OpenAPI - OpenAPI plugin for Dancer2

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

In your Dancer application:

    use Dancer2::Plugin::OpenAPI;

=cut

#
# config attributes
#

has schema => (
    is => 'ro',
    required => 1,
    from_config => 1,
);

#
# other attributes
#

has _validator => (
    is => 'ro',
    default => sub { JSON::Validator::OpenAPI->new },
);

#
# BUILD method
#

sub BUILD {
    my $plugin = shift;
    my $app = $plugin->app;

    my $api_spec = $plugin->_validator->_load_schema($plugin->schema);
    my $paths = $api_spec->get('/paths');

    while (my ($url, $method_spec) = each %$paths) {
        # adjust URLs like "/dancers/{dancerId}"
        $url =~ s|/\{(.*?)\}|/%$1|g;

        while (my ($method, $spec) = each %{$method_spec}) {
            $app->add_route(
                method => $method,
                regexp => qr($url),
                code => sub {
                    my $app = shift;
                    $app->log(debug => "Hit route $url, method $method.");
                    $app->response->status(200);
               },
            );
        }
    }
}

=head1 AUTHOR

Stefan Hornburg (Racke), C<< <racke at linuxia.de> >>


=head1 LICENSE AND COPYRIGHT

Copyright 2017 Stefan Hornburg (Racke).

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of Dancer2::Plugin::OpenAPI
