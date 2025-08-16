#!/bin/bash

# install the packages
dnf install -y --releasever=10 --installroot=$scratchmnt redhat-release
dnf install -y --setopt=reposdir=/etc/yum.repos.d \
      --installroot=$scratchmnt \
      --setopt=cachedir=/var/cache/dnf httpd

# Enable cockpit functionality in showroom.
dnf -y remove tlog cockpit-session-recording
echo "[WebService]" > /etc/cockpit/cockpit.conf
echo "Origins = https://cockpit-${GUID}.${DOMAIN}" >> /etc/cockpit/cockpit.conf
echo "AllowUnencrypted = true" >> /etc/cockpit/cockpit.conf
systemctl enable --now cockpit.socket

#echo "Adding wheel" > /root/post-run.log
#usermod -aG wheel rhel

#echo "setting password" >> /root/post-run.log
#echo redhat | passwd --stdin rhel

#echo "exclude=kernel*" >> /etc/yum.conf

#echo "Install PCP packages" >> /root/post-run.log
#dnf install pcp-zeroconf cockpit-pcp stress-ng -y

#echo "restart cockpit" >> /root/post-run.log
#systemctl restart cockpit

#echo "DONE" >> /root/post-run.log

#touch /root/post-run.log.done
