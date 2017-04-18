# yum -y install https://grafanarel.s3.amazonaws.com/builds/grafana-3.1.1-1470047149.x86_64.rpm

cp roles/monitoring/grafana/config/grafana.repo /etc/yum.repos.d/grafana.repo

rpm --import https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana

yum -y install grafana
