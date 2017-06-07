require 'json'
require 'net/http'

class DOClient

    def initialize (api = '/v2')
        @api = api
    end

    def post (type, payload)
        headers = {
          'Authorization' => "Bearer #{ENV['DIGITALOCEAN_TOKEN']}"
        }

        http = Net::HTTP.new("api.digitalocean.com",443)
        http.use_ssl = true
        res = http.post("#{@api}/#{type}", headers)

        if ( Integer(res.code) != 200 )
            puts res.body
            raise("POST #{type} failed")
        end

        content = JSON.parse(res.body)
        return content
   end
end