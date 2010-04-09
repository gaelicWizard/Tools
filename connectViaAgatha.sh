#!/bin/sh

# This script simplifies my use of a central ssh hub (wannasblog). 
# The goal of this script is to be used as a ProxyCommand for ssh.

HOST="$1"
HUBPORT="$2"

if [ "$HUBPORT" == 0 ]
then
    echo "$HOST: not configured for hub access." >&2

    exit 1
fi

if /sbin/route -q get "$HOST" >/dev/null 2>/dev/null
# if we can reach the host directly
then # just connect to it
    exec connect "$HOST" 22
else # attempt to connect to it via my ssh hub
    exec ssh -q -x -oProxyCommand=none -oForwardAgent=no -oClearAllForwardings=yes -oControlMaster=no -oCompression=no -l pell agatha exec connect localhost "$HUBPORT"
fi

exit -1 # we should never get here...
