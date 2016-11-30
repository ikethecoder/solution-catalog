# ruby helpers/helper-run.rb digitalocean register-ssh-key '{"publicKey":"/var/go/.ssh/id_rsa_digitalocean.pub","name":"A"}'

require 'droplet_kit'
require 'json'

parameters = JSON.parse(ARGV[0])

token=ENV["DIGITAL_OCEAN_API_KEY"]

client = DropletKit::Client.new(access_token: token)

file = File.open(parameters['publicKey'], "rb")
pub_key = file.read

ssh_key = DropletKit::SSHKey.new(name: parameters['name'], public_key: pub_key)

response = client.ssh_keys.create(ssh_key)

File.open('key-registration.json', 'w') { |file| file.write(response.to_json) }

