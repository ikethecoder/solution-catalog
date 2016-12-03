require 'json'

parameters = JSON.parse(ARGV[0])

role = parameters['role']
solution = parameters['solution']
gitRoot = parameters['gitRoot']

steps = {}

# write to configure the registration of the service
if (File.exists?("#{gitRoot}/configure.json"))
    steps = JSON.parse(File.read("#{gitRoot}/configure.json"))
else
    steps["steps"] = []
end

conf = {
    :role => role,
    :solution => solution
}
steps["steps"].push(conf)

File.open("#{gitRoot}/configure.json", 'w') { |file| file.puts(JSON.generate(steps)) }

