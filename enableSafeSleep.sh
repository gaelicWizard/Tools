#!/bin/sh

PATH=/bin:/sbin:/usr/bin:/usr/sbin;

sudo -v

sudo nvram nvramrc='" /" select-dev
" msh" encode-string " has-safe-sleep" property
unselect
';
sudo nvram "use-nvramrc?"=true;

# THIS DICHOTOMY IS NO LONGER NEEDED
if sysctl vm.swapusage | grep -q 'encrypted'; then
  sudo pmset -a hibernatemode 7;
else
  sudo pmset -a hibernatemode 3;
fi

echo "You must restart your computer to finish enabling SafeSleep."

# This script was submitted to MacOSXHints.com by 'TrumpetPower!' (Ben Goren)
