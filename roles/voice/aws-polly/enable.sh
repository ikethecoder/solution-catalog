
mkdir -p /var/local/aws/.aws

touch /var/local/aws/.aws/credentials

canzea --lifecycle=wire --solution=ecosystem --action=config --args='{"source":"roles/voice/aws-polly/config/aws-credentials.txt", "target":"/var/local/aws/.aws/credentials", "track":false}'

yes | cp -f roles/voice/aws-polly/config/docker.service /etc/systemd/system/multi-user.target.wants/aws-polly.service

systemctl daemon-reload

systemctl restart aws-polly

