use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Dancer2::Plugin::OpenAPI',
    AUTHOR           => q{Stefan Hornburg (Racke) <racke@linuxia.de>},
    VERSION_FROM     => 'lib/Dancer2/Plugin/OpenAPI.pm',
    ABSTRACT_FROM    => 'lib/Dancer2/Plugin/OpenAPI.pm',
    LICENSE          => 'artistic_2',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'HTTP::Request::Common' => 0,
        'Plack::Test' => 0,
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Dancer2' => '0',
        'JSON::Validator' => '0',
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Dancer2-Plugin-OpenAPI-*' },
);
