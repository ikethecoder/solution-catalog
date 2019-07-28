require 'json'
require 'fileutils'
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

    resource[rtype].keys.each do | rid |
        puts rtype
        puts "   #{rid}"


        args = { rid => resource[rtype][rid] }

        if File.directory?("#{ENV['CATALOG_LOCATION']}/helpers/config_writers/#{rtype}")
            n.run "ruby #{ENV['CATALOG_LOCATION']}/helpers/config_writers/#{rtype}/writer.rb '#{args.to_json}' PLUS", 0, 0
        else
            n.run "ruby #{ENV['CATALOG_LOCATION']}/helpers/config_writers/#{rtype}.rb '#{args.to_json}' PLUS", 0, 0
        end
    end

end

pc.commit ("Resource update")
