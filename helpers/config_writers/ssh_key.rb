require 'json'
require 'fileutils'
require 'trace-runner'
require "canzea/config"
require 'commands/push-config'

params = JSON.parse(ARGV[0])

is_plus = (ARGV[1] == 'PLUS')

pc = PushConfig.new "/"

resourceId = params.keys[0]
properties = params[resourceId]

key = resourceId

path = "sc/ecosystems/#{ENV['ECOSYSTEM']}/terraform/.es"
# puts "Path #{File.expand_path(path)}"

n = RunnerWorker.new(false)

if is_plus
    if File.exists? "#{path}/id_rsa_#{key}"
        puts "Key already exists.  Reusing."
    else
        n.run "(ssh-keygen -q -t rsa -f id_rsa_#{key} -P ''; ssh-keygen -f id_rsa_#{key}.pub -e -m PKCS8 > id_rsa_#{key}.pem.pub)", 0, 0

        pc.write "terraform/.es/id_rsa_#{key}", File.read("id_rsa_#{key}")
        pc.write "terraform/.es/id_rsa_#{key}.pub", File.read("id_rsa_#{key}.pub")
        pc.write "terraform/.es/id_rsa_#{key}.pem.pub", File.read("id_rsa_#{key}.pem.pub")

        File.delete "id_rsa_#{key}"
        File.delete "id_rsa_#{key}.pub"
        File.delete "id_rsa_#{key}.pem.pub"

        FileUtils.chmod 0600, "sc/ecosystems/#{ENV['ECOSYSTEM']}/terraform/.es/id_rsa_#{key}"
    end
else
    pc.backupAndRemove "terraform/.es/id_rsa_#{key}"
    pc.backupAndRemove "terraform/.es/id_rsa_#{key}.pub"
end
