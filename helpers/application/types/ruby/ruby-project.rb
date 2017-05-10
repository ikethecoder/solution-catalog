require 'json'
require 'find'

class RubyProject

    def createDetails(name)
        Find.find("#{name}") do |path|
            if (File.basename(path).end_with? ".gemspec")

                p = Gem::Specification.load("#{path}")

                content = {
                  "type" => "ruby",
                  "name" => p.name,
                  "author" => p.author,
                  "version" => p.version
                }
                File.write("artifact-#{name}.json", JSON.pretty_generate(content))
                puts JSON.pretty_generate(content)
            end
        end
    end
end
