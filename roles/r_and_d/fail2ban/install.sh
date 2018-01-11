# Install script for fail2ban

curl -L -s -O https://github.com/fail2ban/fail2ban/archive/0.8.14.tar.gz

tar xf 0.8.14.tar.gz

(cd fail2ban-0.8.14 && python setup.py install)

rm -rf fail2ban-0.8.14

rm -f 0.8.14.tar.gz

