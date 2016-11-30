# ruby helpers/helper-run.rb digitalocean deregister-ssh-key '{}'

require 'droplet_kit'
require 'json'

parameters = JSON.parse(ARGV[0])

token=ENV["DIGITAL_OCEAN_API_KEY"]

client = DropletKit::Client.new(access_token: token)

file = File.open("key-registration.json", "rb")
payload = file.read

ssh_key = JSON.parse(payload)

response = client.ssh_keys.delete(id:ssh_key['id'])

puts response.to_json
