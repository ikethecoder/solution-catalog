# ruby helpers/helper-run.rb branching create '{"app":"hello-world-svc-app", "type":"patch", "url":"git@build.escca.canzea.cc:root/hello-world-svc-app.git"}'

require 'git'
require 'json'
require 'fileutils'
require 'canzea/config'
require 'canzea/registry'

parameters = JSON.parse(ARGV[0])

r = Registry.new

app = parameters['name']

major = 1
minor = 0
patch = 0

r.setKeyValue('components', app + '/versioning/major', major)
r.setKeyValue('components', app + '/versioning/minor', minor)
r.setKeyValue('components', app + '/versioning/patch', patch)

# Gets incremented when we want a new minor
r.setKeyValue('components', app + '/versioning/releases/1/minor', 0)
r.setKeyValue('components', app + '/versioning/releases/1.0/patch', 0)

# hello-world-svc-app/
#   major/1
#   minor/1
#
# Any active release will get deployed
# 1.0 : Major release
#
# So there will be a 1.0 that will go all the way to production
# using Release
