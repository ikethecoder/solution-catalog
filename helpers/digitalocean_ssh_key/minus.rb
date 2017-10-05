# ruby helpers/helper-run.rb digitalocean register-ssh-key '{"publicKey":"/var/go/.ssh/id_rsa_digitalocean.pub","name":"A"}'

require 'droplet_kit'
require 'json'

parameters = JSON.parse(ARGV[0])

token=ENV["DIGITALOCEAN_TOKEN"]

client = DropletKit::Client.new(access_token: token)

file = File.open('key-registration.json', "rb")

pub_key = JSON.parse(file.read)

response = client.ssh_keys.delete(id: pub_key['id']);
