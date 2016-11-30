
yum -y install bzip2

echo "THIS DOES NOT ALWAYS WORK!!!"

# wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2

tar xvf phantomjs-2.1.1-linux-x86_64.tar.bz2

yes | cp -f phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/.

