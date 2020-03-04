#!/bin/sed -Enf

y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/

s/^/\n/

:encode
    # Add a lookup table.
    s/$/\na.-b-...c-.-.d-..e.f..-.g--.h....i..j.---k-.-l.-..m--n-.o---p.--.q--.-r.-.s...t-u..-v...-w.--x-..-y-.--z--..0-----1.----2..---3...--4....-5.....6-....7--...8---..9----/

    # TODO: Implement other symbols:
    #. .-.-.-
    #, --..--
    #? ..--..
    #: ---...
    #; -.-.-.
    #@ .--.-.
    #= -...-
    #+ .-.-.
    #- -....-
    #! ---.
    #" .-..-.
    #$ ...-..-
    #' .----.
    #/ -..-.
    #( -.--.
    #) -.--.-
    #[ -.--.
    #] -.--.-
    #_ ..--.-

    s/\n (.*\n)/  \n\1/ # Space is space.
    # Search and substitute.
    s/\n([^\n])([^\n]*)\n.*\1([-.]*)/\3 \n\2\n/
    s/\n[^\n]*$// # Remove the non-consumed part of the lookup table.

    /^[^\n]*\n./bencode

s/\n//

# Pattern space: Morse message (dashes, dots, spaces).

# Add a whitespaces after each symbol.
:space s/([^>])([^>])/\1>\2/; tspace
s/>/  /g
# Replace each dash by several dots.
s/-/.../g

# Append a delay counter.
s/$/\nxxxx/ # Each x approximately doubles the time of playing.
x
s/^/x/
:fill s/^.*$/&&/; x; /[^\n]$/{s/[^\n]$//; x; bfill}
s/\n//;
G
s/\n/\n>/

# Pattern space: message\n>counter.

:play_message
    bsignal
    :return
    s/>//; s/\n/\n>/
    s/^[^\n]//
    /^\n/!bplay_message
q

# FIXME: It plays some quiet background tone
# due to the \x00 characters or, more probably,
# due to the \n printed by p, but without p
# it works somewhat inadequately.
:signal
    /^ /{x; s/^.*$/\x00\x00\x00\x00\x00\x00\n/; x}
    /^\./{x; s/^.*$/\x11\x22\x55zzz\x55\x22\x11/; x} # Try to soften a click/pop sound.
    :delay_signal
        x; p; x
        s/>(.)/\1>/
        />./bdelay_signal
    breturn
