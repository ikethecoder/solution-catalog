
yum -y install python python-pip
yum -y install python-virtualenv
yum -y install python-virtualenvwrapper
yum -y install libjpeg-devel
yum -y install libxml2-devel libxslt-devel

yum -y install python-psycopg2


pip install --upgrade virtualenv

######################################################################
## Upgrade to Python 3.5.2
######################################################################
wget https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz

tar -xf Python-3.5.2.tgz

(cd Python-3.5.2 && ./configure --prefix=/opt/python3.5)

(cd Python-3.5.2 && make)

(cd Python-3.5.2 && make install)

