#
# python health-check.py critical ID1 ID2 ... IDn
import requests
import os, sys, time, json

class HealthCheck:

    def __init__(self):

      gw_url = os.environ['GW_URL'] # https://esff51.canzea.net
      token = os.environ['GW_TOKEN']

      self.url = "%s/gw/api/health/oss-index" % gw_url
      self.headers = {'Authorization': "Bearer %s" % token}

    def runCheck (self, statusMatch, argv):

        url = self.url

        headers = self.headers

        attempt = 1
        maxAttempts = 10
        while True:
            print("Attempt # %d" % attempt)

            response = requests.get(url, headers=headers)
            print(response)

            data = response.json()

            with open("payload.json", "w") as file:
              json.dump(data, file, sort_keys = True, indent = 4)

            countTotal = 0
            countMatched = 0

            print("Trying to match %s" % list(argv))

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

            print("Check Count=%d, %s=%d" % (countTotal,statusMatch,countMatched))

            if countTotal == countMatched and countTotal <> 0:
              break

            if attempt == maxAttempts:
              break

            time.sleep(5)

            attempt = attempt + 1

        print("FINAL RESULT: Count=%d, %s=%d" % (countTotal,statusMatch,countMatched))

        if countTotal <> countMatched or countTotal == 0:
            raise Exception('Failed health-check: Count=%d, %s=%d' % (countTotal,statusMatch,countMatched))
