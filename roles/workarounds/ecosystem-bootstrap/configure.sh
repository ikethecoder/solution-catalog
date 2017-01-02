

#// Add the keyvalue for secure host
canzea --lifecycle=wire --solution=consul --action=add_keyvalue --args='{"key":"nodes/build-a-01/secure_host","value":"ese385.canzea.cc"}'

#// Initialize and Unseal the vault
#// export VAULT_URL=http://vault.service.dc1.consul:8200
#// export VAULT_TOKEN=
#// Inject the VAULT_URL and VAULT_TOKEN
canzea --lifecycle=wire --solution=vault --action=vault-init-unseal --args='{}'

# canzea --util=add-env VAULT_TOKEN token
# canzea --util=add-env VAULT_URL "https://vault.service.dc1.consul:8200"

#// Add Digital Ocean secret
canzea --lifecycle=wire --solution=vault --action=register-secret --args='{"key":"digitalocean","data":{"token":"{{DIGITALOCEAN_TOKEN}}"}}'

#// DNS Registration
canzea --lifecycle=wire --solution=digitalocean --action=register-dns --args='{"domain":"ese385","ip":"{{PUBLIC_IPV4}}","rootHost":"canzea.cc"}'

