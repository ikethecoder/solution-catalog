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

n = RunnerWorker.new(false)

if is_plus
    if File.exists? "id_rsa_#{key}"
        puts "Key already exists.  Reusing."
    else

        n.run "(openssl genpkey -algorithm RSA -out id_rsa_#{key} -pkeyopt rsa_keygen_bits:2048; openssl rsa -pubout -in id_rsa_#{key} -out id_rsa_#{key}.pub)", 0, 0

        pc.write "terraform/.es/id_rsa_#{key}", File.read("id_rsa_#{key}")
        pc.write "terraform/.es/id_rsa_#{key}.pub", File.read("id_rsa_#{key}.pub")

        File.delete "id_rsa_#{key}"

        FileUtils.chmod 0600, "sc/ecosystems/#{ENV['ECOSYSTEM']}/terraform/.es/id_rsa_#{key}"
    end
else
    pc.backupAndRemove "terraform/.es/id_rsa_#{key}"
    pc.backupAndRemove "terraform/.es/id_rsa_#{key}.pub"
end
