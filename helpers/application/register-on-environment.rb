# ruby helpers/helper-run.rb application register-on-environment '{"name":"hello-world-svc-app", "version":"1.0.0", "deploy_environment":{"name":"Integration"}, "effectiveTimestamp":"2016-01-01 12:00:00+0800"}'

require 'git'
require 'json'
require 'fileutils'
require 'java-properties'
require_relative '../../init/registry.rb'
require_relative '../../init/trace-runner'

parameters = JSON.parse(ARGV[0])

n = RunnerWorker.new

r = Registry.new

app = parameters['name']

version = parameters['version']

#ip.installExtended ENV['ARCHIVA_ADDRESS'], ENV['ARCHIVA_PORT'], "../../../maven-archiver/pom.properties", parameters

r.register('applications', app + "/environments/#{parameters['deploy_environment']['name']}/version", version)
r.register('applications', app + "/environments/#{parameters['deploy_environment']['name']}/effectiveTimestamp", Time.now.getutc)


#        properties = JavaProperties.load(pomPropertiesFile)

#        groupId = properties[:groupId]
#        artifactId = properties[:artifactId]
#        version = properties[:version]


# Can make a call to get a keyvalue tree and returned to Canzea
# - use it to update the environments section
