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

#        {
#          "environment": "perf",
#          "product": "M4GB_D60GB",
#          "quantity": "1",
#          "provider": "DigitalOcean",
#          "segment": "app",
#          "region": "nyc1",
#          "imageCode": "centos-7-2-x64",
#          "imagePaasId": "24485506",
#          "patches": []
#        }

params = parameters

params['imageText'] = "\"image\""

patches = Base64.decode64(params['patches'])
params['patches'] = JSON.parse(patches)

if (parameters.has_key? "imagePaasId")
    params[:imageText] = parameters['imagePaasId'].to_i
else
    params[:imageText] = "\"#{parameters['imageCode']}\""
end

tfTemplate = "segment.tf.#{parameters['template']}.templ"

template = "#{ENV['CATALOG_LOCATION']}/helpers/terraform/templates/#{tfTemplate}"

if File.exist?(template) == false
    template = "#{ENV['CATALOG_LOCATION']}/helpers/terraform/templates/segment.tf.default.templ"
end

rootPath = "terraform/modules/#{params['environment']}"
FileUtils.mkdir_p(rootPath)

outFile = "#{rootPath}/segment-#{parameters['name']}.tf"
puts outFile

t.processAndWriteToFile template, outFile, params

# If provider.tf does not exist, add it

providerFile = "#{ENV['CATALOG_LOCATION']}/helpers/terraform/provider.tf"
t.processAndWriteToFile providerFile, 'terraform/provider.tf', params