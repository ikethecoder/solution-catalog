
require 'git'
require 'json'
require 'fileutils'
require 'trace-runner'

parameters = JSON.parse(ARGV[0])

n = RunnerWorker.new

folder = '/root'

n.run "(cd #{folder}; yum list > yum-list.txt)", 0, 0
