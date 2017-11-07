
require 'git'
require 'json'
require 'fileutils'
require 'trace-runner'
require 'commands/push-config'

parameters = JSON.parse(ARGV[0])

ENV['ECOSYSTEM'] = parameters['ecosystem']

sourcePath = parameters['sourcePath']

pc = PushConfig.new "/"

pc.cp sourcePath, "."

ssh_config = %{
    host es5ab5.canzea.cc
     User root
     Port 10022
     IdentityFile ./sc/ecosystems/instances/terraform/.es/id_rsa_root_ecosystem
}

pc.write "ssh/config", ssh_config

pc.commit "Migrated to ecosystems repository."
