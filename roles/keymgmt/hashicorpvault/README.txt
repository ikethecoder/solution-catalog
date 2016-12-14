# https://www.vaultproject.io/intro/getting-started/apis.html


export VAULT_ADDR=http://127.0.0.1:8200

vault init

# Need a way of reading the keys


# Unseal with three of the 5 tokens
# vault unseal
# vault unseal
# vault unseal

# Authenticate root token
# vault auth

# Root can then now seal: vault seal

curl http://127.0.0.1:8200/v1/sys/init


curl \
  -X PUT \
  -d "{\"secret_shares\":1, \"secret_threshold\":1}" \
  http://localhost:8200/v1/sys/init


curl \
    -X PUT \
    -d '{"key": "69cf1c12a1f65dddd19472330b28cf4e95c657dfbe545877e5765d25d0592b16"}' \
    http://127.0.0.1:8200/v1/sys/unseal


curl \
    -X POST \
    -H "X-Vault-Token:$VAULT_TOKEN" \
    -d '{"value":"root", "display_name":"demo"}' \
    http://localhost:8200/v1/auth/app-id/map/app-id/152AEA38-85FB-47A8-9CBD-612D645BFACA




# Associate root token to the root policy for an app-id (UUID) (has display name)
# Associate app-id to a user-id (UUID)
# Login using app-id and user-id to get a client_token
# Use API now using the: X-Vault-Token header is the client_token
#

curl \
    -H "X-Vault-Token:$VAULT_TOKEN" \
    -H 'Content-type: application/json' \
    http://127.0.0.1:8200/v1/secret/rocketchat/root


curl \
    -X POST \
    -H "X-Vault-Token:$VAULT_TOKEN" \
    -H 'Content-type: application/json' \
    -d '{"password":"1234"}' \
    http://127.0.0.1:8200/v1/secret/rocketchat/root


export VAULT_CLIENT_CERT=/etc/consul.d/ssl/vault.cert
export VAULT_ADDR=https://vault.service.dc1.consul:8200
export VAULT_CLIENT_KEY=/etc/consul.d/ssl/vault.key
export VAULT_CACERT=/etc/consul.d/ssl/ca.cert
