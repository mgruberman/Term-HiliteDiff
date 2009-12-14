#!perl -w
use Test::More tests => 4;
use lib 't/lib';
use Test::IsEscapes qw( isq );
use Term::HiliteDiff qw( hilite_diff );

$, = "\t";

isq( hilite_diff( [qw[ xx xx xx ]] ),"xx\txx\txx" );
isq( hilite_diff( [qw[ xx xx XX ]] ),"xx\txx\t\e[7mXX\e[0m" );
isq( hilite_diff( [qw[ xx XX xx ]] ),"xx\t\e[7mXX\e[0m\txx" );
isq( hilite_diff( [qw[ XX xx xx ]] ),"\e[7mXX\e[0m\txx\txx" );
