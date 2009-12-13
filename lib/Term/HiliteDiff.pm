package Term::HiliteDiff;

use strict;
use vars qw( $VERSION @EXPORT_OK %EXPORT_TAGS $DEFAULTOBJ );
use Term::HiliteDiff::_impl ();

=head1 NAME

Term::HiliteDiff - Hilites differences in text with ANSI escape codes

=head1 VERSION

Version 0.01

=cut

$VERSION = '0.01';

=head1 DESCRIPTION

=head1 SYNOPSIS

This module hilites differences between lines/records of text. It was
directly inspired by the --difference mode provided by the watch(1)
program on Linux.

    use Term::HiliteDiff 'watch';
    for my $num ( 0 .. 1_000_000 ) {
        print watch( $num ), "\n";
    }

=head1 EXPORT

This module optionally exports C<watch> and C<hilite_diff> under most
circumstances. When perl is invoked as a one-liner with C<-e>, both
C<watch> and C<hilite_diff> are exported to the C<main> package.

=cut

use Exporter ();

*import      = \&Exporter::import;
@EXPORT_OK   = qw( watch hilite_diff );
%EXPORT_TAGS = ( all => \@EXPORT_OK );

# Auto-export everything to main if I've been called as a -e program.
if ( $0 eq '-e' ) {
    no strict 'refs';
    *{"main::$_"} = \&$_ for @EXPORT_OK;
}

=head1 FUNCTIONS

=head2 hilite_diff

 $str = hilite_diff( LIST );
 $str = hilite_diff();
 hilite_diff( LIST );
 hilite_diff();

=cut

sub hilite_diff {
    return $DEFAULTOBJ->hilite_diff(@_);
}

=head2 watch

 $str = watch( LIST );
 $str = watch();
 watch( LIST );
 watch();

=cut

sub watch {
    return $DEFAULTOBJ->watch(@_);
}

=head1 Object oriented

=head2 C<Term::HiliteDiff->new()>

This class method returns a new C<Term::HiliteDiff> object.

=cut

$DEFAULTOBJ = __PACKAGE__->new;

sub new {
    my $class = shift;

    return bless [], "${class}::_impl";
}

=head2 $obj->hilite_diff

=head2 $obj->watch

=head1 AUTHOR

Joshua ben Jore, C<< <twists@gmail.com> >>

=head1 TODO

=over 4

=item Objects

This uses a single process global state for tracking differences. It
should use objects so multiple things can be watched.

=item Pluggable drivers

Pluggable drivers. hilite_diff() is essentially exactly the same as
watch() but it edits the marked up text differently. I'd be good to
offer a unified diff and HTML rendering as well.

It'd also be nice to have an API that would allow decaying changes to
be visible. So a change in one line is somehow visible N lines into
the future.

=item Tests

I totally skipped those. I know how I'm going to generate them, I just
haven't yet.

=back

=head1 BUGS

Please report any bugs or feature requests to
C<bug-term-hilitediff@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Term-HiliteDiff>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2006 Joshua ben Jore, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

# This quote is blatantly copied from Michael Poe of errantstory.com.
"What's the point of dreaming I'm a girl if I don't get a cool lesbian scene?!"
