#!perl -T

if ( eval 'use Test::More; 1' ) {
    plan( tests => 1 );
    use_ok('Term::HiliteDiff');
    diag("Testing Term::HiliteDiff $Term::HiliteDiff::VERSION, Perl $], $^X");
}
elsif ( eval 'use Test; 1' ) {
    plan( tests => 1 );
    skip( 1, 1 );
}
