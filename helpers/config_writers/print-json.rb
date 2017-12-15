require 'json'

parameters = JSON.parse(ARGV[0])

puts "READING #{parameters['file']}"
puts JSON.generate(JSON.parse(File.read(parameters['file'])))
