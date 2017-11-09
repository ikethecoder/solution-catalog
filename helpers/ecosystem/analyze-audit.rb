require 'git'
require 'json'
require 'fileutils'
require 'trace-runner'
require 'commands/push-config'

pc = PushConfig.new

params = JSON.parse(ARGV[0])

@log = Canzea::config[:logging_root] + '/audit.log'

buffer = []

File.open(@log).each do | line |
    l = JSON.parse(line)
    l = l['message']

    if l.has_key? "context"
        if (l['task'] == "complete")
            buffer.push (l)
        end
    end
end

pc.write "audit-report.txt", JSON.pretty_generate(buffer)

pc.commit "audit report"

