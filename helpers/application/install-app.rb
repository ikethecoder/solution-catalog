require 'json'
require 'net/http'
require_relative '../../roles/application/install-project'

parameters = JSON.parse(ARGV[0])

ip = InstallProject.new

ip.installExtended ENV['ARCHIVA_ADDRESS'], ENV['ARCHIVA_PORT'], "../../../maven-archiver/pom.properties", parameters

