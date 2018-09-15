#
# python plus-service-discovery-service.py oss-index 192.158.0.1 live-app-a-01-oss-index 3000 3001

import requests
import os, sys, time, json
from string import Template
from subprocess import call
from GatewayLib import Gateway

service = sys.argv[1]
ip = sys.argv[2]
servicePrefix = sys.argv[3]
healthPath = sys.argv[4]

gw = Gateway()

def exec_process_resources(file):
    # Submit the resources to the Gateway
    gw.processPlusResources(file)

def exec_prepare_resource_set(service, ports, parameters):
    try:
      file = open("s_d_s.json.tmpl", "r")
      template = file.read()
      resources = {'resources':[]}

      with open("%s.service" % service, "w") as file:
        for port in ports:
            parameters['PORT'] = port
            s = Template(template)
            js = json.loads(s.substitute(parameters))
            resources['resources'].append(js)

        json.dump(resources, file, sort_keys = True, indent = 4)

    except OSError as err:
      print("Caught OSError %s" % err)
      raise err

# Read the s_d_s.json.tmpl and loop through all the ports that we want to handle
ports = []
parameters = {
    'SERVICE': service,
    'SERVICE_PREFIX': servicePrefix,
    'SITE': '',
    'RELEASE': 'release-A',
    'PRIVATE_IP':ip,
    'PATH': healthPath
}
for x in range(5, len(sys.argv)):
    ports.append(sys.argv[x])

exec_prepare_resource_set (service, ports, parameters)
exec_process_resources ("%s.service" % service)
