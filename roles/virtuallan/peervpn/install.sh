curl -LO https://peervpn.net/files/peervpn-0-044-linux-x86.tar.gz

tar xzvf peervpn*

cp peervpn-0-044/peervpn /usr/local/bin/.

cp peervpn-0-044/peervpn.conf /etc/.

rm -rf peervpn*

# openssl rand -base64 382 | tr -d '\n'

yes | cp roles/virtuallan/peervpn/config/peervpn.conf /etc/peervpn.conf


yes | cp roles/virtuallan/peervpn/config/peervpn.service /etc/systemd/system/multi-user.target.wants/peervpn.service

