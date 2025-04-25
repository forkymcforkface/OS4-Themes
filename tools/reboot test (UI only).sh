#!/bin/bash
chmod 777 "$0"

python3 - <<EOF
import sys
sys.path.append('/opt/rgbpi/ui')
import cglobals, rtk, utils
import pygame

utils.bck_dat_files()
rtk.save_cfg_file()
utils.cmd('clear')
utils.cmd('sync')
pygame.quit()
utils.cmd('setterm --clear --cursor off --foreground black --blank 0 > /dev/tty0')
utils.cmd('pkill -f rgbpiui.pyc')
utils.cmd('/opt/rgbpi/autostart.sh > /dev/null 2>&1 &')
EOF

exit 0
