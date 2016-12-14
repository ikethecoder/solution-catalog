
require 'json'
require 'net/http'
parameters = JSON.parse(ARGV[0])

# curl -X PUT -d "{\"secret_shares\":1, \"secret_threshold\":1}" http://127.0.0.1:8200/v1/sys/init

payload = { "secret_shares" => 1, "secret_threshold" => 1 }

headers = {}

pemCert = File.read(ENV['VAULT_CLIENT_CERT'])
pemKey = File.read(ENV['VAULT_CLIENT_KEY'])

uri = URI.parse(ENV["VAULT_ADDR"] + '/v1/sys/init')
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.ca_file = ENV['VAULT_CACERT']
http.cert = OpenSSL::X509::Certificate.new(pemCert)
http.key = OpenSSL::PKey::RSA.new(pemKey)
http.verify_mode = OpenSSL::SSL::VERIFY_PEER
# http.set_debug_output($stdout)
http.ssl_version = :SSLv23
http = Net::HTTP.new(uri.request_uri)

res = http.put("/v1/sys/init", payload.to_json, headers)

puts res.body

if ( Integer(res.code) != 200 )
    puts res.code
    raise("Initialization of vault failed")
end
