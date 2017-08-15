require 'json'
require 'canzea/registry'

extraConfig = Canzea::config[:config_location] + "/config.json"
if File.exists?(extraConfig)
    file = File.read(extraConfig)
    Canzea::configure JSON.parse(file)
end


parameters = JSON.parse(ARGV[0])

root = parameters['root']

key = parameters['key']
value = parameters['value']

r = Registry.new

r.deleteDirectory "#{root}/#{key}"
