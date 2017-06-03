# canzea --config=../cli/config.json --lifecycle=wire --solution=terraform --action=generate --args='{"imagePaasId":"12321", "name":"abcd", "region":"nyc1"}'
# canzea --config=../cli/config.json --lifecycle=wire --solution=terraform --action=generate --args='{"imageCode":"EEED", "name":"abcd2", "region":"nyc1"}'

# canzea --config=config.json --lifecycle=wire --solution=terraform --action=generate --args='{"imagePaasId":"24485506", "name":"escd27-perf-app-1", "region":"nyc1"}'

require 'json'
require 'template-runner'
require 'canzea/config'
require 'canzea/registry'

parameters = JSON.parse(ARGV[0])

t = Template.new

#        {
#          "environment": "perf",
#          "product": "M4GB_D60GB",
#          "quantity": "1",
#          "provider": "DigitalOcean",
#          "segment": "app",
#          "region": "nyc1",
#          "imageCode": "centos-7-2-x64",
#          "imagePaasId": "24485506"
#        }

params = parameters

params['imageText'] = "\"image\""

if (parameters.has_key? "imagePaasId")
    params[:imageText] = parameters['imagePaasId'].to_i
else
    params[:imageText] = "\"#{parameters['imageCode']}\""
end

tfTemplate = "segment.tf.#{parameters['template']}.templ"

template = "#{ENV['CATALOG_LOCATION']}/helpers/terraform/templates/#{tfTemplate}"

outFile = "segment-#{parameters['name']}.tf"

t.processAndWriteToFile template, outFile, params
