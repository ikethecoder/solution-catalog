require 'json'
require 'fileutils'
require 'trace-runner'
require "canzea/config"

parameters = JSON.parse(ARGV[0])

name = parameters['name']
key = parameters['key']
folder = parameters['home']

n = RunnerWorker.new

n.run "(cd #{folder}; mkdir .ssh; rm -f .ssh/id_rsa_#{key}*; ssh-keygen -t rsa -f #{folder}/.ssh/id_rsa_#{key} -P ''; ssh-keygen -f #{folder}/.ssh/id_rsa.pub -e -m PKCS8 > #{folder}/.ssh/id_rsa.pem.pub)", 0, 0

n.run "(cd #{folder}; chown -R #{name}:#{name} .ssh)", 0, 0

