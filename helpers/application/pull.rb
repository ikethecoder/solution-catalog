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

puts "Base URL #{sess.base_url}"

properties = JavaProperties.load(pomPropertiesFile)

groupId = properties[:groupId]
artifactId = properties[:artifactId]
version = properties[:version]

groupIdPath = groupId.tr(".","/")

url = "/repository/snapshots/#{groupIdPath}/#{artifactId}/#{version}/#{artifactId}-#{version}.jar"

puts url

resp = sess.get(url)

File.write("#{project}.zip", resp.body)

result = system "unzip #{project}.zip -d #{project}/site"
if (result == false)
    raise("Failed to unpackage assembly.")
end

