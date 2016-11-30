
yum -y install unzip

rm -rf ~/apache-archiva-*

#
# http://mirror.vorboss.net/apache/archiva/2.2.0/binaries/apache-archiva-2.2.0-bin.zip
# wget -P ~/ -nv http://apache.mirror.vexxhost.com/archiva/2.2.1/binaries/apache-archiva-2.2.1-bin.zip
wget -P ~/ -nv http://mirror.csclub.uwaterloo.ca/apache/archiva/2.2.1/binaries/apache-archiva-2.2.1-bin.zip

mkdir -p /opt/archiva

cd /opt/archiva; unzip ~/apache-archiva-2.2.1-bin.zip

cd /opt/archiva; mv apache-archiva-2.2.1/* .

yes | rm -f ~/apache-archiva-2.2.1-bin.zip
