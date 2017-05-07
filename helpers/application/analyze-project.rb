# canzea --lifecycle=wire --solution=application --action=analyze-project --args='{"sourceRepo":"https://gitlab.com/ikethecoder/hello-world-svc-app.git","branch":"master","name":"a"}'


require 'git'
require 'json'
require 'xmlsimple'
require 'java-properties'
require 'canzea/registry'
require_relative 'types/java-maven/java-maven-project'
require_relative 'types/js-npm/js-npm-project'

parameters = JSON.parse(ARGV[0])

url = parameters['sourceRepo']
branch = parameters['branch']
name = parameters['name']

if (parameters.has_key? 'credential_resource')
    credentialResource = parameters['credential_resource']
    creds = Registry.new.getSecret credentialResource
end


g = Git.clone(url, name, :branch => branch, :path => '.')

if (File.exists? "#{name}/pom.xml")
    puts JavaMavenProject.new.createDetails name
elsif (File.exists? "#{name}/package.json")
    puts JavascriptProject.new.createDetails name
else
    raise "Unable to identify project type"
end
