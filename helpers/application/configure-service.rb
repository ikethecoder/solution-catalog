# canzea --lifecycle=wire --solution=application --action=install-app --args='{"type":"js-npm", "project":"console-ui","port":5505}'

require 'json'
require 'net/http'
require 'template-runner'
require 'canzea/config'
require_relative 'install-project'

parameters = JSON.parse(ARGV[0])

container = parameters['container']

catalog = ENV['CATALOG_LOCATION']

t = Template.new
t.processAndWriteToFile "#{catalog}/roles/application/conf/docker.service", "/opt/applications/static/#{container}/#{container}.service", parameters
