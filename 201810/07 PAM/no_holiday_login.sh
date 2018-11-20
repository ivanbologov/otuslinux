#!/bin/sh
#
# disallow anyone, except admin group, login at weekend and holidays
# if script returns not 0 pam_script will not permit auth, cause onerr=fail
# it will work only if pam_script not used onerr=success as parameter
#
group="admin"
#today=$(/bin/date +%Y%m%d)
today="20181231"
script=`basename $0`
stamp=`/bin/date +'%Y%m%d%H%M%S %a'`
#LOGFILE=/tmp/pam-script.log
LOGFILE=/var/log/secure
/bin/id -Gn $PAM_USER | /bin/grep $group > /dev/null 2>&1
if [ $? -ne 0 ]; then
    daytype=$(/bin/curl -fs https://isdayoff.ru/$today?cc=ru)
    if [ $daytype -eq 1 ]; then
        echo "$stamp $script $PAM_SERVICE $PAM_TYPE tty=$PAM_TTY. Today $today is holliday the user $PAM_USER should not work. Log of..." >> $LOGFILE
        #chmod 666 $LOGFILE > /dev/null 2>&1
        exit 1
    fi
fi