#!perl

if ( eval 'use Test::More; 1' ) {
    if ( eval 'use YAML qw( LoadFile ); 1' ) {
        plan( tests => 1 );
        ok( LoadFile("META.yml") );
    }
    else {
        plan( skip_all => "YAML required to test META.yml's syntax" );
    }
}
elsif ( eval 'use Test; 1' ) {
    plan( tests => 1 );
    skip( 1, 1 );
}
