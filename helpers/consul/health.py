import requests
import os, sys, time
from subprocess import call

def exec_ls():
    try:
      print("%s" % call(["ls", "-l"]))
    except OSError as err:
      print("No big deal - caught %s" % err)
      raise err

gw_url = os.environ['GW_URL'] # https://esff51.canzea.net
token = os.environ['GW_TOKEN']

url = "%s/gw/api/health/console-ui" % gw_url
headers = {'Authorization': "Bearer %s" % token}

tagMatch = "A"
maxAttempts = 3;
attempt = 1;
countTotal = 0;
countUp = 0;

while attempt <= maxAttempts:
    print("Attempt # %d" % attempt)
    response = requests.get(url, headers=headers)
    print(response)
    data = response.json()

    for item in data:
      print(item['Service']['ID'])
      print("  %s" % item['Node']['Node'])

      for tag in item['Service']['Tags']:
        print("  Tag %s" % tag)

        if tag == tagMatch:
          countTotal = countTotal + 1

          for check in item['Checks']:

             if check['ServiceID'] == item['Service']['ID']:
               print("  Status: %s" % check['Status'])
               countTotal = countTotal + 1

               if check['Status'] == 'Passed':
                  countUp = countUp + 1

    print("Count=%d, Up=%d" % (countTotal,countUp))
    time.sleep(5)
    attempt = attempt + 1

print("FINAL RESULT: Count=%d, Up=%d" % (countTotal,countUp))
