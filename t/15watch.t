#!perl -w
use Test::More tests => 10;
use lib 't/lib';
use Test::IsEscapes qw( isq );
use Term::HiliteDiff qw( watch );

isq( watch( 'xxx
xxx
xxx
' ), "\e[sxxx
xxx
xxx
", 'xxx.xxx.xxx' );

isq( watch( 'xxx
xxx
xxX
' ), "\e[uxxx\e[K
xxx\e[K
xx\e[7mX\e[0m\e[K
\e[K", 'xxx.xxx.xxX' );


isq( watch( 'xxx
xxx
xXx
' ), "\e[uxxx\e[K
xxx\e[K
x\e[7mX\e[0mx\e[K
\e[K", 'xxx.xxx.xXx' );

isq( watch( 'xxx
xxx
Xxx
' ), "\e[uxxx\e[K
xxx\e[K
\e[7mX\e[0mxx\e[K
\e[K", 'xxx.xxx.Xxx' );

isq( watch( 'xxx
xxX
xxx
' ), "\e[uxxx\e[K
xx\e[7mX\e[0m\e[K
xxx\e[K
\e[K", 'xxx.xxX.xxx' );

isq( watch( 'xxx
xXx
xxx
' ), "\e[uxxx\e[K
x\e[7mX\e[0mx\e[K
xxx\e[K
\e[K", 'xxx.xXx.xxx' );

isq( watch( 'xxx
Xxx
xxx
' ), "\e[uxxx\e[K
\e[7mX\e[0mxx\e[K
xxx\e[K
\e[K", 'xxx.Xxx.xxx' );

isq( watch( 'xxX
xxx
xxx
' ), "\e[uxx\e[7mX\e[0m\e[K
xxx\e[K
xxx\e[K
\e[K", 'xxX.xxx.xxx' );

isq( watch( 'xXx
xxx
xxx
' ), "\e[ux\e[7mX\e[0mx\e[K
xxx\e[K
xxx\e[K
\e[K", 'xXx.xxx.xxx' );

isq( watch( 'Xxx
xxx
xxx
' ), "\e[u\e[7mX\e[0mxx\e[K
xxx\e[K
xxx\e[K
\e[K", 'Xxx.xxx.xxx' );
