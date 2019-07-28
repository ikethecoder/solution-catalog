import yaml
import subprocess

stream = open("vault_master_keys.yaml", "r")

docs = yaml.load(stream)

with open(".token-reference") as t:
  filename = "/var/helm-temp/{}.txt".format(t.read())

  with open(filename, "w") as f: 
    f.write(docs['root_token'])
