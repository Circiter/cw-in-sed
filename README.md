# cw-in-sed
Generates a Morse-code tones (actual sound, not a dots and dashes on the screen).

Usage variants (only first was tested by me):
- echo Hi | ./cwtx.sed > /dev/dsp
- echo Message | ./cwtx.sed | aplay -r 64000
- echo CW forever | ./cwtx.sed | sox -t raw -r 64k -c 1 -e unsigned -b 8 - -d
