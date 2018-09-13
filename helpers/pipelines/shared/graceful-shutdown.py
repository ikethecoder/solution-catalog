# Takes a list of service IDs and makes calls to docker to do a force remove

# Assumption: The service ID equals the docker ID

# python graceful-shutdown.py live-app-01-oss-index 3001 3002

import sys, os
from subprocess import call
from HealthCheckLib import HealthCheck

check = HealthCheck()

def exec_systemd_disable(id):
    try:
      print("exec_systemd_disable %s" % call(["systemctl", "disable", id]))
    except OSError as err:
      print("Caught OSError %s" % err)
      raise err

def exec_systemd_stop(id):
    try:
      print("Stopping %s" % id)
      print("exec_systemd_stop %s" % call(["systemctl", "stop", id]))
    except OSError as err:
      print("Caught OSError %s" % err)
      raise err

def exec_deregister_service(service):
    try:
      os.remove('/etc/systemd/system/multi-user.target.wants/%s.service' % service)
    except OSError as err:
      pass

def exec_docker_remove(id):
    try:
      print("exec_docker_remove %s" % call(["/bin/sh", "-c", "/usr/bin/docker rm -f " + id + "", "||", "true"]))
    except OSError as err:
      print("Caught OSError %s" % err)
      raise err

def exec_docker_list():
    try:
      print("exec_docker_list %s" % call(["/usr/bin/docker", "ps"]))
    except OSError as err:
      print("Caught OSError %s" % err)
      raise err

serviceIds = []

for x in range(2, len(sys.argv)):
    print "Argument %d is %s" % (x, sys.argv[x])
    serviceId = "%s-%s" % (sys.argv[1],sys.argv[x])
    exec_systemd_stop(serviceId)
    exec_systemd_disable(serviceId)
    exec_deregister_service(serviceId)
    exec_docker_remove(serviceId)

    serviceIds.append(serviceId)

exec_docker_list()

check.runCheck ('critical', serviceIds)
