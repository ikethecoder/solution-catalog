
import os
import requests
import json
import sys

url = "https://%s/auth/realms/master/protocol/openid-connect/token" % os.environ['AUTH_HOST']

authdata = {
    "client_id" : "admin-cli",
    "username" : os.environ['ADMIN_USERNAME'],
    "password" : os.environ['ADMIN_PASSWORD'],
    "grant_type" : "password"
}

r = requests.post(url, data = authdata)
r.raise_for_status()
print(r)
result = json.loads(r.text)
token = result["access_token"]

f = open("%s/keycloak-realm.json" % os.path.dirname(__file__), "r")
realmdata = {} #json.loads(f.read())

realmdata['realm'] = sys.argv[1]
realmdata['enabled'] = True

print(json.dumps(realmdata))

headers = {
    "Authorization" : "Bearer %s" % token,
    "Content-Type": "application/json"
}

print(json.dumps(headers))

url = "https://%s/auth/admin/realms" % os.environ['AUTH_HOST']

print("Creating realm")

r = requests.post(url, headers=headers, data = json.dumps(realmdata))
r.raise_for_status()
print("DONE REQUEST")
print(r)
print(r.text)


