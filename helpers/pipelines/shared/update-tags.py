#
# python update-tags.py oss-index release B live-app-a-01-oss-index 3000 3001

import requests
import os, sys, time, json
from subprocess import call
from GatewayLib import Gateway

service = sys.argv[1]
newTag = sys.argv[2]
newTagId = sys.argv[3]
serviceIdPrefix = sys.argv[4]

gw = Gateway()

data = gw.getServices()

serviceIds = []

for x in range(5, len(sys.argv)):
    serviceIds.append("%s-%s" % (serviceIdPrefix, sys.argv[x]))

for item in data:
      match = False
      if item['Service']['ID'] not in serviceIds:
         continue

      newTags = []
      for tag in item['Service']['Tags']:
         print("--- tag: %s" % tag)
         if tag.startswith(newTag) == False:
            newTags.append(tag)

      print(item['Service']['ID'])
      print("  %s" % item['Node']['Node'])
      print("  A: %s" % item['Service']['Address'])
      print("  P: %s" % item['Service']['Port'])

      item['Service']['Name'] = item['Service']['Service']

      svc = item['Service']

      #svc['Tags'] = ['urlprefix-/oss-index strip=/oss-index']
      svc['Tags'] = newTags

      if newTag not in svc['Tags']:
          print("Appending %s=%s" % (newTag,newTagId))
          svc['Tags'].append("%s=%s" % (newTag,newTagId))

      id = item['Service']['ID']
      pl = {'service_discovery_service': {id: item['Service']}}

      print("Result = %s" % json.dumps(pl))
      gw.updateService (pl)
