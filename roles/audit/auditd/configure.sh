
yes | cp -f roles/audit/auditd/config/audit.rules /etc/audit/rules.d/audit.rules

# Added:
# -a exit,always -F arch=b64 -F euid=0 -S execve
# -a exit,always -F arch=b32 -F euid=0 -S execve


# Output: /var/log/audit/audit.log
