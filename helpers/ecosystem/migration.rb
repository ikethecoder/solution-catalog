
require 'git'
require 'json'
require 'fileutils'
require 'trace-runner'
require 'template-runner'
require 'commands/push-config'

parameters = JSON.parse(ARGV[0])

ENV['ECOSYSTEM'] = parameters['ecosystem']

sourcePath = parameters['sourcePath']

t = Template.new
pc = PushConfig.new "/"

pc.cp sourcePath, "."

ssh_config = %{
   host {{ecosystem}}.canzea.cc
     User root
     Port 10022
     IdentityFile ./sc/ecosystems/{{ecosystem}}/terraform/.es/id_rsa_root_ecosystem
}

pc.write "ssh/config", t.processString(ssh_config, parameters)

pc.commit "Migrated to ecosystems repository."


FileUtils.cp_r "sc", "sc_bk"

FileUtils.rm_r "sc"

FileUtils.mkdir_p "sc/ecosystems/#{parameters['ecosystem']}/terraform/.es
FileUtils.cp_r "sc_bk/ecosystems/#{parameters['ecosystem']}/terraform/.es/id_rsa_root_ecosystem", "sc/ecosystems/#{parameters['ecosystem']}/terraform/.es/id_rsa_root_ecosystem"

g = Git.clone(ENV['ECOSYSTEM_CONFIG_GIT'], "sc", :path => '.')

