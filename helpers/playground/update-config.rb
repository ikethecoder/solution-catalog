require 'json'

parameters = JSON.parse(ARGV[0])

role = parameters['role']
solution = parameters['solution']
gitRoot = parameters['gitRoot']

# write to configure the registration of the service
if (File.exists?("#{gitRoot}/configure.sh") == false)
    File.open("#{gitRoot}/configure.sh", 'a') { |file| file.puts("#!/bin/bash") }
end

File.open("#{gitRoot}/configure.sh", 'a') { |file| file.puts("canzea --lifecycle=configure --role=#{role} --solution=#{solution}") }
