require 'json'
require 'digest'

parameters = JSON.parse(ARGV[0])

file = parameters['file']

data = JSON.parse(File.read(file))

def clean (a)
    a = a.clone
    a.gsub!(' / ', '-')
    a.gsub!(' ', '-')
    a.gsub!('_', '-')
    a.gsub!('.', '-')
    return a.downcase
end

data['subflows'].each do | flow |
    puts flow['type']
    puts flow['name']
    fileName = "global-#{flow['type']}-#{clean(flow['name'])}.flow"
    File.write(fileName, JSON.pretty_generate(flow))
    puts fileName
end

data['configs'].each do | conf |
    puts conf['type']
    puts conf['name']
    if conf['name'] == nil
        fileName = "global-configs-#{clean(conf['type'])}.flow"
    else
        fileName = "global-configs-#{clean(conf['type'])}-#{clean(conf['name'])}.flow"
    end
    File.write(fileName, JSON.pretty_generate(conf))
    puts fileName

    sha256 = Digest::SHA256.file fileName
    sha256.hexdigest
    puts sha256
end


File.write("global-configs.flow", JSON.pretty_generate(data['configs']))

# Do an MD5 checksum for each file; do a search in the library based on checksum
# If a match, then make a note of the version
# If not a match, then publish the new version, making a note of the version
