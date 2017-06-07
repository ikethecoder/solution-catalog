
yes | cp -f roles/workarounds/journald/config/journald.conf /etc/systemd/journald.conf

systemctl restart systemd-journald
