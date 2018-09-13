# Takes a list of service IDs and makes calls to docker to do a force remove

# Assumption: The service ID equals the docker ID

# python register-service.py dockerImage live-app-01-oss-index 3001 3002

import sys
from subprocess import call
from string import Template
from HealthCheckLib import HealthCheck

check = HealthCheck()

def exec_prepare_docker_service(service, dockerContainer):
    try:
      file = open("docker.service.tmpl", "r")
      template = file.read()
      with open("/etc/systemd/system/multi-user.target.wants/%s.service" % service, "w") as file:
        s = Template(template)
        d = dict(service=service,dockerContainer=dockerContainer)
        file.write(s.substitute(d))
    except OSError as err:
      print("Caught OSError %s" % err)
      raise err

def exec_systemd_reload():
    try:
      print("exec_systemd_reload %s" % call(["systemctl", "daemon-reload"]))
    except OSError as err:
      print("Caught OSError %s" % err)
      raise err

def exec_systemd_start(service):
    try:
      print("exec_systemd_start %s" % call(["systemctl", "start", service]))
    except OSError as err:
      print("Caught OSError %s" % err)
      raise err

serviceIds = []

for x in range(3, len(sys.argv)):
    print "Argument %d is %s" % (x, sys.argv[x])
    serviceId = "%s-%s" % (sys.argv[2],sys.argv[x])
    dockerContainer = serviceId;
    exec_prepare_docker_service(serviceId, dockerContainer)
    exec_systemd_reload()
    exec_systemd_start(serviceId)
    serviceIds.append(serviceId)

check.runCheck ('passing', serviceIds)
