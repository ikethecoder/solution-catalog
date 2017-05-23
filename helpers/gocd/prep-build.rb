require 'json'
require 'net/http'
require 'canzea/config'
require 'template-runner'

parameters = JSON.parse(ARGV[0])

t = Template.new

file = File.read('package.json')
data = JSON.parse(file)

config = {
    "artifact" => data['name'],
    "group" => data['author'],
    "version" => data['version']
}

t.processAndWriteToFile "helpers/gocd/builders/assembly.xml" "assembly.xml" config
t.processAndWriteToFile "helpers/gocd/builders/pom.xml" "pom.xml" config

# canzea --lifecycle=wire --solution=gocd --action=prep-build

