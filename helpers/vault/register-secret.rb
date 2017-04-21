require 'json'
require 'template-runner'
require 'canzea/registry'

parameters = JSON.parse(ARGV[0])

key = parameters['key']

payload = parameters['data']

payload.each_pair do |k, v|
    payload[k] = Template.new.processString(v, {})
end

r = Registry.new

r.setSecret key, payload.to_json