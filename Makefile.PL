#!perl -w
use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Term::HiliteDiff',
    AUTHOR        => 'Josh ben Jore <jjore@cpan.org>',
    VERSION_FROM  => 'lib/Term/HiliteDiff.pm',
    ABSTRACT_FROM => 'lib/Term/HiliteDiff.pod',
    PL_FILES      => {
        'Maketest.PL' => 'Maketest',
    },
    PREREQ_PM     => {
        # Runtime
        strict            => 0,
        vars              => 0,
        Exporter          => 0,
        'Algorithm::Diff' => 0,

        # Only for testing
        'Test::More' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Term-HiliteDiff-*' },
);
