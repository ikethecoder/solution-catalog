require 'json'
require 'net/http'
require 'openssl'

class Connection
    def prepareHttpPutConnection()
        pemCert = File.read(ENV['VAULT_CLIENT_CERT'])
            pemKey = File.read(ENV['VAULT_CLIENT_KEY'])

        uri = URI.parse(ENV["VAULT_URL"])
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.ca_file = ENV['VAULT_CACERT']
        http.cert = OpenSSL::X509::Certificate.new(pemCert)
        http.key = OpenSSL::PKey::RSA.new(pemKey)
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        # http.set_debug_output($stdout)
        http.ssl_version = :SSLv23
        return http
    end
end