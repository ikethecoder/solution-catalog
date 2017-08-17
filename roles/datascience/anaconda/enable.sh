yes | cp -f roles/datascience/anaconda/config/anaconda.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart anaconda

