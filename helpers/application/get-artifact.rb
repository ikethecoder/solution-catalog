# canzea --lifecycle=wire --solution=application --action=install-app --args='{"type":"js-npm", "project":"console-ui","port":5505}'

require 'json'
require 'net/http'
require 'template-runner'
require 'canzea/config'
require_relative 'install-project'

parameters = JSON.parse(ARGV[0])

project = parameters['project']


ip = InstallProject.new

info = ip.retrieveArtifact ENV['ARCHIVA_ADDRESS'], ENV['ARCHIVA_PORT'], "maven-archiver/pom.xml"

