
mkdir -p /var/local/rabbitmq/data

canzea --config_git_commit --template=blocks/rabbitmq/docker/config/rabbitmq.service /etc/systemd/system/multi-user.target.wants/rabbitmq.service

