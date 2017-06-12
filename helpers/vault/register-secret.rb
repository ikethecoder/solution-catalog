require 'json'
require 'template-runner'
require 'canzea/registry'


extraConfig = Canzea::config[:config_location] + "/config.json"
if File.exists?(extraConfig)
    file = File.read(extraConfig)
    Canzea::configure JSON.parse(file)
end

parameters = JSON.parse(ARGV[0])

key = parameters['key']

payload = parameters['data']

if (parameters.has_key? "file")
    file = parameters['file']
    value = File.read(file)
    payload = {"data" => value}
else
    payload.each_pair do |k, v|
        payload[k] = Template.new.processString(v, {})
    end
end

r = Registry.new

r.setSecret key, payload.to_json