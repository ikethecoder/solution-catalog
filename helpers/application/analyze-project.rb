# ruby t.rb '{"url":"https://gitlab.com/ikethecoder/hello-world-svc-app.git","branch":"master","name":"a"}'


require 'git'
require 'json'
require 'xmlsimple'
require 'java-properties'

parameters = JSON.parse(ARGV[0])

url = parameters['sourceRepo']
branch = parameters['branch']
name = parameters['name']

g = Git.clone(url, name, :branch => branch, :path => '.')

pom = XmlSimple.xml_in(name + "/pom.xml")

groupId = pom['groupId'][0]
artifactId = pom['artifactId'][0]
version = pom['version'][0]

content = {
  "type" => "java-maven",
  "groupId" => groupId,
  "artifactId" => artifactId,
  "version" => version
}
File.write("artifact-#{name}.json", JSON.generate(content))
