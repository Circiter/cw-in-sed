# cw-in-sed
Generates a Morse-code tones (actual sound, not a dots and dashes on the screen).

Usage examples (only the first three work correctly on my system):
- echo CW forever | ./cwtx.sed > /dev/dsp
- echo Hi | ./cwtx.sed | aplay -Dplug:default
- echo Message | ./cwtx.sed | sox -t raw -r 8k -c 1 -e unsigned -b 8 - -d
- echo Hi | ./cwtx.sed | aplay -r 64000
- echo Hi | ./cwtx.sed | aplay -r 8000 -c 2
- echo Message | ./cwtx.sed | sox -t raw -r 64k -c 1 -e unsigned -b 8 - -d
