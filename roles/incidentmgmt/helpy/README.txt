
gem install passenger --no-ri

passwd rails




[root@build-e-01 conf.d]# chown 770 /home/rails
[root@build-e-01 conf.d]# chown 770 /home/taiga
[root@build-e-01 conf.d]# usermod -G taiga nginx
[root@build-e-01 conf.d]# usermod -G taiga nginx
[root@build-e-01 conf.d]# usermod -G rails nginx


usermod -a -G users rails

sudo yum install passenger-devel-5.0.30

gem install rack

# ADD %users for access to sudoers

export rvmsudo_secure_path=1 && rvmsudo passenger-install-nginx-module

# passenger_root /usr/share/ruby/vendor_ruby/phusion_passenger/locations.ini;
# passenger_ruby /home/rails/.rvm/gems/ruby-2.3.0/wrappers/ruby;

- newrelic.yml : disable agent

systemctl daemon-reload

systemctl restart helpy

# /home/rails/.rvm/gems/ruby-2.2.1/bin/rails