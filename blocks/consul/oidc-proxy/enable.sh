

yes | cp -f blocks/consul/oidc-proxy/config/consul_oidc_proxy.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart consul_oidc_proxy



