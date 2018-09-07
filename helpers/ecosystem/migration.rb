
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
   host {{fqdn}}
     User esadmin
     Port 11022
     IdentityFile {{pwd}}/sc/ecosystems/{{ecosystem}}/terraform/.es/id_rsa_esadmin_ecosystem
}

FileUtils.mkdir_p "ssh"
File.write "ssh/config", t.processString(ssh_config, parameters)

n = RunnerWorker.new(false)
n.run "ssh-keyscan -p 11022 #{parameters['fqdn']} > known_hosts", 0, 0

pc.cp sourcePath, "."

pc.write "ssh/known_hosts", File.read("known_hosts")

pc.write "ssh/config", t.processString(ssh_config, parameters)

pc.commit "Migrated to ecosystems repository."



FileUtils.cp_r "sc", "sc_bk"


g = Git.clone(ENV['ECOSYSTEM_CONFIG_GIT'], "sc_temp", :path => '.')

FileUtils.rm_r "sc"

FileUtils.mv "sc_temp", "sc"

FileUtils.mkdir_p "sc/ecosystems/#{parameters['ecosystem']}/terraform/.es"
FileUtils.cp_r "sc_bk/ecosystems/#{parameters['ecosystem']}/terraform/.es", "sc/ecosystems/#{parameters['ecosystem']}/terraform"
