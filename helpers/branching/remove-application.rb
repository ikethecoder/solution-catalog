# ruby helpers/helper-run.rb branching create '{"app":"hello-world-svc-app", "type":"patch", "url":"git@build.escca.canzea.cc:root/hello-world-svc-app.git"}'

require 'git'
require 'json'
require 'fileutils'
require_relative '../../init/registry.rb'
require_relative '../../init/trace-runner'

parameters = JSON.parse(ARGV[0])

n = RunnerWorker.new

r = Registry.new

app = parameters['name']

r.deleteDirectory('applications/' + app)
