#!/bin/sh
#
# this scipt will create 5 test users (or more if you change variable c)):
# user1, user2, ... user5
# with passwords password1, password2, etc
# odd users (user1, user3, user5) will in group admin
# even users (user2, user4) will only in their own groups
#
pass="password"
user="user"
adminGroup="-G admin"
addgroup=""

/sbin/groupadd admin

for (( c=1; c<=5; c++ ))
do
        if (($c%2)); then
                addgroup=$adminGroup
        else
                addgroup=""
        fi
        /sbin/useradd -p $(/bin/openssl passwd -1 $pass$c) $addgroup $user$c
done