require 'json'
require 'net/http'
require 'template-runner'

parameters = JSON.parse(ARGV[0])

# parameters: location and passthrough

configFile = "/etc/nginx/conf.d/ssl.conf"

t = Template.new

partConfig = t.process "helpers/nginx/templates/service.tmpl", parameters

sslConfig = File.read(configFile)

index = sslConfig.rindex '}'

sslConfig.insert index, partConfig

File.write(configFile, sslConfig)
