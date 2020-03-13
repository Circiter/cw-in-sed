#!/bin/sed -Enf

y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/

s/^/\n/

:encode
    # Add a lookup table.
    # First, add alphabetical characters.
    s/$/\na.-b-...c-.-.d-..e.f..-.g--.h....i..j.---k-.-l.-..m--n-.o---p.--./
    s/$/q--.-r.-.s...t-u..-v...-w.--x-..-y-.--z--../
    # Then digits.
    s/$/0-----1.----2..---3...--4....-5.....6-....7--...8---..9----/
    # And finally, add punctuation.
    s/$/,--..--?..--..:--...;-.-.-.@.--.-.=-...-+.-.-.!---.".-..-.$...-..-/
    s/$/'.----.\/-..-.(-.--.)-.--.-[-.--.]-.--.-_..--.-/

    # Process the . and - and space specially.
    s/\n\.(.*\n)/.-.-.- \n\1/
    s/\n-(.*\n)/-....- \n\1/
    s/\n (.*\n)/ \n\1/
    # Search and substitute.
    s/\n([^\n])([^\n]*)\n.*\1([-. ]*)/\3 \n\2\n/
    s/\n[^\n]*$// # Remove the non-consumed part of the lookup table.

    /^[^\n]*\n./bencode

s/\n//

# Pattern space: Morse message (dashes, dots, spaces).

# Widen all the whitespaces between words.
s/  />/g; s/>/   /g

# Add a whitespaces after each symbol.
:space s/([^>])([^>])/\1>\2/; tspace
s/>/  /g
# Replace each dash by several dots.
s/-/.../g

:play_message
    /^ /{x; s/^.*$/------------/; x}
    # Adjust the shape to choose another pitch:
    /^\./{x; s/^.*$/~~~~~~------/; x}

    G
    x; y/-/\n/; x # Adjust the DC level.
    s/$/\n100011/ # Signal duration (samples count in binary).

    # Pattern space: message\nwaveform\nduration
    s/^[^\n]*\n/&>/ # Insert a marker.

    :period
        x; p; x
        :sample
            s/>([^\n])/\1>/

            :d s/0(_*)$/_\1/; td
            s/1(_*)$/0\1/
            s/_/1/g
            s/\n0([01]+)$/\n\1/
            /\n0$/ bnext
            />\n/!bsample
        s/\>//; s/^[^\n]*\n/&>/
        bperiod
    :next
    s/^([^\n]*)\n.*$/\1/ # Remove all but the message.

    s/^[^\n]//
    /./ bplay_message
