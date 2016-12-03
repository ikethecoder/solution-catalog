require 'json'
require 'template-runner'
require 'canzea/config'

class Builder
    def initialize (attributes)
        @attributes = attributes
        @t = Template.new
    end

    def required (envNames, attrNames)
        envNames.each { | a |
            if (ENV[a] == nil)
                raise "Missing environment variable #{a}"
            end
        }
        attrNames.each { | a |
            if (@attributes[a] == nil)
                raise "Missing attribute #{a}"
            end
        }
        return self
    end
    def base (name)
        @root = JSON.parse(@t.process "#{ENV['CATALOG_LOCATION']}/helpers/gocd/pipelines/fragment/#{name}.json", @attributes)
        return self
    end

    def output ()
        puts JSON.pretty_generate(@root)
        return self
    end

    def save (file)
        puts "Writing #{file}"
        File.write(file, JSON.pretty_generate(@root))
        return self
    end

    def add (path, template, localAttributes = @attributes)
        content = @t.process "#{ENV['CATALOG_LOCATION']}/helpers/gocd/pipelines/fragment/#{template}.json", localAttributes
        # puts content
        content = JSON.parse(content)
        start = find(path)
        index = start.push (content)
        @lastReference = "#{path}[#{start.size()-1}]"
        # puts @lastReference
        return self
    end

    def append (path, template, localAttributes = @attributes)
        return add "#{@lastReference}.#{path}", template, localAttributes
    end

    def appendAll (list)
        lastReference = @lastReference
        list.each { | item |
            add "#{lastReference}.#{item[0]}", item[1], item[2]
        }
        return self
    end

    def forEach (buildDefinition)
        return BuilderIterator.new(self, buildDefinition)
    end

    def getLastReference ()
        # puts "GET LAST REFERENCE #{@lastReference}"
        return @lastReference
    end

    def find (path)
        start = @root
        # puts "FINDING #{path}"
        path.split(".").each { | p |
            if (p.index('[') == nil)
                start = start[p]
            else
                qualifier = p[0..p.index('[')-1]
                start = start[qualifier]
                ind = Integer(p[p.index('[')+1, p.index(']')-p.index('[')-1])
                start = start[ind]
            end
        }
        # puts "RETURNING #{start}"
        return start
    end

end

class BuilderIterator
    def initialize (builder, buildDefinition)
        @builder = builder
        @buildDefinition = buildDefinition
        @t = Template.new
    end

    def add (path, template, templateAttributes = {})
        newContext = []
        @buildDefinition.each { | a |
            # puts a
            @builder.add path, template, evalAttributes(templateAttributes, a)
            newContext.push({:ref=>@builder.getLastReference(), :def=>a})
            # puts "DONE - #{newContext.size()}"
        }
        @context = newContext
        return self
    end

    def append (path, template, templateAttributes = {})
        newContext = []
        # puts "APPENDING #{@context.size()} #{path}"
        @context.each { | a |
            # puts a
            # puts "APPENDING(ADD) : #{a[:ref]}.#{path}"
            @builder.add "#{a[:ref]}.#{path}", template, evalAttributes(templateAttributes, a[:def])
            # puts "APPENDED... "
            newContext.push({:ref=>@builder.getLastReference(), :def=>a[:def]})
        }
        @context = newContext
        return self
    end

    def evalAttributes (templateAttributes, attributes)
        newSet = {}
        # puts templateAttributes
        templateAttributes.each { | key, value |
            # puts "#{key} = #{value}"
            p = @t.processString("#{value}", attributes)
            newSet[key] = p
        }
        # puts newSet
        return newSet;
    end

    def end()
        return @builder
    end
end