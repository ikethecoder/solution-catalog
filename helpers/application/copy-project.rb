require 'json'
require 'net/http'
require_relative '../../roles/application/copy-project'
require_relative '../../roles/sourcecontrol/gitlab/bulk-setup-project'

parameters = JSON.parse(ARGV[0])

sp = SetupProject.new
sp.create parameters['name']

n = CopyProject.new
n.copy parameters, parameters['targetName'], parameters['name']


