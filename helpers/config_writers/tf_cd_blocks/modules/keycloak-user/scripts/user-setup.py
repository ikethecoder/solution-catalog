
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

# {"enabled":true,"attributes":{},"username":"bob2","emailVerified":""}
# {"type":"password","value":"joe","temporary":false}
userdata = {
    "enabled" : True,
    "username" : os.environ['USER_USERNAME'],
    "emailVerified" : "",
    "credentials" : [{
        "temporary" : False,
        "value" : os.environ['USER_PASSWORD'],
        "type" : "password"
    }]
}

headers = {
    "Authorization" : "Bearer %s" % token,
    "Content-Type": "application/json"
}

url = "https://%s/auth/admin/realms/%s/users" % (os.environ['AUTH_HOST'], os.environ['REALM'])

r = requests.post(url, headers=headers, data = json.dumps(userdata))
print(r)
print(r.text)
r.raise_for_status()


