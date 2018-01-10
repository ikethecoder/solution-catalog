
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

parameters['pwd'] = Dir.pwd

ssh_config = %{
   host {{ecosystem}}.canzea.cc
     User root
     Port 10022
     IdentityFile {{pwd}}/sc/ecosystems/{{ecosystem}}/terraform/.es/id_rsa_root_ecosystem
}

FileUtils.mkdir_p "ssh"
File.write "ssh/config", t.processString(ssh_config, parameters)

pc.cp sourcePath, "."

pc.cp "sc/blueprints", "."

pc.write "ssh/config", t.processString(ssh_config, parameters)

pc.commit "Migrated to ecosystems repository."


FileUtils.cp_r "sc", "sc_bk"


g = Git.clone(ENV['ECOSYSTEM_CONFIG_GIT'], "sc_temp", :path => '.')

FileUtils.rm_r "sc"

FileUtils.mv "sc_temp", "sc"

FileUtils.mkdir_p "sc/ecosystems/#{parameters['ecosystem']}/terraform/.es"
FileUtils.cp_r "sc_bk/ecosystems/#{parameters['ecosystem']}/terraform/.es", "sc/ecosystems/#{parameters['ecosystem']}/terraform"
