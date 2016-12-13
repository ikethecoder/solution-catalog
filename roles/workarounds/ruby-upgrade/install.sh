
yum -y install ruby

yum -y install gcc ruby-devel rubygems

yum -y install libcurl-devel

# Upgrade
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

curl -sSL https://get.rvm.io | bash -s stable --ruby

source /usr/local/rvm/scripts/rvm

ruby -v

/usr/local/rvm/bin/rvm --default

ruby -v

chmod +x roles/workarounds/ruby-gems/install.sh

# If this fails, then we can run: rvm remove ruby-2.3.0 manually to revert back to beginning of this script
# Run the gems as we need the minimal to support Canzea CLI
bash -l -c "./roles/workarounds/ruby-gems/install.sh"
bash -l -c "gem list"

gem list
