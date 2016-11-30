
su rails -l -c "(cd ~ && git clone https://github.com/helpyio/helpy.git)"

su rails -l -c "rvm requirements"

su rails -l -c "rvm gemset create helpy"

su rails -l -c "(cd ~/helpy && gem install bundler)"

su rails -l -c "(cd ~/helpy && bundle install)"

su rails -l -c "(cd ~/helpy && cp config/database.do.yml config/database.yml)"

su rails -l -c "touch /home/rails/helpy/log/production.log"

su rails -l -c "chmod 0664 /home/rails/helpy/log/production.log"

su rails -l -c "gem install tzinfo"

su rails -l -c "gem list"



su rails -l -c "(cd ~/helpy && gem install execjs)"
su rails -l -c "(cd ~/helpy && gem install therubyracer)"

su rails -l -c "(cd ~/helpy && echo 'gem \"therubyracer\"' >> Gemfile)"

su rails -l -c "(cd ~/helpy && bundle install)"

yum -y install ImageMagick

su rails -l -c "(cd ~/helpy && RAILS_ENV=production && rake assets:precompile)"

su rails -l -c "gem install unicorn"



###############################################################
######### UNICORN NGINX Integration configured
###############################################################

mkdir /var/sockets

chmod 777 /var/sockets


###############################################################
######### Make NGINX happy
###############################################################

chmod 770 /home/rails
usermod -a -G rails nginx

