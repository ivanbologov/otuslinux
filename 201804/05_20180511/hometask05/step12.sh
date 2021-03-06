#/bin/bash
# sample watchdog script
# usage step1.sh [is_notify] [sender] [receiver] [lockfile] [file] 
isNotify="$1"
shift 1
RECEIVER="$2"
SENDER="$1"
SUBJECT="Attention! Service was unavailable"
shift 2
# PID variable here is just a name, it's a lockfile
PID=$1
shift 1
COMMAND=$1
shift 1

runCommand () {
	file $COMMAND | grep shell 1>/dev/null 
	if [ $? -eq 0 ]; then
		bash $COMMAND "$@" &
	else
		$COMMAND "$@" &
	fi
	# send email
	if [[ $isNotify == "notify" ]]; then
		echo -e "$COMMAND service was restarted with code $? at $(date '+%Y%m%d %H:%M:%S')" | mail -s "$SUBJECT" -r "$SENDER" "$RECEIVER"
	fi
	return 0
}

if [ -e $PID ]; then
	if [ -e /proc/$(cat $PID) ]; then
		echo "$COMMAND allready running with PID $(cat $PID)"
	else
		rm -f $PID
		runCommand $@ 
	fi
else
	runCommand $@
fi
