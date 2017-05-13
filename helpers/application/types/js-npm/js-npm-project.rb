require 'json'

class JavascriptProject

    def createDetails(branch, commitRevision, name)
        file = File.read("#{name}/package.json")
        package = JSON.parse(file)

        content = {
          "type" => "js-npm",
          "name" => package['name'],
          "build_pipeline" => "#{package['name']}-#{branch}-build",
          "author" => package['author'],
          "version" => package['version'],
          "branch" => branch,
          "commitRevision" => commitRevision
        }
        File.write("artifact-#{name}.json", JSON.pretty_generate(content))
        puts JSON.pretty_generate(content)
    end
end
