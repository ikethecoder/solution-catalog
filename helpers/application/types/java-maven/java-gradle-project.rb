require 'json'

class JavaGradleProject

    def createDetails(branch, commitRevision, name)

        groupId = "gradle.project"
        artifactId = name
        version = "0.0.0"

        content = {
          "type" => "java-gradle",
          "groupId" => groupId,
          "artifactId" => artifactId,
          "version" => version,
          "build_pipeline" => "#{artifactId}-#{branch}-build",
          "branch" => branch,
          "commitRevision" => commitRevision
        }

        File.write("artifact-#{name}.json", JSON.pretty_generate(content))
        puts JSON.pretty_generate(content)
    end
end
