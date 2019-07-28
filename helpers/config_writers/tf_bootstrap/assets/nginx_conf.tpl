map $http_upgrade $connection_upgrade {
  default upgrade;
  "" close;
}

server {
  listen                    443 ssl;
  server_name               _;

  ssl_certificate           /etc/certs/chain.pem;
  ssl_certificate_key       /etc/certs/host.key;

  return 404;
}

server {
  listen                    80;
  server_name               _;

  return 404;
}




server {
  listen                    443 ssl;
  server_name               vault.ops.${DOMAIN_NAME};

  ssl_certificate           /etc/certs/chain.pem;
  ssl_certificate_key       /etc/certs/host.key;

  location = / {
    return 301 /ui;
  }

  # Proxy everything over to the service
  location / {
    proxy_set_header        Host            $host;
    proxy_set_header        X-Real-IP       $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;
    proxy_http_version      1.1;
    proxy_set_header        Upgrade $http_upgrade;
    proxy_set_header        Connection $connection_upgrade;

    proxy_pass https://vault.${DOMAIN_NAME}:8200;
  }
}

server {
  listen                    443 ssl;
  server_name               consul.ops.${DOMAIN_NAME};

  ssl_certificate           /etc/certs/chain.pem;
  ssl_certificate_key       /etc/certs/host.key;

  location = / {
    return 301 /ui;
  }

  # Proxy everything over to the service
  location / {
    proxy_set_header        Host            $host;
    proxy_set_header        X-Real-IP       $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;
    proxy_http_version      1.1;
    proxy_set_header        Upgrade $http_upgrade;
    proxy_set_header        Connection $connection_upgrade;

    proxy_pass http://localhost:8500;
  }
}
