require 'json'

# Comment
parameters = JSON.parse(ARGV[0])

puts "Hello RUBY"

puts "NAME = #{parameters['name']}"