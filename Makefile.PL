use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Term::HiliteDiff',
    AUTHOR        => 'Joshua ben Jore <twists@gmail.com>',
    VERSION_FROM  => 'lib/Term/HiliteDiff.pm',
    ABSTRACT_FROM => 'lib/Term/HiliteDiff.pod',
    PL_FILES      => {},
    PREREQ_PM     => {
        strict            => 0,
        vars              => 0,
        Exporter          => 0,
        'Algorithm::Diff' => 0,
        Test              => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Term-HiliteDiff-*' },
);
