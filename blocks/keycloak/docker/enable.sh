

yes | cp -f blocks/keycloak/docker/config/keycloak.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart keycloak


