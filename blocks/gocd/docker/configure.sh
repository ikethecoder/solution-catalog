
canzea --config_git_commit --template=blocks/gocd/docker/config/gocd.service /etc/systemd/system/multi-user.target.wants/gocd.service

systemctl daemon-reload
systemctl start gocd


# Create password access
python -c "import sha; from base64 import b64encode; print 'sp_gocd_admin:' + b64encode(sha.new('1234').digest())" >> /var/local/gocd/godata/password.properties
