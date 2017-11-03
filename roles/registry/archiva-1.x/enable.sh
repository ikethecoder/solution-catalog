

# cp /root/ike-environments/environment/production/roles/registry/archiva/config/archiva.service /etc/systemd/system/multi-user.target.wants/.

ln -sf /opt/archiva/bin/archiva /etc/init.d/archiva

# chkconfig archiva on

# service archiva restart

# etcdctl set /components/repository/primary/port 9080
# export REPO_HOST=`etcdctl get /machines/base.local/private_ip`; etcdctl set /components/repository/primary/host $REPO_HOST
