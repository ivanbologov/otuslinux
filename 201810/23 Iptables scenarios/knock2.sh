#!/bin/bash

# call example ./knock.sh vagrant 192.168.255.1 2222 3333 4444

USER=$1
shift
HOST=$1
shift
for ARG in "$@"
do
    # scan with fin flag to escape tcp retrasmission when using syn only
    #nmap -sF --max-retries 0 -p $ARG $HOST
    # for udp knock
    nmap -sU -Pn --max-retries 0 -p U:$ARG $HOST
done
sleep 1
ssh $USER@$HOST