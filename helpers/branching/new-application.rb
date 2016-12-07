# ruby helpers/helper-run.rb branching create '{"app":"hello-world-svc-app", "type":"patch", "url":"git@build.escca.canzea.cc:root/hello-world-svc-app.git"}'

require 'git'
require 'json'
require 'fileutils'
require_relative '../../init/registry.rb'
require_relative '../../init/trace-runner'

parameters = JSON.parse(ARGV[0])

n = RunnerWorker.new

r = Registry.new

app = parameters['name']

major = 1
minor = 0
patch = 0

r.register('applications', app + '/major', major)
r.register('applications', app + '/minor', minor)
r.register('applications', app + '/patch', patch)

# Gets incremented when we want a new minor
r.register('applications', app + '/releases/1/minor', 0)
r.register('applications', app + '/releases/1.0/patch', 0)

# hello-world-svc-app/
#   major/1
#   minor/1
#
# Any active release will get deployed
# 1.0 : Major release
#
# So there will be a 1.0 that will go all the way to production
# using Release
