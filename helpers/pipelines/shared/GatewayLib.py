import requests
import os, sys, time, json

class Gateway:

    def __init__(self):

      self.gw_url = os.environ['GW_URL'] # https://esff51.canzea.net
      token = os.environ['GW_TOKEN']

      self.url = "%s/gw/api/health/%s" % self.gw_url,os.environ['DEPLOY_ID']
      self.headers = {'Authorization': "Bearer %s" % token}

    def getServices (self):

        response = requests.get(self.url, headers=self.headers)
        print(response)

        return response.json()

    def updateService (self, pl):

        url = "%s/gw/api/service_tags" % self.gw_url

        response = requests.put(url, json=pl, headers=self.headers)
        print(response)
        print(response.text)
        print(response.json)

    def processPlusResources (self, file):
        file = open(file, "r")
        pl = json.loads(file.read())

        url = "%s/gw/api/bulk" % self.gw_url

        response = requests.post(url, json=pl, headers=self.headers)
        print(response)
        print(response.text)
        print(response.json)

    def processMinusResources (self, file):
        file = open(file, "r")
        pl = json.loads(file.read())

        url = "%s/gw/api/minus" % self.gw_url

        response = requests.post(url, json=pl, headers=self.headers)
        print(response)
        print(response.text)
        print(response.json)
