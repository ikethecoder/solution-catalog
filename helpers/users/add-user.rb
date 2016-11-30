require 'json'
require 'fileutils'
require 'trace-runner'
require "canzea/config"

parameters = JSON.parse(ARGV[0])

name = parameters['name']

folder = "/home/#{name}"

n = RunnerWorker.new

n.run "adduser -m #{name}", 0, 0

n.run "(cd #{folder}; mkdir .ssh; ssh-keygen -t rsa -f /home/#{name}/.ssh/id_rsa -P '')", 0, 0

n.run "(cd #{folder}; chown -R #{name}:#{name} .*)", 0, 0

