#!/bin/sh -p

curl -f -s -S http://www.gaelicWizard.net/rc.tar.bz2 | tar xj -C "${HOME}"

"${HOME}/Tools/updateSSH.sh"
