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

# app = parameters['name']

#ip.installExtended ENV['ARCHIVA_ADDRESS'], ENV['ARCHIVA_PORT'], "../../../maven-archiver/pom.properties", parameters

pomPropertiesFile = "../../../maven-archiver/pom.properties"

properties = JavaProperties.load(pomPropertiesFile)

groupId = properties[:groupId]
artifactId = properties[:artifactId]
version = properties[:version]

environment = ENV['GO_ENVIRONMENT_NAME']

app = groupId + "/" + artifactId

r.register('applications', app + "/env/#{environment}" + "/version", version)
r.register('applications', app + "/env/#{environment}" + "/effectiveTimestamp", Time.now.getutc)

# Can make a call to get a keyvalue tree and returned to Canzea
# - use it to update the environments section
