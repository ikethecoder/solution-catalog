require 'yaml'
require 'json'
require 'canzea/config'

# Make sure the blueprint instructions map to the definition

parameters = JSON.parse(ARGV[0])

blueprint = parameters['blueprint']

puts "blueprint #{blueprint}"

definition = JSON.parse(File.read("#{ENV['CATALOG_LOCATION']}/blueprints/#{blueprint}/#{blueprint}.json"))

data = YAML.load(File.read("#{ENV['CATALOG_LOCATION']}/blueprints/#{blueprint}/instruction.yml"))

missing = []

segments = data["instructions"]["segments"]

segments.each { | segmentId, segment |
    image = segment['image']

    image.each { | key |
        if (key.start_with?("step:"))
            puts key
            aDetail = key.split(':')
            buildDef = {"role"=>aDetail[1],"solution"=>aDetail[2]}
            solution = buildDef["solution"]

            # Find in blueprint
            found = false
            definition["nodes"].each { | node |
                if (node['name'] == solution)
                    found = true
                end
            }
            if (found == false)
                if (!missing.exists?(solution))
                    missing.push(solution)
                end
                puts("Missing #{solution} in blueprint definition")
            end
        end
    }
}

missing.each { | i |
    puts "NOT FOUND IN BLUEPRINT! [ #{i} ]"
}
