require 'json'
require 'template-runner'

parameters = JSON.parse(ARGV[0])
t = Template.new

puts t.process parameters['file'], parameters
