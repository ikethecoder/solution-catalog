docker create --name flows-gateway -p 8000:8000 flows-gateway



yes | cp -f roles/adhoc/flows-gateway/config/flows-gateway.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart flows-gateway

