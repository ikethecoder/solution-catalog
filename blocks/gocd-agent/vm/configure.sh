
canzea --config_git_commit --template=blocks/gocd-agent/vm/config/go-agent /etc/default/go-agent

mkdir -p /opt/canzea-utils

yes | cp -f blocks/gocd-agent/vm/config/register_service.sh /opt/canzea-utils/.

chmod +x /opt/canzea-utils/register_service.sh

yes | cp -f blocks/gocd-agent/vm/config/docker-run.sh /usr/bin/docker-run

chmod +x /usr/bin/docker-run

(su - go -c "echo -e 'y\n'|ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ''")


# chown -R go /opt/applications/


usermod -aG docker go

