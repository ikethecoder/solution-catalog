
yes | rm -rf /opt/elasticsearch-metrics

git clone https://github.com/trevorndodds/elasticsearch-metrics

mkdir /opt/elasticsearch-metrics

cp -r elasticsearch-metrics /opt/elasticsearch-metrics/.

yes | rm -rf elasticsearch-metrics

canzea --config_git_commit --template=roles/monitoring/elasticsearch-metrics/config/script.sh /opt/elasticsearch-metrics/bin/entrypoint.sh

chmod +x /opt/elasticsearch-metrics/bin/entrypoint.sh

canzea --config_git_commit --template=roles/monitoring/elasticsearch-metrics/config/elasticsearch-metrics.service /etc/systemd/system/multi-user.target.wants/elasticsearch-metrics.service

