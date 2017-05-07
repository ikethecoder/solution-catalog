# canzea --lifecycle=wire --solution=application --action=analyze-project --args='{"sourceRepo":"https://gitlab.com/ikethecoder/hello-world-svc-app.git","branch":"master","name":"a"}'


require 'git'
require 'json'
require 'xmlsimple'
require 'java-properties'
require 'canzea/registry'
require_relative 'types/java-maven/java-maven-project'

parameters = JSON.parse(ARGV[0])

url = parameters['sourceRepo']
branch = parameters['branch']
name = parameters['name']

credentialResource = parameters['credential_resource']

creds = Registry.new.getSecret credentialResource
puts creds

g = Git.clone(url, name, :branch => branch, :path => '.')

if (File.exists? "#{name}/pom.xml")
    puts JavaMavenProject.new.createDetails name
else
    raise "Unable to identify project type"
end
