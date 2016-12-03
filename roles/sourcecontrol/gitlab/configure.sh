
# git clone http://base.local/root/Configuration.git

# yes | cp Configuration/EnvBuild-I4-1/sourcecontrol/gitlab/etc/gitlab/gitlab.rb /etc/gitlab/.

# Chicken and the egg issue here...

canzea --config_git_commit --template=roles/sourcecontrol/gitlab/config/gitlab.rb /etc/gitlab/gitlab.rb

export GITLAB_ROOT_PASSWORD=adminadmin && export GITLAB_ROOT_EMAIL=gitlab@nowhere.com && sudo gitlab-ctl reconfigure

# sudo gitlab-ctl restart

# /var/opt/gitlab/gitlab-rails/etc/gitlab.yml : change to port 81

# /var/opt/gitlab/nginx/conf/gitlab-http.conf

