#!/bin/bash
# usage: [lockfile] [break] 
LOCK="$1"
if [ -e $LOCK ]; then
	echo "$0 is already running"
	exit 6 #SIGABRT
fi
#touch $LOCK
echo $$ > $LOCK
trap 'rm -f "$LOCK"; exit $?' INT TERM EXIT
# command
BREAK="$2"
STOP=95
while [ true ]
do
	echo "ZZzzZZzzzz"
	sleep 1
	var=$(($RANDOM % 100))
	if [[ $BREAK == "break" && $var -ge $STOP ]]; then 
		echo "random break" 	
		break	
	fi
done
#
rm -f $LOCK
trap - INT TERM EXIT
