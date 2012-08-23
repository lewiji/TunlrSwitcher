#!/bin/sh

#  switch.sh
#  TunlrSwitchr
#
#  Created by Lewis Pollard on 22/08/2012.
#  Copyright (c) 2012 Lewis Pollard. All rights reserved
IFS=$'\n'
adapters=`networksetup -listallnetworkservices |grep -v denotes`
dns1='184.82.222.5'
dns2='199.167.30.144'
for adapter in $adapters
do
	dnssvr=(`networksetup -getdnsservers $adapter`)
	if [ $dnssvr != $dns1 ]; then
		networksetup -setdnsservers $adapter $dns1 $dns2
	else
		networksetup -setdnsservers $adapter empty
	fi
done