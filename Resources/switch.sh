#!/bin/sh

#  switch.sh
#  TunlrSwitchr
#
#  Created by Lewis Pollard on 22/08/2012.
#  Copyright (c) 2012 Lewis Pollard. All rights reserved

# Set bash delimeter to be line break
IFS=$'\n'

# Get adapter list
adapters=`networksetup -listallnetworkservices |grep -v denotes`

for adapter in $adapters
do
echo updating dns for $adapter
dnssvr=(`networksetup -getdnsservers $adapter`)

if [ $dnssvr != '184.82.222.5' ]; then
# set dns server to the vpn dns server
networksetup -setdnsservers $adapter 184.82.222.5 199.167.30.144
else
# revert back to DHCP assigned DNS Servers
networksetup -setdnsservers $adapter empty
fi
done