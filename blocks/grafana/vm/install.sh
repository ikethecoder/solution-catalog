
cp blocks/grafana/vm/config/grafana.repo /etc/yum.repos.d/grafana.repo

rpm --import https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana

yum -y install grafana
