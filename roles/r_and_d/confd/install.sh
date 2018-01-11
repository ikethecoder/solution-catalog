# Install script for confd

(cd roles/r_and_d/confd && docker build --tag local_confd .)

docker create --name confd -u confd_agent -v /tmp:/host -v /etc/confd:/etc/confd -v /var/local/consul/ssl:/var/local/consul/ssl local_confd confd


