import sys
import json

print("Hello PYTHON")

print sys.argv[1]

parameters = json.loads(sys.argv[1])

print json.dumps(parameters, sort_keys=True,
                  indent=4, separators=(',', ': '))


