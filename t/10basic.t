#!perl -wT
use strict;
use Test::More tests => 1;

BEGIN { diag("Testing Term::HiliteDiff $Term::HiliteDiff::VERSION, Perl $], $^X") }
use Term::HiliteDiff;
ok( 'Loaded Term::HiliteDiff' );
