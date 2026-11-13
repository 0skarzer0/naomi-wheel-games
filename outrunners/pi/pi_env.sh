# Sourced by the other scripts: how to reach the Crazy Taxi upright's Raspberry (WiPi) from a shell on the user's
# computer (in a Claude session: device_bash, which reaches the LAN). The password is NOT kept here: ask the user
# and export PI_PASS before sourcing.
PI=${PI:-root@192.168.68.60}
DIMM=${DIMM:-10.0.0.4}            # the NAOMI's NetDIMM as the Pi sees it
: "${PI_PASS:?export PI_PASS (ask the user)}"
ASK=$(mktemp); printf '#!/bin/sh\necho "%s"\n' "$PI_PASS" > "$ASK"; chmod +x "$ASK"
pi_ssh() { env SSH_ASKPASS="$ASK" SSH_ASKPASS_REQUIRE=force DISPLAY=x setsid ssh -o StrictHostKeyChecking=no \
	-o UserKnownHostsFile="$HOME/.pi_known_hosts" -o ConnectTimeout=20 "$PI" "$@" < /dev/null; }
pi_scp() { env SSH_ASKPASS="$ASK" SSH_ASKPASS_REQUIRE=force DISPLAY=x setsid scp -o StrictHostKeyChecking=no \
	-o UserKnownHostsFile="$HOME/.pi_known_hosts" -o ConnectTimeout=20 "$@" < /dev/null; }
