#!/bin/bash

# BEGIN: Track setup code
# get our sample code and testaudit

echo "[WebService]" > /etc/cockpit/cockpit.conf
echo "Origins = https://cockpit-$(hostname -f|cut -d"-" -f2).apps.$(grep search /etc/resolv.conf| grep -o '[^ ]*$')" >> /etc/cockpit/cockpit.conf
echo "AllowUnencrypted = true" >> /etc/cockpit/cockpit.conf
systemctl enable --now cockpit.socket

yum -y install wget ansible-core rhel-system-roles
ansible-galaxy collection install ansible.posix

mkdir files

# Change the URL to point to the published content on rhlabs github
export SOURCE_URL=https://raw.githubusercontent.com/parmstro/selinuxlab/master

wget $SOURCE_URL/testaudit
wget $SOURCE_URL/ansible.cfg
wget $SOURCE_URL/inventory
wget $SOURCE_URL/setup-lab.yml
wget $SOURCE_URL/setup-testapp.yml
cd files
wget $SOURCE_URL/files/Makefile
wget $SOURCE_URL/files/exports
wget $SOURCE_URL/files/mail.php
wget $SOURCE_URL/files/sample.war
wget $SOURCE_URL/files/shadow.sh
wget $SOURCE_URL/files/smb.conf
wget $SOURCE_URL/files/testapp.c
wget $SOURCE_URL/files/testapp.service
wget $SOURCE_URL/files/.vimrc
cd ..

systemctl enable --now cockpit.socket

ansible-playbook -i inventory setup-lab.yml

# END: Track setup code

n=1
GREEN='\033[0;32m' 
NC='\033[0m' # No Color

clear
echo -e "${GREEN}Ready to start your scenario${NC}"
