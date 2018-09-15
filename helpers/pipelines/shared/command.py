# Takes a list of service IDs and makes calls to docker to do a force remove

# Assumption: The service ID equals the docker ID

# python command.py health-check up passing live-app-a-01-oss-index

import sys, os, json
from subprocess import call

dir_path = os.path.dirname(os.path.realpath(__file__))
os.chdir(dir_path)

label = os.environ['GO_PIPELINE_LABEL']

command = sys.argv[1]

portSet = sys.argv[2] # all, up, down

def exec_deploy_command(command, argv):
    try:
      cmd = ["sudo", "-E", "python", "%s.py" % command]
      cmd.extend(argv)
      exitCode = call(cmd)
      print("exec_deploy_command %s" % exitCode)
      if exitCode <> 0:
         raise Exception("Execution failure.")
    except OSError as err:
      print("Caught (command) OSError %s" % err)
      os.exit(1)

argv = []
for x in range(3, len(sys.argv)):
    argv.append(sys.argv[x])

file = open("env.json", "r")
env = json.loads(file.read())

print(json.dumps(env, sort_keys = True, indent = 4))

# Use the 'portSet' to determine which instances to include in the parameter list
if portSet in env:
  for serviceId in env[portSet]:
      port = env['ports'][serviceId]
      argv.append("%s" % port)

print(argv)
exec_deploy_command (command, argv)
