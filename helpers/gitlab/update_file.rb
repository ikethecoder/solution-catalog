# ruby helpers/helper-run.rb gitlab update_file '{"node":"Integration-C-1", "root":"roles/configdb/consul/config","file":"/etc/systemd/system/multi-user.target.wants/consul.service"}'

require 'git'
require 'json'
require 'fileutils'
require_relative '../../init/registry.rb'
require_relative '../../init/trace-runner'
require_relative '../../init/template-runner'

parameters = JSON.parse(ARGV[0])

n = RunnerWorker.new

r = Registry.new

t = Template.new

node = parameters['node']
root = parameters['root']
file = parameters['file']

app = "configuration"

url = "git@#{ENV['GITLAB_ADDRESS']}:root/configuration.git"

branch = "master"

folder = "#{app}"

FileUtils.rm_rf(folder)

g = Git.clone(url, folder, :branch => branch, :path => '.')

path = File.expand_path("..", "/#{node}#{file}")

FileUtils.mkdir_p("#{folder}#{path}")

t.processAndWriteToFile "#{root}#{file}", "#{folder}/#{node}#{file}", parameters

g.add("#{node}#{file}")

if (g.status.changed.length > 0 || g.status.added.length > 0 || g.status.deleted.length > 0)
    g.commit('Updated configuration')
    g.push
end

FileUtils.rm_rf(folder)
