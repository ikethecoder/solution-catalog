# canzea --lifecycle=wire --solution=application --action=analyze-project --args='{"sourceRepo":"https://gitlab.com/ikethecoder/hello-world-svc-app.git","branch":"master","name":"a"}'


require 'git'
require 'json'
require 'xmlsimple'
require 'java-properties'
require 'fileutils'
require 'canzea/registry'
require_relative 'types/java-maven/java-maven-project'
require_relative 'types/js-npm/js-npm-project'
require_relative 'types/ruby/ruby-project'

parameters = JSON.parse(ARGV[0])

url = parameters['sourceRepo']
branch = parameters['branch']
name = parameters['name']

if (parameters.has_key? 'credential_resource')
    credentialResource = parameters['credential_resource']
    creds = Registry.new.getSecret credentialResource
end

if (File.exists? name)
    FileUtils.remove_dir(name)
end

if (parameters.has_key? 'branch')
    g = Git.clone(url, name, :branch => branch, :path => '.')
else
    g = Git.clone(url, name, :path => '.')
end

if (File.exists? "#{name}/pom.xml")
    puts JavaMavenProject.new.createDetails name
elsif (File.exists? "#{name}/package.json")
    puts JavascriptProject.new.createDetails name
elsif (File.exists? "#{name}/Rakefile")
    puts RubyProject.new.createDetails name
else
    raise "Unable to identify project type"
end
