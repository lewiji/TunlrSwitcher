#!/bin/sh

#  switch.sh
#  TunlrSwitchr
#
#  Created by Lewis Pollard on 22/08/2012.
#  Copyright (c) 2012 Lewis Pollard. All rights reserved
#  This file is part of TunlrSwitcher.
#
#  TunlrSwitcher is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  TunlrSwitcher is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
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