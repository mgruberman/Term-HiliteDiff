#!perl -w
use Test::More tests => 4;
use lib 't/lib';
use Test::IsEscapes qw( isq );
use Term::HiliteDiff ();

my $d = Term::HiliteDiff->new;
is_deeply( $d->hilite_diff( [qw[ xxx xxx xxx ]] ),['xxx','xxx','xxx'], '[xxx xxx xxx]' );
is_deeply( $d->hilite_diff( [qw[ xxx xxx AAA ]] ),['xxx','xxx',"\e[7mAAA\e[0m"], '[xxx xxx AAA]' );
is_deeply( $d->hilite_diff( [qw[ xxx BBB xxx ]] ),['xxx',"\e[7mBBB\e[0m","\e[7mxxx\e[0m"], '[xxx BBB xxx]' );
is_deeply( $d->hilite_diff( [qw[ CCC xxx xxx ]] ),["\e[7mCCC\e[0m","\e[7mxxx\e[0m",'xxx'], '[CCC xxx xxx]' );

# TODO: test that embedded \n are not colored over

# TODO: handle \n at the end of the last entry
