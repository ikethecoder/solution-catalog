# ruby helpers/helper-run.rb rocketchat collaboration-new-channel '{"name":"test5"}'
require 'json'
require 'net/http'
require 'digest'

parameters = JSON.parse(ARGV[0])

name = parameters['name']

# Get the authtoken and userId
uri = URI(ENV['NODERED_URL'] + '/admin/auth/token')

res = Net::HTTP.post_form(uri , 'client_id' => 'node-red-admin', 'grant_type' => 'password', 'scope' => '*', 'username' => 'admin', 'password' => 'password')
puts res.body

data = JSON.parse(res.body)

authToken = data['access_token']

headers = {
  'Authorization' => "Bearer #{authToken}",
  'Node-RED-API-Version' => 'v2',
  'Content-Type' => 'application/json'
}

uri = URI(ENV['NODERED_URL'] + '/admin/flows')

http = Net::HTTP.new(uri.host, uri.port)
#http.use_ssl = true

res = http.get("#{uri.path}", headers)

if ( Integer(res.code) != 200 )
    puts res.body
    raise("Connection to NodeRed Failed")
end

def clean (a)
    a = a.clone
    a.gsub!(' / ', '-')
    a.gsub!(' ', '-')
    a.gsub!('_', '-')
    a.gsub!('.', '-')
    return a.downcase
end

report = []

content = JSON.parse(res.body)
content['flows'].push({"type" => "tab", "id" => "global"})

content['flows'].each do | flow |
    puts "FLOW: #{flow.to_s}"

    if (flow['type'] == 'tab')
        uri = URI(ENV['NODERED_URL'] + "/admin/flow/#{flow['id']}")

        http = Net::HTTP.new(uri.host, uri.port)
        #http.use_ssl = true

        res = http.get("#{uri.path}", headers)

        if ( Integer(res.code) != 200 )
            puts res.code
            puts res.body
            raise("Connection to NodeRed Failed")
        end

        content = JSON.parse(res.body)
        if flow['label'] == nil
            outFile = "nr-#{flow['type']}-id-#{flow['id']}.flow"
        else
            outFile = "nr-#{flow['type']}-#{clean(flow['label'])}.flow"
        end
        puts "Writing flow to #{outFile}"
        File.write(outFile, JSON.pretty_generate(content))

        sha256 = Digest::SHA256.file outFile
        sha256.hexdigest
        puts "#{outFile} : #{sha256}"

        report.push( {
            "filename" => outFile,
            "group" => 'flows',
            "type" => flow['type'],
            "id" => flow['id'],
            "digest" => sha256
        })

    else
        # outFile = "nf-#{flow['type']}-id-#{clean(flow['id'])}.flow"
        # puts "Writing #{flow['type']} to #{outFile}"
        # File.write(outFile, JSON.pretty_generate(flow))
    end

#    if (flow['type'] == 'subflow')
#
#        outFile = "nr-#{flow['type']}-#{flow['id']}.flow"
#        puts "Writing subflow to #{outFile}"
#        File.write(outFile, JSON.pretty_generate(flow))
#    end
#
end


data = File.read("nr-tab-id-global.flow")

data = JSON.parse(data)

data['subflows'].each do | flow |
    fileName = "global-#{flow['type']}-#{clean(flow['name'])}.flow"
    File.write(fileName, JSON.pretty_generate(flow))
end

data['configs'].each do | conf |
    if conf['name'] == nil
        fileName = "global-configs-#{clean(conf['type'])}.flow"
    else
        fileName = "global-configs-#{clean(conf['type'])}-#{clean(conf['name'])}.flow"
    end
    File.write(fileName, JSON.pretty_generate(conf))

    sha256 = Digest::SHA256.file fileName
    sha256.hexdigest
    puts "#{fileName} : #{sha256}"

    report.push( {
        "filename" => fileName,
        "group" => 'config',
        "type" => conf['type'],
        "id" => conf['id'],
        "digest" => sha256
    })
end

File.write("global-configs.flow", JSON.pretty_generate(data['configs']))

File.write("global-report.json", JSON.pretty_generate(report))