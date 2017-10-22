require 'git'
require 'json'
require 'fileutils'
require 'trace-runner'
require 'commands/push-config'

pc = PushConfig.new

params = JSON.parse(ARGV[0])

@log = Canzea::config[:logging_root] + '/audit.log'

s = StringIO.new

File.open(@log).each do | line |
    l = JSON.parse(line)
    l = l['message']

    if l.has_key? "context"
        if (l['task'] == "complete")
            s << "#{l['context']['solution'].ljust(20)} #{l['elapsed'].round(0).to_s.ljust(10)} : #{l['cmd']}\n"
        end
    end
end

pc.write "audit-execution-times.txt", s.string

pc.commit "audit report"


