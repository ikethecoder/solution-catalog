require 'git'
require 'json'
require 'fileutils'
require 'commands/push-config'

pc = PushConfig.new

pc.write "gogs-check.md", "Check successful."

pc.commit "GOGS Check"