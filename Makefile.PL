#!perl -w
use 5.005;
use strict;
use ExtUtils::MakeMaker;
BEGIN {
    # Provides "make testcover" if you have
    # ExtUtils::MakeMaker::Coverage installed
    eval {
	require ExtUtils::MakeMaker::Coverage;
	ExtUtils::MakeMaker::Coverage->import;
	1;
    };
}

WriteMakefile1(
    MIN_PERL_VERSION => '5.005',
    META_MERGE => {
        resources => {
            repository => 'http://github.com/jbenjore/Term-HiliteDiff',
        },
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    NAME          => 'Term::HiliteDiff',
    AUTHOR        => 'Josh ben Jore <jjore@cpan.org>',
    VERSION_FROM  => 'lib/Term/HiliteDiff.pm',
    ABSTRACT_FROM => 'lib/Term/HiliteDiff.pod',
    PREREQ_PM     => {
        # Runtime
        strict            => 0,
        vars              => 0,
        Exporter          => 0,
    },
    LICENSE => 'perl',
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Term-HiliteDiff-*' },
);

sub WriteMakefile1 {  #Written by Alexandr Ciornii, version 0.21. Added by eumm-upgrade.
    my %params = @_;
    my $eumm_version = $ExtUtils::MakeMaker::VERSION;
    $eumm_version = eval $eumm_version;
    die "EXTRA_META is deprecated" if exists $params{EXTRA_META};
    die "License not specified" if ! exists $params{LICENSE};
    if ( $params{BUILD_REQUIRES} && $eumm_version < 6.5503 ) {
        #EUMM 6.5502 has problems with BUILD_REQUIRES
        $params{PREREQ_PM} = {
            %{$params{PREREQ_PM}},
            %{$params{BUILD_REQUIRES}},
        };
        delete $params{BUILD_REQUIRES};
    }
    delete $params{CONFIGURE_REQUIRES} if $eumm_version < 6.52;
    delete $params{MIN_PERL_VERSION} if $eumm_version < 6.48;
    delete $params{META_MERGE} if $eumm_version < 6.46;
    delete $params{META_ADD} if $eumm_version < 6.46;
    delete $params{LICENSE} if $eumm_version < 6.31;
    delete $params{AUTHOR} if $] < 5.005;
    delete $params{ABSTRACT_FROM} if $] < 5.005;
    delete $params{BINARY_LOCATION} if $] < 5.005;

    WriteMakefile(%params);
}

