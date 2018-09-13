import requests
import os, sys, time, json
from subprocess import call

def exec_ls():
    try:
      print("%s" % call(["ls", "-l"]))
    except OSError as err:
      print("No big deal - caught %s" % err)
      raise err

gw_url = os.environ['GW_URL'] # https://esff51.canzea.net
token = os.environ['GW_TOKEN']

url = "%s/gw/api/health/oss-index" % gw_url
headers = {'Authorization': "Bearer %s" % token}

tagMatch = ["A"]

maxAttempts = 3
attempt = 1

matches = []

while True: 
    print("Attempt # %d" % attempt)

    response = requests.get(url, headers=headers)
    print(response)

    data = response.json()

    with open("payload.json", "w") as file:
      json.dump(data, file, sort_keys = True, indent = 4)

    countTotal = 0
    countUp = 0

    for item in data:

      match = False
      for tag in item['Service']['Tags']:
        print("Tag Match? %s: %s" % (tag,(tag in tagMatch)))
        if tag in tagMatch:
	  match = True
	  break

      if match:
          print(item['Service']['ID'])
          print("  %s" % item['Node']['Node'])
          print("  A: %s" % item['Service']['Address'])
          print("  P: %s" % item['Service']['Port'])
 
          for check in item['Checks']:
             if check['ServiceID'] == item['Service']['ID']:
               print("  Status: %s" % check['Status'])
	       countTotal = countTotal + 1
               if check['Status'] == 'passing':
                  countUp = countUp + 1
      else:
          print("Skipping %s" % item['Service']['ID'])

    print("Count=%d, Up=%d" % (countTotal,countUp))

    if countTotal == countUp and countTotal <> 0:
      break

    if attempt == maxAttempts:
      break

    time.sleep(5)

    attempt = attempt + 1

print("FINAL RESULT: Count=%d, Up=%d" % (countTotal,countUp))

if countTotal <> countUp or countTotal == 0:
    sys.exit(-1)

