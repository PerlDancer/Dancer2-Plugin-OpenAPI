use strict;
use warnings;

use Test::More;
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
}

my $app = Dancer2->runner->psgi_app;

my $test = Plack::Test->create($app);
my $url = 'http://localhost';

{
    my $req = GET "$url/dancers";
    my $res = $test->request( $req );
    is $res->code, 200, "Trying to retrieve dancers from GET $url/dancers";

    # request for a specific dancer
    $req = GET "$url/dancers/salsa_pula";
    $res = $test->request( $req );
    is $res->code, 200, "Trying to retrieve Salsa dancer from GET $url/dancers/salsa_pula";
}

done_testing;
