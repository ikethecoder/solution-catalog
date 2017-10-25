require 'json'
require 'fileutils'
require 'commands/push-config'

params = JSON.parse(ARGV[0])

pc = PushConfig.new

buffer = File.read("#{ENV['CATALOG_LOCATION']}/helpers/digitalocean/templates/dns.templ")

pc.write "terraform/#{params['domain'].tf", buffer

pc.commit "terraform"

