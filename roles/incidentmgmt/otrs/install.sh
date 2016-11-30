
# http://otrs.github.io/doc/manual/admin/stable/en/html/installation.html#installation-on-centos


wget http://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-5.0.12-01.noarch.rpm

yum install otrs-5.0.12-01.noarch.rpm

yum -y install mariadb-server

systemctl start  mariadb

# http://www.build.es522.canzea.cc/otrs/installer.pl

# http://www.build.es522.canzea.cc/otrs/installer.pl

vi /etc/my.cnf

systemctl restart mariadb.service