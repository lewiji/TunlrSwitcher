#!/bin/sh

#  switch.sh
#  TunlrSwitchr
#
#  Created by Lewis Pollard on 22/08/2012.
#  Copyright (c) 2012 Lewis Pollard. All rights reserved

IFS=$'\n'
adapters=`networksetup -listallnetworkservices |grep -v denotes`
for adapter in $adapters
do
	networksetup -setdnsservers $adapter empty
done