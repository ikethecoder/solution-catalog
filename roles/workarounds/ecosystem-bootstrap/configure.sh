
#// Add the keyvalue for secure host
canzea --lifecycle=wire --solution=consul --action=add_keyvalue --args='{"root":"nodes", "key":"build-a-01/secure_host","value":"{{ECOSYSTEM}}.canzea.cc"}'

#// Initialize and Unseal the vault
#// Injects the VAULT_URL and VAULT_TOKEN (see /helpers/vault/environment.json)

canzea --lifecycle=wire --solution=vault --action=vault-init-unseal --args='{}'

canzea --util=add-env-secret VAULT_TOKEN `cat vault-token`

echo $DIGITALOCEAN_TOKEN

#// Add Digital Ocean secret
export DATA=`canzea --decrypt --privateKey=/root/.ssh/id_rsa $ES_ENC_DATA` && export ARGS='{"key":"digitalocean","data":'$DATA'}' && canzea --lifecycle=wire --solution=vault --action=register-secret --args=$ARGS

#// DNS Registration
canzea --lifecycle=wire --solution=digitalocean --action=register-dns --args='{"domain":"{{ECOSYSTEM}}","ip":"{{PUBLIC_IPV4}}","rootHost":"canzea.cc"}'

