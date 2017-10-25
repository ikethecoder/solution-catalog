# canzea --config=../cli/config.json --lifecycle=wire --solution=terraform --action=generate --args='{"imagePaasId":"12321", "name":"abcd", "region":"nyc1"}'
# canzea --config=../cli/config.json --lifecycle=wire --solution=terraform --action=generate --args='{"imageCode":"EEED", "name":"abcd2", "region":"nyc1"}'

# canzea --config=config.json --lifecycle=wire --solution=terraform --action=generate --args='{"imagePaasId":"24485506", "name":"escd27-perf-app-1", "region":"nyc1"}'

require 'json'
require 'base64'
require 'fileutils'
require 'template-runner'
require 'canzea/config'
require 'canzea/registry'

parameters = JSON.parse(ARGV[0])

t = Template.new

params = parameters

output = ""
params['modules'].each do | mod |
    outputt << process template, {"module" => mod}
end

outFile = "modules.tf"

File.write(outFile, output)
