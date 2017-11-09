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
    file = Template.new.processString(file, {})
    value = File.read(file)
    payload = {"data" => value}
else
    payload.each_pair do |k, v|
        if v.is_a? String
            payload[k] = Template.new.processString(v, {})
        end
    end
end

r = Registry.new

r.setVaultRecord key, payload.to_json