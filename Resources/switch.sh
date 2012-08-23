#!/bin/sh

#  switch.sh
#  TunlrSwitchr
#
#  Created by Lewis Pollard on 22/08/2012.
#  Copyright (c) 2012 Lewis Pollard. All rights reserved
# Takes 3 parameters, DNS1, DNS2 and whether this is the first run of the script for this session
IFS=$'\n'
adapters=`networksetup -listallnetworkservices |grep -v denotes`
dns1=$1
dns2=$2
firstRun=$3
echo $dns1
echo $dns2
echo $firstRun

for adapter in $adapters
do
	dnssvr=(`networksetup -getdnsservers $adapter`)
	if [[ ($dnssvr != $dns1) || ($firstRun != 0) ]]; then
		networksetup -setdnsservers $adapter $dns1 $dns2
	else
		networksetup -setdnsservers $adapter empty
	fi
done