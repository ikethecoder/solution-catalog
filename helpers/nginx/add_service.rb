require 'json'
require 'net/http'
require 'template-runner'

parameters = JSON.parse(ARGV[0])

// parameters: location and passthrough

t = Template.new

partConfig = t.process "helpers/nginx/templates/service.templ", parameters

sslConfig = File.read("/etc/nginx/conf.d/ssl.conf")

index = sslConfig.rindex '}'

sslConfig.insert index, partConfig

puts sslConfig