#!perl

if ( eval 'use Test::More; 1' ) {
    if ( eval 'use Test::Signature; 1' ) {
        plan( tests => 1 );
        signature_ok();
    }
    else {
        plan( skip_all => "Test::Signature wasn't installed" );
    }
}
elsif ( eval 'use Test; 1' ) {
    plan( tests => 1 );
    skip( 1, 1 );
}
