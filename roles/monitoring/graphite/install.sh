
yum -y install python

yum -y install python-pip

yum -y install python-devel

pip install virtualenv

virtualenv /opt/graphite

source /opt/graphite/bin/activate


export PYTHONPATH="/opt/graphite/lib/:/opt/graphite/webapp/"
pip install https://github.com/graphite-project/whisper/tarball/master
pip install https://github.com/graphite-project/carbon/tarball/master
pip install https://github.com/graphite-project/graphite-web/tarball/master

pushd /opt/graphite/conf
cp carbon.conf.example carbon.conf
cp storage-schemas.conf.example storage-schemas.conf


##################### VAGRANT
##
wget https://releases.hashicorp.com/vagrant/1.8.6/vagrant_1.8.6_x86_64.rpm
yum install vagrant_1.8.6_x86_64.rpm


git clone https://github.com/obfuscurity/synthesize.git
cd synthesize/
vagrant plugin install vagrant-vbguest
vagrant init
vagrant up


