"""Drop "Mic Boost" from PipeWire's analog-input-mic volume merge.

The ACP mixer path declares `volume = merge` on both "Capture" and "Mic
Boost", stacking the two hardware gain stages into a single slider. On the
Framework 16 that means a source volume of 100% applies Capture's +30 dB on
top of Mic Boost's +30 dB, and the internal mic is pure static well before
the slider reaches the top.

`volume = off` means "always set it to the lowest value possible" (see
analog-output.conf.common), and Mic Boost's lowest value is 0 dB -- so this
pins the boost off and caps the merged range at Capture's +30 dB. It mirrors
what upstream's analog-input-internal-mic.conf already does for this element.

The asserts are the point: a pipewire bump that reworks the file should fail
the build loudly rather than silently produce an unpatched copy.
"""

import sys

REPLACEMENTS = [
    (
        """[Element Mic Boost]
required-any = any
switch = select
volume = merge
override-map.1 = all
override-map.2 = all-left,all-right

[Option Mic Boost:on]
name = input-boost-on

[Option Mic Boost:off]
name = input-boost-off
""",
        """[Element Mic Boost]
switch = off
volume = off
""",
    ),
    # Some AC'97 codecs spell it differently; absent on this machine, but the
    # stanza is in the same file and there is no reason to leave it merging.
    (
        """[Element Mic Boost (+20dB)]
switch = select
volume = merge

[Option Mic Boost (+20dB):on]
name = input-boost-on

[Option Mic Boost (+20dB):off]
name = input-boost-off
""",
        """[Element Mic Boost (+20dB)]
switch = off
volume = off
""",
    ),
]


def main(path):
    conf = open(path).read()
    for old, new in REPLACEMENTS:
        found = conf.count(old)
        assert found == 1, f"expected 1 match, found {found}, for:\n{old}"
        conf = conf.replace(old, new)
    open(path, "w").write(conf)


if __name__ == "__main__":
    main(sys.argv[1])
