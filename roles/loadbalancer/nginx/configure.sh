yes | cp -v prod-1/Files/etc/nginx/nginx.conf /etc/nginx/nginx.conf
yes | cp -v prod-1/Files/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# cp roles/loadbalancer/nginx/config/elastichq.conf /etc/nginx/conf.d/.
# cp roles/loadbalancer/nginx/config/consul.conf /etc/nginx/conf.d/.

#. ~/.bash_ike && ruby ./init/template.rb roles/loadbalancer/nginx/config/consul.conf /etc/nginx/conf.d/consul.conf
# . ~/.bash_ike && ruby ./init/template.rb roles/loadbalancer/nginx/config/elastichq.conf /etc/nginx/conf.d/elastichq.conf

# Workaround for having the web hooks work ok between gitlab and go.cd
#. ~/.bash_ike && ruby ./init/template.rb roles/loadbalancer/nginx/config/gocd.conf /etc/nginx/conf.d/gocd.conf

mkdir -p /home/nginx/www

yes | cp -v prod-1/Files/home/nginx/www/index.html /home/nginx/www/index.html

htpasswd -c -db /etc/nginx/htpasswd.users admin admin1admin

