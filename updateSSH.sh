#!/bin/sh

#
CONFIGDIR="${HOME}/.ssh"

KNOWN_HOSTS="${CONFIGDIR}/known_hosts"
AUTH_KEYS="${CONFIGDIR}/authorized_keys"

#

# Known hosts
LOCALHOST="localhost,127.0.0.1,::1,`hostname`"
OTHERHOSTS=`cat "${KNOWN_HOSTS}" | grep -v 'localhost' | grep -v '127.0.0.1' | grep -v '::1' | grep -v '###'`

LOCALRSA1=`cat /etc/ssh_host_key.pub`
LOCALRSA=`cat /etc/ssh_host_rsa_key.pub`
LOCALDSA=`cat /etc/ssh_host_dsa_key.pub`

echo "$LOCALHOST $LOCALRSA1" > "${KNOWN_HOSTS}.new"
echo "$LOCALHOST $LOCALRSA" >> "${KNOWN_HOSTS}.new"
echo "$LOCALHOST $LOCALDSA" >> "${KNOWN_HOSTS}.new"
echo '###' >> "${KNOWN_HOSTS}.new"
echo "$OTHERHOSTS" >> "${KNOWN_HOSTS}.new"
#

# Authorized Keys
m=0
while test -e "${HOME}/.ssh/Ti${m}.pub"; do
 cat "${HOME}/.ssh/Ti${m}.pub" >> "${AUTH_KEYS}.new"
 m=$(($m+1))
done
unset m
#

#
mv -f "${KNOWN_HOSTS}" "${KNOWN_HOSTS}.old"
mv -f "${KNOWN_HOSTS}.new" "${KNOWN_HOSTS}"

mv -f "${AUTH_KEYS}"  "${AUTH_KEYS}.old" 
mv -f "${AUTH_KEYS}.new"  "${AUTH_KEYS}"
#
