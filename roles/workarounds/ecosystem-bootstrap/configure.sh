

#// Add the keyvalue for secure host
canzea --lifecycle=wire --solution=consul --action=add_keyvalue --args='{"key":"nodes/build-a-01/secure_host","value":"ese385.canzea.cc"}'

#// Initialize and Unseal the vault
#// Inject the VAULT_URL and VAULT_TOKEN
canzea --lifecycle=wire --solution=vault --action=vault-init-unseal --args='{}'

#// Add Digital Ocean secret
canzea --lifecycle=wire --solution=vault --action=register-secret --args='{"key":"digitalocean","data":{"token":"{{DIGITALOCEAN_TOKEN}}"}}'

#// DNS Registration
canzea --lifecycle=wire --solution=digitalocean --action=register-dns --args='{"domain":"ese385","ip":"162.243.172.46","rootHost":"canzea.cc"}'

