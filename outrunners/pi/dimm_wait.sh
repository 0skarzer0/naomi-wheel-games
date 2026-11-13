#!/bin/bash
# dimm_wait.sh: wait until the NetDIMM answers info() (an unanswered peek keeps it busy up to a minute)
. "$(dirname "$0")/pi_env.sh"
for i in $(seq 1 12); do
	r=$(timeout 50 bash -c "$(declare -f pi_ssh); ASK=$ASK PI=$PI pi_ssh 'timeout 15 python3 -u /sbin/piforce/or_info.py $DIMM 2>&1 | tail -1'")
	case "$r" in *"DIMM ok"*) echo "$r"; exit 0;; esac
	sleep 10
done
echo "the NetDIMM does not answer"; exit 1
