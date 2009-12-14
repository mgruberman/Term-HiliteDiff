package Term::HiliteDiff::_impl;
use strict;
use Algorithm::Diff ();
use Carp ();

use constant _prev_tokens         => 0;
use constant _do_positioning => 1;
use constant _line_count     => 2;

# This library uses the following ANSI escape codes
# \e[s   Save a cursor position
# \e[u   Go back to the saved cursor position
# \e[K   Erase everything from the cursor to the end of the line
# \e[7m  Turns on 'reverse' hilite
# \e[0m  Turns off all formatting

sub hilite_diff {
    my ( $self, @args ) = @_;

    local $self->[_do_positioning] = 0;

    return $self->_do_watch( @args );
}

sub watch {
    my ( $self, @args ) = @_;
    local $self->[_do_positioning] = 1;

    return $self->_do_watch( @args );
}

sub _do_watch {
    my $self = shift @_;

    # I'm mimicing print(...) so it makes sense to join things
    # with $,. That's usually undef so I'm turning off the
    # uninitialized warning. If there are no parameters, I read
    # from $_ instead.
    my $separator =
        defined $,
        ? $,
        : '';

    # This is the stream of data I'll be using to compare against for
    # differences. Either the user provided pre-parsed data or I'm
    # going to just compare each character.
    my ( @tokens, $string );
    if ( eval { @tokens = @{ $_[0] }; 1 } ) {

        # Allow accepting a reference to an array of pre-parsed
        # tokens.
        $string = join $separator, @tokens;
    }
    else {

        $string = join $separator, @_;
        @tokens = split //, $string;
    }

    # *if* I haven't started a diff already, then I start one and
    # finish early.
    if ( ! $self->[_prev_tokens] ) {

        # \e[s instructs the terminal to save the cursor
        # position. I'll use this later with \e[u to restore the
        # position back to here and then write over whatever it was
        # that I just wrote.
        if ( $self->[_do_positioning] ) {
            $string = "\e[s$string";

	    # For an unknown reason, ensure there's a newline
	    if ( $string !~ /\n/ ) {
		$string .= "\n";
	    }
        }

        # Make notes for the next run on what I just printed and how
        # many lines there are. I'll need to know how many lines there
        # are so I can make sure to clear them all and not leave
        # trailing bits around.
        $self->[_prev_tokens] = \@tokens;
        if ( $self->[_do_positioning] ) {
            $self->[_line_count] = $string =~ tr/\n/\n/;
        }

        # Do something sane if called in void or not-void contexts.
        if ( defined wantarray ) {
            return $string;
        }
        else {
            print $string
                or Carp::carp( "Can't write: $!" );
            return;
        }
    }

    # Find out what changed between the previous call and this
    # one. Once I have the diff, I don't need to keep my copy of the
    # previous stream. I'll just be querying $diff to see what's
    # different or unchanged.
    my $diff = Algorithm::Diff->new( \@tokens, $self->[_prev_tokens] );
    $self->[_prev_tokens] = \@tokens;

    my $out;

    if ( $self->[_do_positioning] ) {

        # \e[u instructs the terminal to restore the cursor position
        # to whatever was last saved with \e[s.
        $out = "\e[u";
    }
    else {
        $out = '';
    }

    # Loop over each hunk in $diff. I'm looking for hunks that are the
    # same or things that appear in the new stream, sequence #1. When
    # I've found differences, I'll mark it up.
    while ( $diff->Next ) {
        my @items;
        if ( @items = $diff->Same ) {
            $out .= join '', splice @items;
        }
        elsif ( @items = $diff->Items(1) ) {

            # \e[7m adds the reverse text mode. \e[0m clears all text
            # attributes.
	    my $new_section = "\e[7m" . join( '', splice @items ) . "\e[0m";

	    # Turn off highlighting when going over a new line
	    $new_section =~ s/\n/\e\[0m\n\e\[7m/g;

	    # Remove empty highlighting
	    $new_section =~ s/\e\[7m\e\[0m//g;

            $out .= $new_section;
        }
    }

    if ( $self->[_do_positioning] ) {
	# Just before every \n, add an instruction \e[K to delete anything
	# else remaining on that line. Remember, I'm writing over an area
	# on the screen that already has data in it. I want to clean
	# things up so only what I'm printing now is visible.
        $out =~ s/\n/\e[K\n/g;

	# Kill the remainder of the last line if we're ending in a
	# newline.
	$out =~ s/\n\z/\n\e[K/;
    }

    # Count the # of lines that aren't in this output that were in the
    # previous output. I'll need to clear those out.
    if ( $self->[_do_positioning] ) {
        my $this_line_count = $out =~ tr/\n//;
        my $slack_line_count = $self->[_line_count] - $this_line_count;
        $self->[_line_count] = $this_line_count;

        if ( $slack_line_count > 0 ) {

            # Add $slack_line_count number of blank lines with
            # instructions to clear things out. I'm wondering slightly
            # if it isn't wrong to do \n before \e[K. \e[K instructs
            # the terminal to delete everything else on a line after
            # the current position. \n instructs the terminal to move
            # the cursor to the beginning of the next line.
            #
            # I'm not sure why I have 1+ here. I must have needed but the
            # logic doesn't sound right.
	    ++ $slack_line_count;
            $out .= "\n\e[K" x $slack_line_count;
        }
    }

    # Do something sane if called in void or not-void contexts.
    if ( defined wantarray ) {
        return $out;
    }
    else {
        print $out
            or Carp::carp( "Couldn't write to the currently selected filehandle: $!" );
    }
}

# Blatantly copied this from errantstory.com
q[Wow, you're pretty uptight for a guy who worships a multi-armed, hermaphrodite embodiment of destruction who has a fetish for vaguely phallic shaped headgear.];
