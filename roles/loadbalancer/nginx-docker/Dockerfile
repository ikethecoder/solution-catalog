FROM nginx

RUN apt-get -y update
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:certbot/certbot
RUN apt-get -y install python-certbot-nginx

# COPY default.conf /etc/nginx/conf.d/default.conf

# COPY ssl.conf /etc/nginx/conf.d/ssl.conf
