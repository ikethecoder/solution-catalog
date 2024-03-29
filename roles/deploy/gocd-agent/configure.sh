
canzea --config_git_commit --template=roles/deploy/gocd-agent/config/go-agent /etc/default/go-agent

mkdir -p /opt/canzea-utils

yes | cp -f roles/deploy/gocd-agent/config/register_service.sh /opt/canzea-utils/.

chmod +x /opt/canzea-utils/register_service.sh

yes | cp -f roles/deploy/gocd-agent/config/docker-run.sh /usr/bin/docker-run

chmod +x /usr/bin/docker-run

(su - go -c "echo -e 'y\n'|ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ''")


# chown -R go /opt/applications/


usermod -aG docker go

