# ruby helpers/helper-run.rb branching create '{"app":"hello-world-svc-app", "type":"patch", "url":"git@build.escca.canzea.cc:root/hello-world-svc-app.git"}'

require 'git'
require 'json'
require 'fileutils'
require 'registry'
require 'canzea/config'

extraConfig = Canzea::config[:config_location] + "/config.json"
if File.exists?(extraConfig)
    file = File.read(extraConfig)
    Canzea::configure JSON.parse(file)
end

parameters = JSON.parse(ARGV[0])

r = Registry.new

app = parameters['name']

major = 1
minor = 0
patch = 0

r.setKeyValue('applications', app + '/major', major)
r.setKeyValue('applications', app + '/minor', minor)
r.setKeyValue('applications', app + '/patch', patch)

# Gets incremented when we want a new minor
r.setKeyValue('applications', app + '/releases/1/minor', 0)
r.setKeyValue('applications', app + '/releases/1.0/patch', 0)

# hello-world-svc-app/
#   major/1
#   minor/1
#
# Any active release will get deployed
# 1.0 : Major release
#
# So there will be a 1.0 that will go all the way to production
# using Release
