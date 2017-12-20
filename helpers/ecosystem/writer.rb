require 'json'
require 'commands/push-config'
require 'template-runner'
require 'trace-runner'

pc = PushConfig.new "/'"

t = Template.new

puts "Git Repository #{ENV['ECOSYSTEM_CONFIG_GIT']}"
puts "Ecosystem #{ENV['ECOSYSTEM']}"
puts "Hostname #{ENV['HOSTNAME']}"

# Loop through the resources file and generate all the relevant content

parameters = JSON.parse(ARGV[0])


n = RunnerWorker.new(false)

contents = t.process "#{parameters['file']}", parameters

json = JSON.parse(contents)


json['resources'].each do | resource |
    rtype = resource.keys[0]
    rid = resource[rtype].keys[0]
    puts rtype
    puts "   #{rid}"

    args = {"files" => "resources/#{rtype}/#{rid}.es"}

    pc.write "resources/#{rtype}/#{rid}.es", JSON.pretty_generate(resource)
end


# pc.commit ("Resource update")

