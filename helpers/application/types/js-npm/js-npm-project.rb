require 'json'

class JavascriptProject

    def createDetails(name)
        file = File.read("#{name}/package.json")
        package = JSON.parse(file)

        content = {
          "type" => "js-npm",
          "name" => package['name'],
          "author" => package['author'],
          "version" => package['version']
        }
        File.write("artifact-#{name}.json", JSON.pretty_generate(content))
        puts JSON.pretty_generate(content)
    end
end
