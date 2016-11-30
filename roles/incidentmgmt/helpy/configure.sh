
# http://support.helpy.io/en/knowledgebase/11-installing-helpy/docs/27-installing-helpy-on-ubuntu-14-04-using-passenger-and-nginx

su - postgres -c "createuser -s rails"
su - postgres -c "createdb helpy_production"

su - postgres -c "psql -c \"ALTER USER rails WITH PASSWORD 'rails'\""

su rails -l -c "(cd ~/helpy && export APP_DATABASE_PASSWORD=rails && export RAILS_ENV=production && rake db:create)"
su rails -l -c "(cd ~/helpy && export APP_DATABASE_PASSWORD=rails && export RAILS_ENV=production && RAILS_ENV=production && rake db:migrate)"
su rails -l -c "(cd ~/helpy && export APP_DATABASE_PASSWORD=rails && export RAILS_ENV=production && rake db:seed)"



##########################################
####### UNICORN
##########################################

su rails -c "cp roles/incidentmgmt/helpy/config/unicorn.rb ~/helpy/config/unicorn.rb"

mkdir /home/rails/helpy/pids

chown rails:rails /home/rails/helpy/pids

ruby ./init/template.rb roles/incidentmgmt/helpy/config/nginx-helpy.conf /etc/nginx/conf.d/helpy.conf

ruby ./init/template.rb roles/incidentmgmt/helpy/config/helpy.service /etc/systemd/system/multi-user.target.wants/helpy.service


# export APP_DATABASE_PASSWORD=rails
# export SECRET_KEY_BASE=c1c4a39f24c54081008488d4a897df7c20c2d384d5a6d462313a39d705512c5316ffe64f59a30c97c4fb6aaa61fbe2e879c165e29fb3c552a84b402710588681

# unicorn_rails -E production -D -c config/unicorn.rb





# (as rails)
# export SECRET_KEY_BASE=c1c4a39f24c54081008488d4a897df7c20c2d384d5a6d462313a39d705512c5316ffe64f59a30c97c4fb6aaa61fbe2e879c165e29fb3c552a84b402710588681
# cd ~/helpy; rails s -e production -b 67.205.158.232 -p 3001

# admin@test.com
# 12345678

# NGINX and Passenger should not require this to be done
# . ~/.bash_ike && ruby ./init/template.rb roles/incidentmgmt/helpy/config/helpy.service /etc/systemd/system/multi-user.target.wants/helpy.service

