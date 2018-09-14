require 'git'
require 'json'
require 'fileutils'
require 'trace-runner'
require 'commands/push-config'
require 'template-runner'

# canzea --lifecycle=wire --solution=ecosystem --action=config --args='{"source":"blocks/grafana/vm/config/grafana.ini","target":"/etc/grafana/grafana.ini","instanceId":"mon-mon-01","solution":"grafana"}'

params = JSON.parse(ARGV[0])

pc = PushConfig.new "instances/#{params['instanceId']}/"

source = params['source']
target = params['target']
# target = File.realpath(params['target'])
instanceId = params['instanceId']
solution = params['solution']

if File.exists? target
    # pc.cp target, target
end

t = Template.new

content = t.process(source, params)

File.write(target, content)

if params.has_key? "track" == false or params['track'] == true
    pc.write "config/#{solution}#{target}", content
    puts "Writing to: config/#{solution}#{target}"

    pc.commit "Tracking #{target}"
end
