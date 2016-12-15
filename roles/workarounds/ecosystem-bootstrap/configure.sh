

#// Add the keyvalue for secure host
canzea --lifecycle=wire --solution=consul --action=add_keyvalue --args='{"key":"nodes/build-a-01/secure_host","value":"ese385.canzea.cc"}'

#// Unseal the vault
canzea --lifecycle=wire --solution=vault --action=vault-init --args='{}'
# Returns token and keys

canzea --lifecycle=wire --solution=vault --action=vault-unseal --args='{"key":"4d65aef85320f91a8be7ff0175c59402a9c6eaac0f52c4511ac0592202db8f1c"}'


#// Add Digital Ocean secret
export VAULT_TOKEN=<token>
export VAULT_URL=https://vault.service.dc1.consul:8200
export DIGITALOCEAN_TOKEN=1234
canzea --lifecycle=wire --solution=vault --action=register-secret --args='{"key":"digitalocean","data":{"token":"{{DIGITALOCEAN_TOKEN}}"}}'

#// DNS Registration
canzea --lifecycle=wire --solution=digitalocean --action=register-dns --args='{"domain":"ese385","ip":"67.205.133.135","rootHost":"canzea.cc"}'

