
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

f = open("%s/keycloak-client.json" % os.path.dirname(__file__), "r")
clientdata = json.loads(f.read())

clientdata['clientId'] = sys.argv[2]

clientdata['clientAuthenticatorType'] = 'client-secret'
clientdata['secret'] = os.environ['CLIENT_SECRET']

headers = {
    "Authorization" : "Bearer %s" % token,
    "Content-Type": "application/json"
}

url = "https://%s/auth/admin/realms/%s/clients" % (os.environ['AUTH_HOST'], sys.argv[1])

r = requests.post(url, headers=headers, data = json.dumps(clientdata))
r.raise_for_status()
print(r)
print(r.text)


