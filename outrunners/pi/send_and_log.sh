#!/bin/bash
# send_and_log.sh IMAGE.bin.gz LIVE_ADDR [WAIT]: copy the image to the Pi as /boot/roms/h-outrunners_naomi.bin.gz,
# netboot it, wait WAIT s (default 30: BIOS ~13 s + assets 7.5 s), print the console ring (outrunners_live.py log).
# Never kill a peek half way (pkill/timeout on a peek leaves the DIMM busy); never `pkill -f` a pattern that is in
# this command line (it kills the ssh's own shell, exit 255).
. "$(dirname "$0")/pi_env.sh"
"$(dirname "$0")/dimm_wait.sh" || exit 1
pi_scp "$1" "$PI:/boot/roms/h-outrunners_naomi.bin.gz"
pi_ssh "md5sum /boot/roms/h-outrunners_naomi.bin.gz; cd /sbin/piforce && timeout 110 python3 -u dc2naomi_send.py $DIMM /boot/roms/h-outrunners_naomi.bin.gz > /tmp/send.log 2>&1; echo send rc=\$?; sleep ${3:-30}; timeout 45 python3 -u outrunners_live.py $DIMM $2 log 2>&1 | tail -40"
