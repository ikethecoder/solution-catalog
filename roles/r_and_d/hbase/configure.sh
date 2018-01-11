# Configure script for hbase

cp roles/r_and_d/hbase/config/hbase.service /etc/systemd/system/multi-user.target.wants/hbase.service

cp roles/r_and_d/hbase/config/hbase-env.sh /opt/hbase-1.3.1/conf/hbase-env.sh
cp roles/r_and_d/hbase/config/hbase-site.xml /opt/hbase-1.3.1/conf/hbase-site.xml


systemctl daemon-reload

systemctl start hbase

