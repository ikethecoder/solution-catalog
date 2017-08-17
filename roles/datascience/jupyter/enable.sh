yes | cp -f roles/datascience/jupyter/config/jupyter.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart jupyter

