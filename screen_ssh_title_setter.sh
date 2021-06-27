#!/bin/bash
# Fixed up some linuxism by John Pell <john+screen@gaelicWizard.net>
# Changes released as Public Domain.
# Accept hostname twice to ensure proper function with OpenSSH 4.x

# screen_ssh.sh by Chris Jones <cmsj@tenshu.net>
# Released under the GPL v2 licence.
# Set the title of the current screen to the hostname being ssh'd to
#
# usage: screen_ssh.sh $PPID hostname hostname.domain
#
# This is intended to be called by ssh(1) as a LocalCommand.
# For example, put this in ~/.ssh/config:
#
# Host *
#   LocalCommand /path/to/screen_ssh.sh $PPID %n %h

# If it's not working and you want to know why, set DEBUG to 1 and check the
# logfile.
DEBUG=0
DEBUGLOG="$HOME/.ssh/screen_ssh.log"

set -e
set -u

dbg ()
{
  if [ "$DEBUG" -gt 0 ]; then
    echo "$(date) :: $*" >>$DEBUGLOG
  fi
}

dbg "$0 $*"

# We only care if we are in a terminal
tty -s

# We also only care if we are in screen, which we infer by $TERM starting
# with "screen"
if [ ! "$STY" ] && [ "${TERM:0:6}" != "screen" ]
then
  dbg "Not a screen session, STY not set and '${TERM:0:6}' != 'screen'."
  exit
fi

# We must be given three arguments - our parent process and a hostname twice
# (the first hostname may be "%n" if we are being called by an older SSH)
if [ $# != "3" ]; then
  dbg "Not given enough arguments (must have PPID and hostname twice)."
  exit
fi

# We don't want to do anything if BatchMode is on, since it means
# we're not an interactive shell
if ps -axo pid,command | grep "^[[:space:]]*$1[[:space:]]" | grep -a -i "Batchmode yes" >/dev/null 2>&1
then
  dbg "SSH is being used in Batch mode, exiting because this is probably an auto-complete or similar."
  exit
fi

# Infer which version of SSH called us, and use an appropriate method
# to find the hostname
if [ "$2" = "%n" ]; then
  HOST="$3"
  dbg "Using OpenSSH 4.x full hostname specification: $HOST."
else
  HOST="$2"
  dbg "Using OpenSSH 5.x hostname specification: $HOST."
fi

echo $HOST | sed -e 's/\.[^.]*\.[^.]*\(\.uk\)\{0,1\}$//' | awk '{ printf ("\033k%s\033\\", $NF) }'

dbg "Done."
