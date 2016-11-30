
# Change DEFAULT_SERVER
ruby ./init/template.rb roles/relationaldatabase/pgadmin/config/config.py /usr/lib/python2.7/site-packages/pgadmin4-web/config.py

systemctl restart pgadmin4-v1
