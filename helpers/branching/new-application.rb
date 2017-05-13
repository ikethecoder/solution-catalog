# ruby helpers/helper-run.rb branching create '{"app":"hello-world-svc-app", "type":"patch", "url":"git@build.escca.canzea.cc:root/hello-world-svc-app.git"}'

require 'git'
require 'json'
require 'fileutils'
require 'canzea/config'
require 'canzea/registry'

parameters = JSON.parse(ARGV[0])

r = Registry.new

app = parameters['name']
version = parameters['version']
branch = parameters['branch']

r.setKeyValue('components', app + "/versioning/branch/#{branch}", version)

versionBits = version.split('.')

# Gets incremented when we want a new minor
r.setKeyValue('components', "#{app}/versioning/releases/#{versionBits[0]}/minor", versionBits[1])
r.setKeyValue('components', "#{app}/versioning/releases/#{versionBits[0]}.#{versionBits[1]}/patch", versionBits[2])

# hello-world-svc-app/
#   major/1
#   minor/1
#
# Any active release will get deployed
# 1.0 : Major release
#
# So there will be a 1.0 that will go all the way to production
# using Release
