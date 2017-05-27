use strict;
use warnings;

use Test::More;
use Test::Warnings;

use Plack::Test;
use HTTP::Request::Common;

BEGIN {
    $ENV{DANCER_CONFDIR} = 't';
    $ENV{DANCER_ENVIRONMENT} = 'routes';
}

{
    package TestApp;
    use Dancer2;
    use Dancer2::Plugin::OpenAPI;

    openapi_operation addDancer => sub {
        my $plugin = shift;
        my $params = params('body');

        # check input and return HTTP code 422 in case of errors
        $plugin->app->log('debug', 'Operation: addDancer, Params:', $params);
    };

    openapi_operation listDancers => sub {
    };

    openapi_operation showDancerById => sub {
        my $plugin = shift;

        $plugin->app->log(debug => 'showDancerById');

        status 205;
    };
}

my $app = Dancer2->runner->psgi_app;

my $test = Plack::Test->create($app);
my $url = 'http://localhost';

{
    my $req = POST "$url/dancers", [id => 'salsa', name => 'S. Alsa', tag => 'latin'];
    my $res = $test->request( $req );
    is $res->code, 200, "Trying to create dancer";

    $req = GET "$url/dancers";
    $res = $test->request( $req );
    is $res->code, 200, "Trying to retrieve dancers from GET $url/dancers";

    # request for a specific dancer
    $req = GET "$url/dancers/salsa_pula";
    $res = $test->request( $req );
    is $res->code, 205, "Trying to retrieve Salsa dancer from GET $url/dancers/salsa_pula";
}

done_testing;
