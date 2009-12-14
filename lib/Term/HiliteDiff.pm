package Term::HiliteDiff;

use strict;
use vars qw( $VERSION @EXPORT_OK %EXPORT_TAGS $DEFAULTOBJ );
use Term::HiliteDiff::_impl ();

$VERSION = '0.04';

use Exporter ();
*import      = \&Exporter::import;
@EXPORT_OK   = qw( watch hilite_diff );
%EXPORT_TAGS = ( all => \@EXPORT_OK );

# Auto-export everything to main if I've been called as a -e program.
if ( $0 eq '-e' ) {

    package main;
    Term::HiliteDiff->import(':all');
}

# Here are some convenience functions for pretending this module isn't
# object oriented.
$DEFAULTOBJ = __PACKAGE__->new;

sub hilite_diff {
    return $DEFAULTOBJ->hilite_diff(@_);
}

sub watch {
    return $DEFAULTOBJ->watch(@_);
}

# Hey, a class constructor.
sub new {
    my ( $class ) = @_;

    return bless [], "${class}::_impl";
}

# Blatantly copied this from errantstory.com
q[What's the point of dreaming I'm a girl if I don't get a cool lesbian scene?!];

