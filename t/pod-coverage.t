#!perl -T

if ( eval 'use Test::More; 1' ) {
    if ( eval 'use Test::Pod::Coverage 1.04; 1' ) {
        all_pod_coverage_ok();
    }
    else {
        plan( skip_all =>
                'Test::Pod::Coverage 1.04 required for testing POD coverage'
        );
    }
}
elsif ( eval 'use Test; 1' ) {
    plan( tests => 1 );
    skip( 1, 1 );
}
