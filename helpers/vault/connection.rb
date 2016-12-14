require 'json'
require 'net/http'

class Connection
    def prepareHttpPutConnection(path)
        pemCert = File.read(ENV['VAULT_CLIENT_CERT'])
        pemKey = File.read(ENV['VAULT_CLIENT_KEY'])

        uri = URI.parse(ENV["VAULT_ADDR"] + path)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.ca_file = ENV['VAULT_CACERT']
        http.cert = OpenSSL::X509::Certificate.new(pemCert)
        http.key = OpenSSL::PKey::RSA.new(pemKey)
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        # http.set_debug_output($stdout)
        http.ssl_version = :SSLv23
        return Net::HTTP::Put.new(uri.request_uri)
    end
end