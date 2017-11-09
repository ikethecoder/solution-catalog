
#// Add the keyvalue for secure host
# canzea --lifecycle=wire --solution=consul --action=add_keyvalue --args='{"root":"nodes", "key":"build-a-01/secure_host","value":"{{ECOSYSTEM}}.canzea.cc"}'

#// Initialize and Unseal the vault
#// Injects the VAULT_URL and VAULT_TOKEN (see /helpers/vault/environment.json)

canzea --lifecycle=wire --solution=vault --action=vault-init-unseal --args='{}'

(export VAULT_TOKEN=`cat vault-token` && echo "export VAULT_TOKEN=$VAULT_TOKEN" >> /root/.bash_profile; )

canzea --util=add-env-secret VAULT_TOKEN `cat vault-token`
