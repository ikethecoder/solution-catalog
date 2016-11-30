
# docker run -d -p 5000:5000 --restart=always --name registry registry:2

# docker tag ike/base localhost:5000/ike/base

# docker push localhost:5000/ike/base

# docker pull localhost:5000/ike/base

# Remove all docker containers that have exited
# docker rm `docker ps -q -f status=exited`


# ------

# Self-signing

# Generate the certs (Update CN as: base.local)
mkdir -p certs && openssl req  -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key  -x509 -days 365 -out certs/domain.crt -subj "/C=CA/CN=base.local"

# Start the register
docker run -d -p 5000:5000 --restart=always --name registry -v `pwd`/certs:/certs -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key  registry:2

# On client
# - update /etc/hosts with the domain
# - transfer domain.crt to /etc/docker/certs.d/base.local:5000/ca.crt
# Getting error: x509: certificate signed by unknown authority
#
