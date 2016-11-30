require 'json'

parameters = JSON.parse(ARGV[0])

puts "Hello " + parameters['ecosystem']
