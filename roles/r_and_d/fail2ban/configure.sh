# Configure script for fail2ban

cp roles/r_and_d/fail2ban/config/fail2ban.service /etc/systemd/system/multi-user.target.wants/fail2ban.service

cp roles/r_and_d/fail2ban/config/etc/sshd.conf /etc/fail2ban/jail.d/sshd.conf

