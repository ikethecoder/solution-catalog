#
# python prepare-env-vars.py oss-index live-app-a-01-oss-index release 3001 3002 3003 3004

import requests
import os, sys, time, json
from subprocess import call
from GatewayLib import Gateway

dir_path = os.path.dirname(os.path.realpath(__file__))
os.chdir(dir_path)

service = sys.argv[1]
serviceIdPrefix = sys.argv[2]
newTag = sys.argv[3]

gw = Gateway()

data = gw.getServices()

serviceIds = []

output = {'services':[],'status':{},'ports':{},'all':[], 'up':[],'down':[]}

for x in range(4, len(sys.argv)):
    id = "%s-%s" % (serviceIdPrefix, sys.argv[x])
    serviceIds.append(id)
    output['ports'][id] = sys.argv[x]

if len(serviceIds)%2 == 1:
    raise Exception("List of ports must have an even number of ports")

for id in serviceIds:
    output['status'][id] = 'down'
    output['all'].append(id)

matchCount = 0

for item in data:
      match = False
      id = item['Service']['ID']

      if id not in serviceIds:
         continue

      tagValue = False
      for tag in item['Service']['Tags']:
         print("--- tag: %s" % tag)
         if tag.startswith(newTag):
            tagValue = tag.split('=')[0]

      print(item['Service']['ID'])
      print("  %s" % item['Node']['Node'])
      print("  A: %s" % item['Service']['Address'])
      print("  P: %s" % item['Service']['Port'])
      print("  T: %s" % tagValue)

      item['Service']['Name'] = item['Service']['Service']

      svc = item['Service']

      output['services'].append({
        'Service': item['Service']
      })

      matchCount = matchCount + 1

      critical = False

      for check in item['Checks']:
         if check['ServiceID'] == item['Service']['ID']:
           print("  Status: %s" % check['Status'])

           if check['Status'] <> 'passing':
               critical = True

      answer = 'up'
      if critical:
        answer = 'down'
      output['status'][id] = answer

perfectCount = len(serviceIds)/2
countA = 0
countB = 0
for i in range(0, perfectCount):
    id = serviceIds[i]
    print("Lookup %s" % id)
    if output['status'][id] == 'up':
        countA = countA + 1

for i in range(perfectCount, len(serviceIds)):
    id = serviceIds[i]
    if output['status'][id] == 'up':
        countB = countB + 1

if (countA <> 0 and countB <> 0):
    raise Exception("Unstable state.  Please fix before continuing.");

if ((countA == perfectCount and countB == 0) or (countB == perfectCount and countA == 0)):
    print("Perfect scenario.  Proceeding with preparation.");
    for i in range(0, perfectCount):
        id = serviceIds[i]
        answer = 'up'
        if countA == perfectCount:
          answer = 'down'
        output[answer].append(id)

    for i in range(perfectCount, len(serviceIds)):
        id = serviceIds[i]
        answer = 'up'
        if countB == perfectCount:
          answer = 'down'
        output[answer].append(id)

elif countA == 0 and countB == 0:

    print("Looks like the service is not up at all! So picking A as being up")
    for i in range(0, perfectCount):
       id = serviceIds[i]
       output['up'].append(id)
    for i in range(perfectCount, len(serviceIds)):
       id = serviceIds[i]
       output['down'].append(id)
elif ((countA == perfectCount) or (countB == perfectCount)):
    print("Almost perfect scenario - expecting one set to be completely down - but seems to be partially up!  Proceeding with preparation.");
    for i in range(0, perfectCount):
        id = serviceIds[i]
        answer = 'up'
        if countA == perfectCount:
          answer = 'down'
        output[answer].append(id)

    for i in range(perfectCount, len(serviceIds)):
        id = serviceIds[i]
        answer = 'up'
        if countB == perfectCount:
          answer = 'down'
        output[answer].append(id)

else:
    raise Exception("Unstable state.  Please fix before continuing (%s,%s,%s)." % (countA,countB,perfectCount));

with open("env.json", "w") as file:
  json.dump(output, file, sort_keys = True, indent = 4)

print(json.dumps(output, sort_keys = True, indent = 4))
