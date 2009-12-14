#!perl -w
use Test::More tests => 10;
use lib 't/lib';
use Test::IsEscapes qw( isq );
use Term::HiliteDiff qw( hilite_diff );

isq( hilite_diff( 'xxx
xxx
xxx
' ), "xxx
xxx
xxx
" );

isq( hilite_diff( 'xxx
xxx
xxX
' ), "xxx
xxx
xx\e[7mX\e[0m
" );

isq( hilite_diff( 'xxx
xxx
xXx
' ), "xxx
xxx
x\e[7mX\e[0mx
" );

isq( hilite_diff( 'xxx
xxx
Xxx
' ), "xxx
xxx
\e[7mX\e[0mxx
" );

isq( hilite_diff( 'xxx
xxX
xxx
' ), "xxx
xx\e[7mX\e[0m
xxx
" );

isq( hilite_diff( 'xxx
xXx
xxx
' ), "xxx
x\e[7mX\e[0mx
xxx
" );

isq( hilite_diff( 'xxx
Xxx
xxx
' ), "xxx
\e[7mX\e[0mxx
xxx
" );

isq( hilite_diff( 'xxX
xxx
xxx
' ), "xx\e[7mX\e[0m
xxx
xxx
" );

isq( hilite_diff( 'xXx
xxx
xxx
' ), "x\e[7mX\e[0mx
xxx
xxx
" );

isq( hilite_diff( 'Xxx
xxx
xxx
' ), "\e[7mX\e[0mxx
xxx
xxx
" );
