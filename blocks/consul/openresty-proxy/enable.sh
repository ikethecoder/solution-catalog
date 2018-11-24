

yes | cp -f blocks/consul/openresty-proxy/config/consul_oidc.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart consul_oidc



