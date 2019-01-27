#!/bin/bash
#
#
# init ansible env
#
#
mkdir -p {dev,group_vars,host_vars,production,provision,roles,staging,log}
cat << EOF > ansible.cfg
# based on ansible.cfg from @Albrekht 11th homework stand
[defaults]
inventory = staging/hosts
remote_user= vagrant
host_key_checking = False
forks=5
transport=smart
log_path = log/ansible.log
roles_path = roles
EOF

touch dev/hosts
touch group_vars/all.yml
touch host_vars/host1.yml
touch provision/playbook.yml
touch staging/hosts

#optional for vagrant stands and git repos
touch {README.md,Vagrantfile}

