require 'git'
require 'json'
require 'fileutils'
require 'trace-runner'
require 'commands/push-config'

pc = PushConfig.new

params = JSON.parse(ARGV[0])

f = "roles/#{params['ES_ROLE']}/#{params['ES_SOLUTION']}/metadata.json"

if File.exists?(f)
    pc.cp f, "#{params['ES_SOLUTION']}/metadata.json"
else
    puts "FileNotFound #{f}"
end

@log = Canzea::config[:logging_root] + '/audit.log'

buffer = []

File.open(@log).each do | line |
    l = JSON.parse(line)
    l = l['message']

    if l.has_key? "context"
        if (l['context']['role'] == params['ES_ROLE'] and l['context']['solution'] == params['ES_SOLUTION'])
            if (l['task'] == "complete" or l['task'] == "status")
                buffer.push (l)
            end
            if (l['task'] == "status")
                pc.write "#{params['ES_SOLUTION']}/status.json", JSON.pretty_generate(l)
            end
        end
    end
end

pc.write "#{params['ES_SOLUTION']}/#{@log}", JSON.pretty_generate(buffer)

pc.commit "#{params['ES_ROLE']}/#{params['ES_SOLUTION']} metadata"

