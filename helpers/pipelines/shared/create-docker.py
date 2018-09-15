# Takes a list of service IDs and makes calls to docker to do a creation

import sys
from subprocess import call

def exec_docker_create(dockerImage, idBase, internalPort, dockerArgs, port):
    try:
      id = "%s-%s" % (idBase,port)
      print("exec_docker_create %s" % call(["/usr/bin/docker", "create", "--name", id, "-p", "%s:%s" % (port,internalPort)] + dockerArgs.split(",") + [dockerImage]))
    except OSError as err:
      print("Caught OSError %s" % err)
      raise err

for x in range(5, len(sys.argv)):
    print "Argument %d is %s" % (x, sys.argv[x])
    exec_docker_create(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[x])
