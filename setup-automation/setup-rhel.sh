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

cat <<EOF > /root/testaudit
type=AVC msg=audit(1755585054.754:548): avc:  denied  { connectto } for  pid=9430 comm="rhsm-service" path="/run/systemd/userdb/io.systemd.Machine" scontext=system_u:system_r:rhsmcertd_t:s0 tcontext=system_u:system_r:systemd_machined_t:s0 tclass=unix_stream_socket permissive=0

        Was caused by:
        The boolean daemons_enable_cluster_mode was set incorrectly. 
        Description:
        Allow daemons to enable cluster mode

        Allow access by executing:
        # setsebool -P daemons_enable_cluster_mode 1
type=AVC msg=audit(1755585054.755:549): avc:  denied  { connectto } for  pid=9430 comm="rhsm-service" path="/run/systemd/userdb/io.systemd.Machine" scontext=system_u:system_r:rhsmcertd_t:s0 tcontext=system_u:system_r:systemd_machined_t:s0 tclass=unix_stream_socket permissive=0

        Was caused by:
        The boolean daemons_enable_cluster_mode was set incorrectly. 
        Description:
        Allow daemons to enable cluster mode

        Allow access by executing:
        # setsebool -P daemons_enable_cluster_mode 1
EOF

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
