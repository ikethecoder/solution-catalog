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

catalog = Canzea::config[:catalog_location]

t.processAndWriteToFile "#{catalog}/helpers/gocd/builders/assembly-docker.xml", "assembly.xml", config
t.processAndWriteToFile "#{catalog}/helpers/gocd/builders/pom.xml", "pom.xml", config

# canzea --lifecycle=wire --solution=gocd --action=prep-build

