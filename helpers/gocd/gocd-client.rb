require 'json'
require 'net/http'

class GoCDClient

    def initialize (api = '/go/api')
        @api = api
    end

    def findObject (version, type, name)
        headers = {
          'Content-Type' => 'application/json',
          'Accept' => "application/vnd.go.cd.v#{version}+json"
        }

        http = Net::HTTP.new("localhost",8153)
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
        headers = {
          'Accept' => "application/vnd.go.cd.v#{version}+json",
          'Content-Type' => 'application/json'
        }

        http = Net::HTTP.new("localhost",8153)
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

        headers = {
          'Accept' => "application/vnd.go.cd.v#{version}+json",
          'Content-Type' => 'application/json'
        }

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

   def patchObject (version, type, id, payload)

        file = File.open("#{type}-#{id}-etag.txt", "rb")
        etag = file.read

        headers = {
          'Accept' => "application/vnd.go.cd.v#{version}+json",
          'Content-Type' => 'application/json',
          'If-Match' => etag
        }

        http = Net::HTTP.new(ENV['GOCD_ADDRESS'], ENV['GOCD_PORT'])
        res = http.patch("#{@api}/#{type}/#{id}", payload.to_json, headers)

        if ( Integer(res.code) != 200 )
            puts res.body
            raise("Updating #{type} #{id} failed")
        end

   end
end
