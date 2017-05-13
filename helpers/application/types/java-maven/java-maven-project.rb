require 'json'
require 'xmlsimple'
require 'java-properties'

class JavaMavenProject

    def createDetails(name)
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

        File.write("artifact-#{name}.json", JSON.pretty_generate(content))
        puts JSON.pretty_generate(content)
    end
end
