

#// Add the keyvalue for secure host
canzea --lifecycle=wire --solution=consul --action=add_keyvalue --args='{"key":"nodes/build-a-01/secure_host","value":"ese385.canzea.cc"}'

#// Unseal the vault
canzea --lifecycle=wire --solution=vault --action=vault-init --args='{}'
# Returns token and keys

canzea --lifecycle=wire --solution=vault --action=vault-unseal --args='{"key":"e14938a35f0796b460ea75fa3a1a43599925a4c5c5b4e78cc9a5fc1517b5b901"}'


#// Add Digital Ocean secret
export VAULT_TOKEN=c7696375-e4ee-89d0-883d-17b67496457f
export VAULT_URL=https://vault.service.dc1.consul:8200
export DIGITALOCEAN_TOKEN=e6e6bdd4a7fb960e0e984bc1a43b4aacddfdea4ba04863970b0b01cbbd0f8d98
canzea --lifecycle=wire --solution=vault --action=register-secret --args='{"key":"digitalocean","data":{"token":"{{DIGITALOCEAN_TOKEN}}"}}'

#// DNS Registration
canzea --lifecycle=wire --solution=digitalocean --action=register-dns --args='{"domain":"ese385","ip":"162.243.172.46","rootHost":"canzea.cc"}'

