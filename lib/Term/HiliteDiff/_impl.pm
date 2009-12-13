package Term::HiliteDiff::_impl;
use strict;
use Algorithm::Diff ();
use Carp 'carp';

use constant TOKENS => 0;
use constant LINES  => 1;

# This library uses the following ANSI escape codes
# \e[s   Save a cursor position
# \e[u   Go back to the saved cursor position
# \e[K   Erase everything from the cursor to the end of the line
# \e[7m  Turns on 'reverse' hilite
# \e[0m  Turns off all formatting

sub hilite_diff {
    my $self = shift @_;

    # Call the normal watch() function but remove some escape
    # sequences.
    local $_ = $self->watch(@_);
    $_ = '' unless defined;

    # Remove \e[s and \e[u. These functions save and restore the
    # cursor position.
    s/\e\[[us]//g;

    # Remove the \e[K I added at the end of every line. This isn't
    # strictly necessary.
    s/(?:\n\e\[K)+\z//g;

    # Do something sane if called void or not-void contexts.
    if ( defined wantarray ) {
        return $_;
    }
    else {
        print
            or carp "Couldn't write to the currently selected filehandle: $!";
    }
}

sub watch {
    my $self = shift @_;

    # This is the stream of data I'll be using to compare against for
    # differences.
    my ( @tokens, $string );
    if ( eval { @tokens = @{ $_[0] }; 1 } ) {

        # Allow accepting a reference to an array of pre-parsed
        # tokens.
        $string = join( defined($,) ? $, : '', @tokens );
    }
    else {

        # I'm mimicing print(...) so it makes sense to join things
        # with $,. That's usually undef so I'm turning off the
        # uninitialized warning. If there are no parameters, I read
        # from $_ instead.
        $string = join( defined($,) ? $, : '', @_ );
        @tokens = $string =~ /(.)/sg;
    }

    # *if* I haven't started a diff already, then I start one and
    # finish early.
    unless ( $self->[TOKENS] ) {

        # \e[s instructs the terminal to save the cursor
        # position. I'll use this later with \e[u to restore the
        # position back to here and then write over whatever it was
        # that I just wrote.
        $string = "\e[s$string\n";

        # Make notes for the next run on what I just printed and how
        # many lines there are. I'll need to know how many lines there
        # are so I can make sure to clear them all and not leave
        # trailing bits around.
        $self->[TOKENS] = \@tokens;
        $self->[LINES] = $string =~ tr/\n/\n/;

        # Do something sane if called in void or not-void contexts.
        if ( defined wantarray ) {
            return $string;
        }
        else {
            print $string
                or carp
                "Couldn't write to the currently selected filehandle: $!";
            return;
        }
    }

    # Find out what changed between the previous call and this
    # one. Once I have the diff, I don't need to keep my copy of the
    # previous stream. I'll just be querying $diff to see what's
    # different or unchanged.
    my $diff = Algorithm::Diff->new( \@tokens, $self->[TOKENS] );
    $self->[TOKENS] = \@tokens;

    # \e[u instructs the terminal to restore the cursor position to
    # whatever was last saved with \e[s.
    my $out = "\e[u";

    # Loop over each hunk in $diff. I'm looking for hunks that are the
    # same or thins that appear in the new stream, sequence #1. When
    # I've found differences, I'll mark it up.
    while ( $diff->Next ) {
        my @items;
        if ( @items = $diff->Same ) {
            $out .= join '', splice @items;
        }
        elsif ( @items = $diff->Items(1) ) {

            # \e[7m adds the reverse text mode. \e[0m clears all text
            # attributes.
            $out .= "\e[7m" . join( '', splice @items ) . "\e[0m";
        }
    }

    # Just before every \n, add an instruction \e[K to delete anything
    # else remaining on that line. Remember, I'm writing over an area
    # on the screen that already has data in it. I want to clean
    # things up so only what I'm printing now is visible.
    $out =~ s/\n/\e[K\n/g;

    # Count the # of lines that aren't in this output that were in the
    # previous output. I'll need to clear those out.
    my $this_lines = $out =~ tr/\n//;
    my $slack_lines = $self->[LINES] - $this_lines;
    if ( $slack_lines > 0 ) {

        # Add $slack_lines # of blank lines with instructions to clear
        # things out. I'm wondering slightly if it isn't wrong to do
        # \n before \e[K. \e[K instructs the terminal to delete
        # everything else on a line after the current position. \n
        # instructs the terminal to move the cursor to the beginning
        # of the next line.
        #
        # I'm not sure why I have 1+ here. I must have needed but the
        # logic doesn't sound right.
        $out .= "\n\e[K" x ( 1 + $slack_lines );
    }
    $self->[LINES] = $this_lines;

    # Do something sane if called in void or not-void contexts.
    if ( defined wantarray ) {
        return $out;
    }
    else {
        print $out
            or carp "Couldn't write to the currently selected filehandle: $!";
    }
}

q[Wow, you're pretty uptight for a guy who worships a multi-armed, hermaphrodite embodiment of destruction who has a fetish for vaguely phallic shaped headgear.];
