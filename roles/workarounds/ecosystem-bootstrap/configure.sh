
#// Add the keyvalue for secure host
canzea --lifecycle=wire --solution=consul --action=add_keyvalue --args='{"key":"nodes/build-a-01/secure_host","value":"{{ECOSYSTEM}}.canzea.cc"}'

#// Initialize and Unseal the vault
#// Injects the VAULT_URL and VAULT_TOKEN (see /helpers/vault/environment.json)

canzea --lifecycle=wire --solution=vault --action=vault-init-unseal --args='{}'

canzea --util=add-env-secret VAULT_TOKEN `cat vault-token`

echo $DIGITALOCEAN_TOKEN

#// Add Digital Ocean secret
canzea --lifecycle=wire --solution=vault --action=register-secret --args='{"key":"digitalocean","data":{"token":"{{DIGITALOCEAN_TOKEN}}"}}'

#// DNS Registration
canzea --lifecycle=wire --solution=digitalocean --action=register-dns --args='{"domain":"{{ECOSYSTEM}}","ip":"{{PUBLIC_IPV4}}","rootHost":"canzea.cc"}'

