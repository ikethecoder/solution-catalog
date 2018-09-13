# Takes a list of service IDs and makes calls to docker to do a force remove

# Assumption: The service ID equals the docker ID

# python create-docker.py dockerImage live-app-01-oss-index 3001 3002

# Example: python create-docker.py oss-index-deploy live-app-01-oss-index 3001 3002

import sys
from subprocess import call

def exec_docker_create(dockerImage, idBase, port):
    try:
      id = "%s-%s" % (idBase,port)
      print("exec_docker_create %s" % call(["/usr/bin/docker", "create", "--name", id, "-p", "%s:80" % port, dockerImage]))
    except OSError as err:
      print("Caught OSError %s" % err)
      raise err

for x in range(3, len(sys.argv)):
    print "Argument %d is %s" % (x, sys.argv[x])
    exec_docker_create(sys.argv[1], sys.argv[2], sys.argv[x])
