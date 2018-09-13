require 'json'
require 'net/http'
require 'base64'

class GoCDClient

    def initialize (api = '/go/api')
        @api = api
    end

    def findObject (version, type, name)
        headers = headers()

        http = Net::HTTP.new("#{ENV['GOCD_ADDRESS']}",8153)
        http.use_ssl = false
        res = http.get("#{@api}/#{type}", headers)

        if ( Integer(res.code) != 200 )
            puts res.body
            raise("Getting #{type} failed")
        end

        content = JSON.parse(res.body)

        content['_embedded']['agents'].each do | agent |
            puts agent['hostname']
            if (agent['hostname'] == name)
                File.write("#{type}-#{name}.json", JSON.pretty_generate(agent))
                return
            end
        end

        raise("Agent #{name} not found.")

   end

   def getObject(version, type, id)
        headers = headers()

        http = Net::HTTP.new("#{ENV['GOCD_ADDRESS']}",8153)
        http.use_ssl = false
        res = http.get("#{@api}/#{type}/#{id}", headers)

        if ( Integer(res.code) != 200 )
            puts res.body
            raise("Getting #{type} #{id} failed")
        end

        File.write("#{type}-#{id}.json", res.body)
        File.write("#{type}-#{id}-etag.txt", res['ETag'])

   end

   def retrieveObject (type, id)
        file = File.open("#{type}-#{id}.json", "rb")
        payload = file.read

        return JSON.parse(payload)
   end

   def postObject (version, type, payload)

        headers = headers()

        http = Net::HTTP.new(ENV['GOCD_ADDRESS'], ENV['GOCD_PORT'])
        res = http.post("#{@api}/#{type}", payload.to_json, headers)

        if ( Integer(res.code) != 200 )
            puts res.body
            raise("Creating #{type} failed")
        end

   end

   def putObject (version, type, id, payload)

        file = File.open("#{type}-#{id}-etag.txt", "rb")
        etag = file.read

        headers = headers()
        headers = {
          'Accept' => "application/vnd.go.cd.v#{version}+json",
          'Content-Type' => 'application/json',
          'If-Match' => etag
        }

        http = Net::HTTP.new(ENV['GOCD_ADDRESS'], ENV['GOCD_PORT'])
        res = http.put("#{@api}/#{type}/#{id}", payload.to_json, headers)

        if ( Integer(res.code) != 200 )
            puts res.body
            raise("Updating #{type} #{id} failed")
        end

   end


   def deleteObject (version, type, id)

        headers = headers()

        http = Net::HTTP.new(ENV['GOCD_ADDRESS'], ENV['GOCD_PORT'])
        res = http.delete("#{@api}/#{type}/#{id}", headers)

        if ( Integer(res.code) != 200 )
            puts res.body
            raise("Deleting #{type} #{id} failed")
        end

   end

   def patchObject (version, type, id, payload)

        file = File.open("#{type}-#{id}-etag.txt", "rb")
        etag = file.read

        headers = headers()
        headers['If-Match'] = etag

        http = Net::HTTP.new(ENV['GOCD_ADDRESS'], ENV['GOCD_PORT'])
        res = http.patch("#{@api}/#{type}/#{id}", payload.to_json, headers)

        if ( Integer(res.code) != 200 )
            puts res.body
            raise("Updating #{type} #{id} failed")
        end

   end

   def headers (version)
        cred = "sp_gocd_admin:#{ENV['SERVICE_GOCD_SP_GOCD_ADMIN_CREDENTIALS_PASSWORD']}"

        puts "CRED_B: #{cred}"
        cred = Base64.encode64(cred)
        puts "CRED_A: Basic: #{cred}"
        headers = {
          'Accept' => "application/vnd.go.cd.v#{version}+json",
          'Content-Type' => 'application/json',
          'Authorization' => "Basic: #{cred}"
        }
        return headers
   end
end
