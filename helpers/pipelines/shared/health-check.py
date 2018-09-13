#
# python health-check.py critical ID1 ID2 ... IDn

# Example: python health-check.py passing live-app-a-01-oss-index 5555

import sys
from HealthCheckLib import HealthCheck

statusMatch = sys.argv[1]
servicePrefix = sys.argv[2]

check = HealthCheck()

argv = list(sys.argv)

serviceIds = []

for x in range(3, len(sys.argv)):
    print "Argument %d is %s" % (x, sys.argv[x])
    serviceId = "%s-%s" % (servicePrefix, sys.argv[x])
    serviceIds.append(serviceId)

check.runCheck(statusMatch, serviceIds)
