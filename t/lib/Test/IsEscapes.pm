package Test::IsEscapes;
use strict;
use vars qw( @EXPORT_OK );

use Exporter ();
*import = \ &Exporter::import;

@EXPORT_OK = qw( isq );

sub isq ($$;$) {
    my $got      = $_[0];
    my $expected = $_[1];
    my $name     = $_[2];

    for ( $got, $expected ) {
        s/\n/\\cJ/g;
        s/\e/\\e/g;
    }

    &main::is( $got, $expected, $name );
}

1;
