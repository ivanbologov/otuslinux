#!/bin/bash

# vagrant provisioner get strange error trying to work around with simple script
# also when provisioner works parameters of audit and audisp conf files don't changes

# activating sending to remote host auditd log
# next one need to copy auditd log messages to syslog
#sed -i -e 's/active = no/active = yes/' /etc/audisp/plugins.d/syslog.conf
# disable local writing audit log
sed -i -e 's/write_logs = yes/write_logs = no/' /etc/audit/auditd.conf
# also maybe log_format = NOLOG could do the same
# acivating pluging for remote send messages
sed -i -e 's/active = no/active = yes/' /etc/audisp/plugins.d/au-remote.conf
sed -i -e 's!#args =!args = /etc/audisp/audisp-remote.conf!' /etc/audisp/plugins.d/au-remote.conf
sed -i -e 's/remote_server =/remote_server = 192.168.11.115/' /etc/audisp/audisp-remote.conf
# enabling audit wathcing nginx conf folder untill reboot
auditctl -w /etc/nginx -p rwxa -k nginx_configs
# adding to permanent watching
echo '-w /etc/nginx -p rwxa -k nginx_configs' >> /etc/audit/rules.d/audit.rules
##refuse manual start/stop
##systemctl restart auditd.service
# should use
/sbin/service auditd restart
## or may try to send SIGHUP
## not worked for me
##pkill -s 1 auditd

#sed -i -e '23i error_log syslog:server=192.168.11.115:514 info;' /etc/nginx/nginx.conf
sed -i -e '23i error_log syslog:server=192.168.11.115:514,facility=local6,tag=nginx,severity=error;' /etc/nginx/nginx.conf
sed -i -e '24i error_log /var/log/nginx/error.log error;' /etc/nginx/nginx.conf
sed -i -e '22d' /etc/nginx/nginx.conf
sed -i -e '22i access_log syslog:server=192.168.11.115:514,facility=local6,tag=nginx,severity=info;' /etc/nginx/nginx.conf
systemctl restart nginx