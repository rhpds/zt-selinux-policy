#!/bin/bash

while [ ! -f /opt/instruqt/bootstrap/host-bootstrap-completed ]
do
    echo "Waiting for Instruqt to finish booting the VM"
    sleep 1
done

# This base code allows us to access content
# TODO: Matthew will embed the activation key in a new image
yum remove -y google-rhui-client-rhel8.noarch
yum clean all
subscription-manager config --rhsm.manage_repos=1
subscription-manager register --activationkey=${ACTIVATION_KEY} --org=12451665 --force

# BEGIN: Track setup code
# get our sample code and testaudit

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