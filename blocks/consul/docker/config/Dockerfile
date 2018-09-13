FROM consul:1.2.2
RUN ls /consul
RUN ls /consul/config

ENV CONSUL_CACERT=/etc/consul.d/ssl/ca.cert
ENV CONSUL_CLIENT_CERT=/etc/consul.d/ssl/consul.cert
ENV CONSUL_CLIENT_KEY=/etc/consul.d/ssl/consul.key
ENV CONSUL_HTTP_ADDR=https://consul.service.dc1.consul:8080

COPY config.json /consul/config/.

