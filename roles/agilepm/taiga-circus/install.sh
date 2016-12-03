
################################################################
# Install Circus and configure for Taiga

pip install circus

yes | cp -f roles/agilepm/taiga-circus/config/circus.service /usr/lib/systemd/system/circusd.service

mkdir -p /etc/circus/conf.d

# Setup circus configuration
yes | cp -f roles/agilepm/taiga-circus/config/circus.ini /etc/circus/circus.ini


canzea --config_git_commit --template=roles/agilepm/taiga-circus/config/config.ini /etc/circus/conf.d/config.ini

su taiga -l -c "mkdir -p ~/logs"


################################################################
# Configure NGINX

usermod -a -G taiga nginx
# usermod -G taiga,rails nginx

chmod 770 /home/taiga

yes | cp -f roles/agilepm/taiga-circus/config/nginx-taiga.conf /etc/nginx/conf.d/taiga.conf
