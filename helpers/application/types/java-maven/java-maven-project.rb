require 'json'
require 'xmlsimple'
require 'java-properties'

class JavaMavenProject

    def createDetails(branch, commitRevision, name)
        pom = XmlSimple.xml_in(name + "/pom.xml")

        groupId = pom['groupId'][0]
        artifactId = pom['artifactId'][0]
        version = pom['version'][0]

        content = {
          "type" => "java-maven",
          "groupId" => groupId,
          "artifactId" => artifactId,
          "version" => version,
          "build_pipeline" => "#{artifactId}-#{branch}-build",
          "branch" => branch,
          "commitRevision" => commitRevision
        }

        if (pom.has_key? 'modules')
            mods = pom['modules']
            content['modules'] = mods[0]['module']
        end
        File.write("artifact-#{name}.json", JSON.pretty_generate(content))
        puts JSON.pretty_generate(content)
    end
end
