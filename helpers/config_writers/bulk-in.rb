require 'json'
require 'commands/push-config'
require 'template-runner'
require 'trace-runner'

pc = PushConfig.new

puts "Git Repository #{ENV['ECOSYSTEM_CONFIG_GIT']}"
puts "Ecosystem #{ENV['ECOSYSTEM']}"
puts "Hostname #{ENV['HOSTNAME']}"

# Loop through the resources file and generate all the relevant content

json = JSON.parse(ARGV[0])

n = RunnerWorker.new(false)

json['resources'].each do | resource |
    rtype = resource.keys[0]
    rid = resource[rtype].keys[0]
    puts rtype
    puts "   #{rid}"

    args = resource[rtype].to_json

    n.run "ruby #{rtype}.rb '#{args}'", 0, 0

end


pc.commit ("Resource update")


# ruby terraform_module.rb @samples/terraform_module.json
# ruby digitalocean_droplet.rb @samples/digitalocean_droplet.json