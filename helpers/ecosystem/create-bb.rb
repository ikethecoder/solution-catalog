#
# canzea --config=config.json --lifecycle=wire --solution=ecosystem --action=create-bb --args='{"role":"adhoc", "solution":"test", "docker_service": true}'
#
require 'json'
require 'fileutils'
require 'commands/push-config'
require 'template-runner'

parameters = JSON.parse(ARGV[0])

role = parameters['role']
solution = parameters['solution']

root = "#{ENV['CATALOG_LOCATION']}/roles/#{role}/#{solution}"

FileUtils.mkdir_p root

File.write "#{root}/install.sh", "# Install script for #{solution}"
File.write "#{root}/configure.sh", "# Configure script for #{solution}"

FileUtils.mkdir_p "#{root}/config"

metadata = {
  "name" => solution,
  "services" => []
}
File.write "#{root}/metadata.json", JSON.pretty_generate(metadata)

t = Template.new

if parameters.has_key? "docker_service"
  args = { "service" => solution }
  output = t.processString File.read("helpers/ecosystem/config/docker-service.tmpl"), args
  File.write "#{root}/config/docker.service", output
  
  open("#{root}/configure.sh", 'a') { |f|
    f.puts "\n"
    f.puts "yes | cp -f roles/#{role}/#{solution}/config/docker.service /etc/systemd/system/multi-user.target.wants/#{solution}.service\n"
    f.puts "systemctl daemon-reload\n"
    f.puts "systemctl restart #{solution}\n"
  }
end

puts "Building block created successfully at #{role}/#{solution}"

