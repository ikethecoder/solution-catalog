require 'json'

class HugoProject

    def createDetails(branch, commitRevision, name)
        file = File.read("#{name}/package.json")
        package = JSON.parse(file)

        content = {
          "type" => "hugo",
          "name" => package['name'],
          "author" => package['author'],
          "version" => package['version'],
          "build_pipeline" => "#{package['name']}-#{branch}-build",
          "branch" => branch,
          "commitRevision" => commitRevision
        }
        File.write("artifact-#{name}.json", JSON.pretty_generate(content))
        puts JSON.pretty_generate(content)
    end
end
