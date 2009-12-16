#!perl -w
use Test::More tests => 20;
use lib 't/lib';
use Test::IsEscapes qw( isq );
use Term::HiliteDiff ();

my $d = Term::HiliteDiff->new;
is_deeply( $d->hilite_diff( [qw[ xxx xxx xxx ]] ),['xxx','xxx','xxx'], '[xxx xxx xxx]' );
is_deeply( $d->hilite_diff( [qw[ xxx xxx AAA ]] ),['xxx','xxx',"\e[7mAAA\e[0m"], '[xxx xxx AAA]' );
is_deeply( $d->hilite_diff( [qw[ xxx BBB xxx ]] ),['xxx',"\e[7mBBB\e[0m","\e[7mxxx\e[0m"], '[xxx BBB xxx]' );
is_deeply( $d->hilite_diff( [qw[ CCC xxx xxx ]] ),["\e[7mCCC\e[0m","\e[7mxxx\e[0m",'xxx'], '[CCC xxx xxx]' );

$d = Term::HiliteDiff->new;
is_deeply( $d->watch( [qw[ xxx xxx xxx ]] ),['xxx','xxx','xxx'], '[xxx xxx xxx]' );
is_deeply( $d->watch( [qw[ xxx xxx AAA ]] ),['xxx','xxx',"\e[7mAAA\e[0m"], '[xxx xxx AAA]' );
is_deeply( $d->watch( [qw[ xxx BBB xxx ]] ),['xxx',"\e[7mBBB\e[0m","\e[7mxxx\e[0m"], '[xxx BBB xxx]' );
is_deeply( $d->watch( [qw[ CCC xxx xxx ]] ),["\e[7mCCC\e[0m","\e[7mxxx\e[0m",'xxx'], '[CCC xxx xxx]' );

$d = Term::HiliteDiff->new;
isq( $d->hilite_diff( "xxx\txxx\txxx" ),
     "xxx\txxx\txxx",
     "xxx\\txxx\\txxx" );
isq( $d->hilite_diff( "xxx\txxx\tAAA" ),
     "xxx\txxx\t\e[7mAAA\e[0m",
     "xxx\\txxx\\tAAA" );
isq( $d->hilite_diff( "xxx\tBBB\txxx" ),
     "xxx\t\e[7mBBB\e[0m\t\e[7mxxx\e[0m",
     "xxx\\tBBB\\txxx" );
isq( $d->hilite_diff( "CCC\txxx\txxx" ),
     "\e[7mCCC\e[0m\t\e[7mxxx\e[0m\txxx",
     "CCC\\txxx\\txxx" );

$d = Term::HiliteDiff->new;
isq( $d->hilite_diff( "xxx|xxx|xxx" ),
     "xxx|xxx|xxx",
     "xxx|xxx|xxx" );
isq( $d->hilite_diff( "xxx|xxx|AAA" ),
     "xxx|xxx|\e[7mAAA\e[0m",
     "xxx|xxx|AAA" );
isq( $d->hilite_diff( "xxx|BBB|xxx" ),
     "xxx|\e[7mBBB\e[0m|\e[7mxxx\e[0m",
     "xxx|BBB|xxx" );
isq( $d->hilite_diff( "CCC|xxx|xxx" ),
     "\e[7mCCC\e[0m|\e[7mxxx\e[0m|xxx",
     "CCC|xxx|xxx" );

$d = Term::HiliteDiff->new;
isq( $d->hilite_diff( "xxx\nxxx\nxxx" ),
     "xxx\e[K\nxxx\e[K\nxxx\e[K",
     "xxx\e[K\\nxxx\e[K\\nxxx" );
isq( $d->hilite_diff( "xxx\nxxx\\nAAA" ),
     "xxx\e[K\nxxx\e[K\n\e[7mAAA\e[0m\e[K",
     "xxx\\nxxx\\nAAA" );
isq( $d->hilite_diff( "xxx\nBBB\nxxx" ),
     "xxx\e[K\n\e[7mBBB\e[0m\e[K\n\e[7mxxx\e[0m\e[K",
     "xxx\\nBBB\\nxxx" );
isq( $d->hilite_diff( "CCC\nxxx\nxxx" ),
     "\e[7mCCC\e[0m\e[K\n\e[7mxxx\e[0m\e[K\nxxx\e[K",
     "CCC\\nxxx\\nxxx" );

# TODO: test that embedded \n are not colored over

# TODO: handle \n at the end of the last entry
