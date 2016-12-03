
######################################################################
## Prepare database
######################################################################



sudo -u postgres createuser taiga
sudo -u postgres createdb taiga -O taiga

# GRANT ALL ON SCHEMA taiga TO root

# GRANT ALL ON ALL TABLES IN SCHEMA  taiga TO root

# export PGDATA=/var/lib/pgsql/data

# export PATH=/home/taiga/.virtualenvs/taiga/bin:$PATH

# pip install Django --upgrade

su taiga -l -c "(cd ~/taiga-back && workon taiga && python manage.py migrate --noinput)"
su taiga -l -c "(cd ~/taiga-back && workon taiga && python manage.py loaddata initial_user)"
su taiga -l -c "(cd ~/taiga-back && workon taiga && python manage.py loaddata initial_project_templates)"
su taiga -l -c "(cd ~/taiga-back && workon taiga && python manage.py loaddata initial_role)"
su taiga -l -c "(cd ~/taiga-back && workon taiga && python manage.py compilemessages)"
su taiga -l -c "(cd ~/taiga-back && workon taiga && python manage.py collectstatic --noinput)"



# Copy local.py

canzea --config_git_commit --template=roles/agilepm/taiga/config/local.py /home/taiga/taiga-back/settings/local.py

# su taiga -l -c "(cd ~/taiga-back && workon taiga && python manage.py runserver)"

