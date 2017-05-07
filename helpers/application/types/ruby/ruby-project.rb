require 'json'
require 'find'

class RubyProject

    def createDetails(name)
        Find.find("#{name}") do |path|
            if (path.ends_with? ".gemspec")
                package = Gem::Specification.load("#{name}/#{path}")

                content = {
                  "type" => "ruby",
                  "name" => package['name'],
                  "author" => package['author'],
                  "version" => package['version']
                }
                File.write("artifact-#{name}.json", JSON.pretty_generate(content))
                puts JSON.pretty_generate(content)
            end
        end
    end
end
