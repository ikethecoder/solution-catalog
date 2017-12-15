require 'json'
require 'commands/push-config'
require 'template-runner'
require 'trace-runner'


puts "Git Repository #{ENV['ECOSYSTEM_CONFIG_GIT']}"
puts "Ecosystem #{ENV['ECOSYSTEM']}"
puts "Hostname #{ENV['HOSTNAME']}"

pc = PushConfig.new

# Loop through the resources file and generate all the relevant content

json = JSON.parse(ARGV[0])

n = RunnerWorker.new(false)

begin
    json['resources'].each do | resource |
        rtype = resource.keys[0]

        resource[rtype].keys.each do | rid |
            puts rtype
            puts "   #{rid}"


            args = { rid => resource[rtype][rid] }

            n.run "ruby #{ENV['CATALOG_LOCATION']}/helpers/config_writers/#{rtype}.rb '#{args.to_json}' PLUS", 0, 0
        end


    end

rescue => exception
    puts "ERROR"
    puts exception

end
