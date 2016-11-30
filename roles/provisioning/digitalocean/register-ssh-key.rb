require 'droplet_kit'
require 'json'

token=ENV["DIGITAL_OCEAN_API_KEY"]

client = DropletKit::Client.new(access_token: token)

file = File.open("id_rsa.pub", "rb")
pub_key = file.read

ssh_key = DropletKit::SSHKey.new(name: 'base.local', public_key: pub_key)

response = client.ssh_keys.create(ssh_key)

File.open('key-registration.json', 'w') { |file| file.write(response.to_json) }

