
server {
  listen                    443 ssl;
  server_name               helm.ops.184768.xyz;

  ssl_certificate           /etc/certs/chain.pem;
  ssl_certificate_key       /etc/certs/host.key;

  location ^~ /temp {
    root     /var/helm-temp;
    rewrite  ^/temp/(.*) /$1 break;
  }

  # Proxy everything over to the service
  location ^~ /charts {
    root     /var/helm-charts;
    rewrite  ^/charts/(.*) /$1 break;
  }
}
