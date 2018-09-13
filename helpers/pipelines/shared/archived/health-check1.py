#
# python health-check.py critical ID1 ID2 ... IDn
import requests
import os, sys, time, json


class HealthCheck:

    gw_url = os.environ['GW_URL'] # https://esff51.canzea.net
    token = os.environ['GW_TOKEN']

    url = "%s/gw/api/health/oss-index" % gw_url
    headers = {'Authorization': "Bearer %s" % token}

    attempt = 1
    maxAttempts = 3

    def runCheck(statusMatch, argv):

        while True:
            print("Attempt # %d" % attempt)

            response = requests.get(url, headers=headers)
            print(response)

            data = response.json()

            with open("payload.json", "w") as file:
              json.dump(data, file, sort_keys = True, indent = 4)

            countTotal = 0
            countMatched = 0

            for item in data:
                if item['Service']['ID'] in argv:
                  print(item['Service']['ID'])
                  print("  %s" % item['Node']['Node'])
                  print("  A: %s" % item['Service']['Address'])
                  print("  P: %s" % item['Service']['Port'])

                  for check in item['Checks']:
                     if check['ServiceID'] == item['Service']['ID']:
                       print("  Status: %s" % check['Status'])
        	           countTotal = countTotal + 1
                       if check['Status'] == statusMatch:
                          countMatched = countMatched + 1
              else:
                  print("Skipping %s" % item['Service']['ID'])

            print("Check Count=%d, Match=%d" % (countTotal,countUp))

            if countTotal == countMatched and countTotal <> 0:
              break

            if attempt == maxAttempts:
              break

            time.sleep(5)

            attempt = attempt + 1

        print("FINAL RESULT: Count=%d, Up=%d" % (countTotal,countUp))

        if countTotal <> countUp or countTotal == 0:
            raise Exception('Failed health-check %s : Count=%d, Up=%d" % (statusMatch, countTotal,countUp))
