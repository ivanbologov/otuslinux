#!/bin/bash
# usage:
# step5.sh [message_receiver_addr] [sender_addr] [host] [tcp_port1] [tcp_port2]
host=$3
zm_port=$4
ovpn_port=$5

SUBJECT="some external services is unavailable"
RECEIVER="$1"
SENDER="$2"
TEXT="Take attention to the services:\n\n "
MAIL_TXT="Subject: $SUBJECT\nFrom: $SENDER\nTo: $RECEIVER\n\n$TEXT"
MAIL_CLIENT="/usr/sbin/sendmail"

ZM_TEXT="\tZoneMinder is unavailable;\n"
OVPN_TEXT="\tOpenVPN is unavailable;\n"

checker () {
        nc -z -w3 $host $1 </dev/null
        if [ "$?" -ne 0 ]; then
                MAIL_TXT+=" $2"
        fi
        return 0
}
checker $zm_port "$ZM_TEXT"
checker $ovpn_port "$OVPN_TEXT"

#send mail
echo -e $MAIL_TXT | /usr/sbin/sendmail -t -f $SENDER
