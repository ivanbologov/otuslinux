#!/bin/bash
# Usage: step4.sh [pidfile] [command]

if [ $# -lt 2 ]; then
	echo "usage: $0 [pidfile] [command]" 1>&2
	exit 1
fi

PIDFILE=$1
shift 1
COMMAND=$1
shift 1

if [ -e $PIDFILE ]; then
	c=$(ps -p $(cat $PIDFILE) | wc -l)
	if [ $c -eq 2 ]; then
		echo 'already running' 1>&2
		ls -l $PIDFILE 1>&2
		exit 1
	fi
fi
#dump pid
echo "$$" > $PIDFILE

#run command
$COMMAND "$@"

#remove pid file
rm $PIDFILE
