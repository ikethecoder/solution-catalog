require 'json'
require 'canzea/registry'

parameters = JSON.parse(ARGV[0])

root = parameters['root']

key = parameters['key']
value = parameters['value']

r = Registry.new

if (parameters.has_key? "values")
    values = parameters['values']
    values.each do |name, value|
        r.setKeyValue root, "#{key}/#{name}", value
    end
else
    if (parameters.has_key? "file")
        file = parameters['file']
        value = File.read(file)
    end

    r.setKeyValue root, key, value
end
