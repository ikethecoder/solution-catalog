# ruby helpers/helper-run.rb rocketchat collaboration-new-channel '{"name":"test5"}'
require 'json'
require 'net/http'
require 'digest'
require 'zip'
require 'fileutils'

parameters = JSON.parse(ARGV[0])

name = parameters['name']

rootPath = SecureRandom.hex

Dir.mkdir rootPath

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
        File.write("#{rootPath}/#{outFile}", JSON.pretty_generate(content))

        sha256 = Digest::SHA256.file "#{rootPath}/#{outFile}"
        sha256.hexdigest
        puts "#{outFile} : #{sha256}"

        report.push( {
            "filename" => outFile,
            "group" => 'flows',
            "type" => flow['type'],
            "id" => flow['id'],
            "digest" => sha256
        })
    end

end


data = File.read("#{rootPath}/nr-tab-id-global.flow")

data = JSON.parse(data)

data['subflows'].each do | flow |
    fileName = "global-#{flow['type']}-#{clean(flow['name'])}.flow"
    File.write("#{rootPath}/#{fileName}", JSON.pretty_generate(flow))

    sha256 = Digest::SHA256.file "#{rootPath}/#{fileName}"
    sha256.hexdigest
    puts "#{fileName} : #{sha256}"

    report.push( {
        "filename" => fileName,
        "group" => 'subflows',
        "type" => flow['type'],
        "id" => flow['id'],
        "digest" => sha256
    })

end

data['configs'].each do | conf |
    if conf['name'] == nil
        fileName = "global-configs-#{clean(conf['type'])}.flow"
    else
        fileName = "global-configs-#{clean(conf['type'])}-#{clean(conf['name'])}.flow"
    end
    File.write("#{rootPath}/#{fileName}", JSON.pretty_generate(conf))

    sha256 = Digest::SHA256.file "#{rootPath}/#{fileName}"
    sha256.hexdigest
    puts "#{fileName} : #{sha256}"

    report.push( {
        "filename" => fileName,
        "group" => 'configs',
        "type" => conf['type'],
        "id" => conf['id'],
        "digest" => sha256
    })
end

File.write("#{rootPath}/global-configs.flow", JSON.pretty_generate(data['configs']))

File.write("#{rootPath}/global-report.json", JSON.pretty_generate(report))

Zip::File.open("flows-#{rootPath}.zip", Zip::File::CREATE) do |zip|
    Dir.foreach("#{rootPath}") { |file|
        if File.directory?(file) == false
            puts "Adding to zip: #{file}"
            name = File.basename file
            zip.add "#{name}", file
        end
    }
end

FileUtils.remove_dir(rootPath)