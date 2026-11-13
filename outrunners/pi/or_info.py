#!/usr/bin/env python3
"""or_info.py [DIMM_IP]: on the Pi, whether the NetDIMM answers (and the size of the game it holds)."""
import sys
sys.path.append('/sbin/piforce/dm_netboot')
from netdimm import NetDimm
print('DIMM ok', NetDimm(sys.argv[1] if len(sys.argv) > 1 else '10.0.0.4').info().current_game_size)
