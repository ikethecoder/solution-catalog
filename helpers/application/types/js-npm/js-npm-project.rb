require 'json'

class JavascriptProject

    def createDetails(name)
        package = JSON.parse(name + "/package.json")

        content = {
          "type" => "js-npm",
          "name" => package['name'],
          "version" => package['version']
        }
        File.write("artifact-#{name}.json", JSON.pretty_generate(content))
        puts JSON.pretty_generate(content)
    end
end
