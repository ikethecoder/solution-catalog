
canzea --config_git_commit --template=blocks/archiva/docker/config/archiva.service /etc/systemd/system/multi-user.target.wants/archiva.service


systemctl daemon-reload

systemctl start archiva

# Give a little time to wait for archiva to start - basically a bit of a hack so the first-login works ok
# first-login should really check with service discovery
sleep 5