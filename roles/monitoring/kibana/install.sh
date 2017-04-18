
# Kibana

cp roles/monitoring/kibana/config/kibana.repo /etc/yum.repos.d/kibana.repo

yum install -y kibana

# Upgrade Kibana



(cd ~ && wget https://artifacts.elastic.co/downloads/kibana/kibana-5.3.0-linux-x86_64.tar.gz)
(cd ~; tar -xf kibana-*.gz)
(cd ~; rm -rf /opt/kibana)
mkdir /opt/kibana
(cd ~; yes | cp -R kibana-*/* /opt/kibana/)
(cd ~; rm -rf kibana-*)

# popd

# sudo groupadd -g 1005 kibana
# sudo useradd -u 1005 -g 1005 kibana

sudo chown -R kibana: /opt/kibana


# cp prod-1/Files/etc/nginx/conf.d/kibana.conf /etc/nginx/conf.d/.


