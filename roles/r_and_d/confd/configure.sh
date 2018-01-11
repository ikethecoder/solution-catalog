# Configure script for confd

useradd -u 1002 confd_agent

yes | cp -f roles/r_and_d/confd/config/docker.service /etc/systemd/system/multi-user.target.wants/confd.service

mkdir -p /etc/confd

cp -r roles/r_and_d/confd/config/etc/* /etc/confd/.
