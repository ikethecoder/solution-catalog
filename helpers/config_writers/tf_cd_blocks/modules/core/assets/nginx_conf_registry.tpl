
server {
  listen                    443 ssl;
  server_name               registry.ops.${DOMAIN_NAME};

  ssl_certificate           /etc/certs/chain.pem;
  ssl_certificate_key       /etc/certs/host.key;

  # Proxy everything over to the service
  location / {
    client_max_body_size    0;

    proxy_set_header        Host            $host;
    proxy_set_header        X-Real-IP       $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;
    proxy_http_version      1.1;
    proxy_set_header        Upgrade $http_upgrade;
    proxy_set_header        Connection $connection_upgrade;

    proxy_pass http://${IP}:30300;
  }
}
