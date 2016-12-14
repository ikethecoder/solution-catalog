
# ssh-keygen -f ~/.ssh/id_rsa.pub -e -m PKCS8 > ~/.ssh/id_rsa.pem.pub

# openssl rsautl -encrypt -pubin -inkey ~/.ssh/id_rsa.pem.pub -ssl -in myMessage.txt -out data

# openssl rsautl -decrypt -inkey ~/.ssh/id_rsa -in myEncryptedMessage.txt


# Provisioning an instance
# - create a new user_id/app_id/policy for the instance to get a unique VAULT_TOKEN
#

# When canzea provisions an instance, create a one-time token that is passed to it via user-data.
# This token is used to post back to Canzea an access token

# NodeJS with OAuth in front for node-red
#

# When we enable Vault, in theory all users should be getting a key.
# For Build-A specifically, there will be a canzea-handshake which, when it is instantiated,
# authenticates and creates a connection so that Canzea can report on the state of the ecosystem
# The flow can also prompt users to read the key so that they can unseal the Vault.
#

# Vault/TLS enablement
