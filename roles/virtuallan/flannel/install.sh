
# http://severalnines.com/blog/installing-kubernetes-cluster-minions-centos7-manage-pods-services


# yum -y install kernel-headers golang gcc

# git clone https://github.com/coreos/flannel.git

# (export GOPATH=`pwd`; cd flannel; make dist/flanneld)

# https://github.com/coreos/flannel

yum -y install flannel


yum -y install ntp

systemctl start ntpd

systemctl enable ntpd
