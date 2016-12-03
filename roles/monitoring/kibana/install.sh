
# Kibana

cp roles/monitoring/kibana/config/kibana.repo /etc/yum.repos.d/kibana.repo

yum install -y kibana

# Upgrade Kibana

(cd ~ && wget https://download.elastic.co/kibana/kibana/kibana-4.6.1-linux-x86_64.tar.gz)
(cd ~; tar -xf kibana-4*.gz)
(cd ~; rm -rf /opt/kibana)
mkdir /opt/kibana
(cd ~; yes | cp -R kibana-4*/* /opt/kibana/)
(cd ~; rm -rf kibana-4*)

# popd

# sudo groupadd -g 1005 kibana
# sudo useradd -u 1005 -g 1005 kibana

sudo chown -R kibana: /opt/kibana


# cp prod-1/Files/etc/nginx/conf.d/kibana.conf /etc/nginx/conf.d/.


