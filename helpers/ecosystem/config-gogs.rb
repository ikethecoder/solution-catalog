require 'json'
require 'fileutils'
require 'commands/push-config'


system("canzea --util=add-env ECOSYSTEM_CONFIG_GIT git@165.227.87.135:root/ecosystem.git")

# result = exec("curl -q -v -u root:admin1admin http://165.227.87.135:10080/api/v1/users/root/tokens -X POST -d '{\"name\":\"gogs-2\"}' -H 'Content-Type: application/json'"

# token = JSON.parse(result)['sha1']

# puts token