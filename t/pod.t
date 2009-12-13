#!perl -T

if ( eval 'use Test::More; 1' ) {
    if ( eval 'use Test::Pod 1.14; 1' ) {
        all_pod_files_ok();
    }
    else {
        plan( skip_all => "Test::Pod 1.14 required for testing POD" );
    }
}
elsif ( eval 'use Test; 1' ) {
    plan( tests => 1 );
    skip( 1, 1 );
}
