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

# You should have received a copy of the GNU General Public License
# along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
# Takes 3 parameters, DNS1, DNS2 and whether this is the first run of the script for this session
IFS=$'\n'
adapters=`networksetup -listallnetworkservices |grep -v denotes | sed "s/^\*//"`
dns1=$1
dns2=$2
firstRun=$3
echo $dns1
echo $dns2
echo $firstRun

for adapter in $adapters
do
  non_tunlr_dns=(`networksetup -getdnsservers $adapter | grep -v 'Please note' | grep -v "There aren't any DNS Servers set" | grep -v $dns1 | grep -v $dns2`)
  has_dns1=(`networksetup -getdnsservers $adapter | grep $dns1`)
  has_dns2=(`networksetup -getdnsservers $adapter | grep $dns2`)

  if [[ (-z $has_dns1) || (-z $has_dns2) || (($firstRun != 0) && (-z $firstRun)) ]]; then
    `networksetup -setdnsservers $adapter $dns1 $dns2 ${non_tunlr_dns[@]}`
  else
    `networksetup -setdnsservers $adapter ${non_tunlr_dns[@]-empty}`
  fi
done