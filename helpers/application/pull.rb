# canzea --lifecycle=wire --solution=application --action=install-app --args='{"type":"js-npm", "project":"console-ui","port":5505}'

require 'json'
require 'net/http'
require 'java-properties'
require 'patron'

parameters = JSON.parse(ARGV[0])

project = parameters['project']

repoHost = ENV['ARCHIVA_ADDRESS']
repoPort = ENV['ARCHIVA_PORT']
pomPropertiesFile = "maven-archiver/pom.properties"

sess = Patron::Session.new
sess.timeout = 10
sess.base_url = "http://#{repoHost}:#{repoPort}"

properties = JavaProperties.load(pomPropertiesFile)

branch = attributes['branch']
projectName = attributes['name']

groupId = properties[:groupId]
artifactId = properties[:artifactId]
version = properties[:version]

groupIdPath = groupId.tr(".","/")

url = "/repository/snapshots/#{groupIdPath}/#{artifactId}/#{version}/#{artifactId}-#{version}.jar"

puts url

resp = sess.get(url)

File.write("#{projectName}.zip", resp.body)

result = system "unzip #{projectName}.zip -d #{projectName}/site"
if (result == false)
    raise("Failed to unpackage assembly.")
end

