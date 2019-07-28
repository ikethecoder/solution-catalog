import yaml
import subprocess

stream = open("vault_master_keys.yaml", "r")

docs = yaml.load(stream)

for key in docs['unseal_keys_hex']:
    subprocess.call (["vault","operator","unseal","{}".format(key)])
