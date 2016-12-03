
# Change DEFAULT_SERVER
canzea --config_git_commit --template=roles/relationaldatabase/pgadmin/config/config.py /usr/lib/python2.7/site-packages/pgadmin4-web/config.py

systemctl restart pgadmin4-v1
