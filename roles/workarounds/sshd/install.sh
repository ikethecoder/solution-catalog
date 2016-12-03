
yes | cp -f roles/workarounds/sshd/config/sshd_config /etc/ssh/sshd_config

service sshd restart

sleep 3