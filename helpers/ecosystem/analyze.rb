
require 'git'
require 'json'
require 'fileutils'
require 'trace-runner'
require 'commands/push-config'

parameters = JSON.parse(ARGV[0])

n = RunnerWorker.new true

folder = '/root'

n.run "(cd #{folder}; yum list > yum-list.txt)", 0, 0

n.run "(cd #{folder}; gem list > gem-list.txt)", 0, 0

es = ENV["ECOSYSTEM"]
hostname = ENV['HOSTNAME']

files = [
  {"file" => "gem-list.txt", "path" => "ecosystems/#{es}/instances/#{hostname}/gem-list.txt"},
  {"file" => "yum-list.txt", "path" => "ecosystems/#{es}/instances/#{hostname}/yum-list.txt"}
]

PushConfig.new.do ENV['ECOSYSTEM_CONFIG_GIT'], "Analyze", { "files" => files }