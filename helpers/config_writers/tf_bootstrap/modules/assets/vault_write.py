import yaml
import subprocess

stream = open("vault_master_keys.yaml", "r")

docs = yaml.load(stream)

subprocess.call (["vault", "login", docs['root_token']])
subprocess.call (["vault", "write", "secret/masters/root", "value={}".format(docs['root_token'])])

for idx,key in enumerate(docs['unseal_keys_hex']):
    subprocess.call (["vault", "write", "secret/masters/master_key_{}".format(idx), "value={}".format(key)])

subprocess.call ([ "vault", "auth", "enable", "jwt" ])

# Success! Data written to: secret/masters/root
# Success! Data written to: secret/masters/master_key_0
# Success! Data written to: secret/masters/master_key_1
# Success! Data written to: secret/masters/master_key_2
# Success! Data written to: secret/masters/master_key_3
# Success! Data written to: secret/masters/master_key_4
