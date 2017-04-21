require 'json'
require 'canzea/registry'

parameters = JSON.parse(ARGV[0])

key = parameters['key']

r = Registry.new

puts r.getKeyValues(key)
