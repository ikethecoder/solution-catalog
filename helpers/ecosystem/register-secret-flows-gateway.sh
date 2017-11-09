

vault write secret/service/vault token=$VAULT_TOKEN

vault auth-enable userpass
vault auth-enable approle

