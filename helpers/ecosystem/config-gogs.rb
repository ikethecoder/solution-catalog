require 'json'
require 'fileutils'
require 'commands/push-config'

ADDR = ENV['GOGS_ADDRESS']

config = "Host #{ADDR}\n   Port 10022"
File.write("/root/.ssh/config", config)

system("ssh-keyscan -p 10022 #{ADDR} >> ~/.ssh/known_hosts")

system("canzea --util=add-env ECOSYSTEM_CONFIG_GIT git@#{ADDR}:root/ecosystem.git")
