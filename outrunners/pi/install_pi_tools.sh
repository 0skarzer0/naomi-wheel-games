#!/bin/bash
# install_pi_tools.sh: copy the Pi-side tools to /sbin/piforce (outrunners_live.py, or_watch.py, or_profile.py,
# or_info.py). live.py, watch.py and profile.py are ports/naomi/'s of the port (naomi-port.patch): pass their folder.
. "$(dirname "$0")/pi_env.sh"
SRC=${1:?usage: install_pi_tools.sh PATH/TO/ports/naomi}
pi_scp "$SRC/live.py" "$PI:/sbin/piforce/outrunners_live.py"
pi_scp "$SRC/watch.py" "$PI:/sbin/piforce/or_watch.py"
pi_scp "$SRC/profile.py" "$PI:/sbin/piforce/or_profile.py"
pi_scp "$(dirname "$0")/or_info.py" "$PI:/sbin/piforce/or_info.py"
