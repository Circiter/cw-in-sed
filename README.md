# cw-in-sed
Generates a Morse-code tones (actual sound, not a dots and dashes on the screen).

Usage variants (only the first was tested by me):
- echo CW forever | ./cwtx.sed > /dev/dsp
- echo Hi | ./cwtx.sed | aplay -r 64000 # On my system the aplay do not support 8-bit sound.
- echo Message | ./cwtx.sed | sox -t raw -r 64k -c 1 -e unsigned -b 8 - -d # On my system it plays some garbage.
