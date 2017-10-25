require 'json'
require 'fileutils'
require 'template-runner'
require 'commands/push-config'

params = JSON.parse(ARGV[0])

pc = PushConfig.new

t = Template.new

template = "#{ENV['CATALOG_LOCATION']}/helpers/digitalocean/templates/dns.templ"

buffer = t.process template, params)

pc.write "terraform/#{params['domain']}.tf", buffer

pc.commit "terraform for #{params['domain']}"
