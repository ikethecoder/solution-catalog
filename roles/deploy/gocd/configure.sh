

yes | cp -f roles/deploy/gocd/config/go-server /etc/default/go-server


ruby ./init/template.rb roles/deploy/gocd/config/nginx/gocd.conf /etc/nginx/conf.d/gocd.conf
