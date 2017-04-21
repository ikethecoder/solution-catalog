require 'json'
require 'template-runner'
require 'canzea/registry'

parameters = JSON.parse(ARGV[0])

key = parameters['key']

r = Registry.new

puts r.getSecret key