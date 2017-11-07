
require 'json'
require 'net/http'
require 'template-runner'

parameters = JSON.parse(ARGV[0])

configFile = "/etc/nginx/conf.d/ssl.conf"
if parameters.has_key? 'config'
    configFile = parameters['config']
end

t = Template.new

template = "ssl.tmpl"

partConfig = t.process "#{ENV['CATALOG_LOCATION']}/helpers/nginx/templates/#{template}", parameters

File.write(configFile, partConfig)

