require 'json'
require 'net/http'
require 'template-runner'

parameters = JSON.parse(ARGV[0])

# parameters: location and passthrough

configFile = "/etc/nginx/conf.d/ssl.conf"
if parameters.has_key? 'config'
    configFile = parameters['config']
end

t = Template.new

template = "service.tmpl"

if (parameters.has_key? 'configFile')
    configFile = parameters['configFile']
end

if (parameters.has_key? 'template')
    template = parameters['template']
end
partConfig = t.process "#{ENV['CATALOG_LOCATION']}/helpers/nginx/templates/#{template}", parameters

sslConfig = File.read(configFile)

index = sslConfig.rindex '}'

sslConfig.insert index, partConfig

File.write(configFile, sslConfig)
