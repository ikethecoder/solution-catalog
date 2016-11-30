#ruby helpers/helper-run.rb gitlab add_ssh_key '{"login":"Bing2", "password":"12345678", "title":"ecosystem", "key":"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2gFn2XBlk2ylL8svgYZZ+wOWeaR4j1aogousSGLYiCbmGZvz1kutwcSgCpu9LXwO75lXKF9cPwk3raUKWC0o5zfg7ckqgN6TtsfpBCVdFxhC8xKidZSgrA8/W2IIbX6QAdv2VOKR8QMKJfNiQCq9y3MoubvE4Mv7U3V4agWIzaH8bwf0aomQYTJOWYd8/iz3c1ks4YVuqTe7YBl15iQa4hv0uNeHkGVBI2/9HPwgjgXI1UhXuh+57QVa7+3d/DGiIeGf5RAHkmsCd8F/lQm6gmkB/trTddmq+ThVA7EX4qNnCMs0E6osIY4X+ZCz5u0Fsh+GwQ//WtUhs3UI1uudp root@build-a-1"}'

require 'json'
require 'net/http'

parameters = JSON.parse(ARGV[0])

# Get the authtoken and userId
uri = URI(ENV['GITLAB_URL'] + '/api/v3/session')

res = Net::HTTP.post_form(uri, 'login' => parameters['login'], 'password' => parameters['password'])

data = JSON.parse(res.body)

privateToken = data['private_token']

# Create User
headers = {
        'Content-Type' => 'application/json'
}
payload = {
        "key" => parameters['key'],
        "title" => parameters['title']
}
http = Net::HTTP.new(ENV['GITLAB_ADDRESS'], ENV['GITLAB_PORT'])
res = http.post("/api/v3/user/keys?private_token=#{privateToken}", payload.to_json, headers)

if ( Integer(res.code) != 201 )
    puts res.body
    raise("Adding user failed")
end
