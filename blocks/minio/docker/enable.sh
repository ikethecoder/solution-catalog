

yes | cp -f blocks/minio/docker/config/minio.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart minio


