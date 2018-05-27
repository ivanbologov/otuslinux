#!/bin/bash

if [ $# -lt 1 ]; then
	echo "usage: $0 [openvpn.log]" 1>&2
	exit 1
fi

if [ -e $1 ]; then
	cat $1 | egrep "[a-zA-Z\-]+[\/]{1}([0-9]{1,3}[\.]){3}[0-9]{1,3}.*IPv4=([0-9]{1,3}[\.]){3}[0-9]{1,3}" | awk '{print $6 " " $10}' | sed -E 's/[\/:=,]+/\ /g' | awk '{print $1 " " $2 " " $5}' | sort | uniq -c
else
	echo "file not found" 1>&2
fi
