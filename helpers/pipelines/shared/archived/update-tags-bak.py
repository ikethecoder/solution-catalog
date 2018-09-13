import requests
import os, sys, time, json
from subprocess import call

service = sys.argv[1]
tag = sys.argv[2]

gw_url = os.environ['GW_URL'] # https://esff51.canzea.net
token = os.environ['GW_TOKEN']

url = "%s/gw/api/services" % gw_url
headers = {'Authorization': "Bearer %s" % token}

response = requests.get(url, headers=headers)
print(response)

data = response.json()

tagMatch = ["release=A","release=B"]

for id in data.keys():
   item = data[id]
   if item['Service'] == service:
     print(item['Service'])
     print(item['ID'])

     for tag in item['Tags']:
       print("--- tag: %s" % tag)

     if tag not in item['Tags']:
       print("--- ADDING TAG %s" % tag)


     pl = {'resources': [{'service_discovery_service': {id: {'Name':item['Service']}}}]}

     print("Result = %s" % json.dumps(pl))
     url = "%s/gw/api/check" % gw_url
     headers = {'Authorization': "Bearer %s" % token, 'Accept': "application/json"}
     response = requests.post(url, json=pl, headers=headers)
     print(response)
     print(response.text)
     print(response.json)

