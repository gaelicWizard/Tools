#!/bin/bash

function cleanUpIPFW
{
    ipfw delete 01000
}

trap cleanUpIPFW HUP INT QUIT KILL TSTP

# Enable NAT
sysctl -w net.inet.ip.forwarding=1

# Setup firewall rules to divert _some_ traffic to NATd
 #.Mac
ipfw add 01000 divert natd tcp from me to idisk.mac.com http via en0
ipfw add 01000 divert natd tcp from idisk.mac.com https to me via en0
  #BUG: blindly redirects all incoming https, which is not desired

 #MobileMe
ipfw add 01000 divert natd tcp from me to idisk.me.com http via en0
ipfw add 01000 divert natd tcp from idisk.me.com https to me via en0
  #BUG: blindly redirects all incoming https, which is not desired

# Start NAT
natd -verbose -interface en0 -dynamic -reverse -same_ports \
    -redirect_port tcp idisk.mac.com:https idisk.mac.com:http \
    -redirect_port tcp idisk.me.com:https idisk.me.com:http \
#    -redirect_port tcp idisk.mac.com:http idisk.mac.com:https \
#    -redirect_port tcp idisk.me.com:http idisk.me.com:https
# Random incoming https does _not_ need to be redirected; only known incoming https needs to return to http


# I'd like to remove the en0 entirely, but natd _must_ have either an interface or an address, which in turn makes ipfw on anything other than en0 broken.
