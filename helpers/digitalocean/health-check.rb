# ruby helpers/helper-run.rb digitalocean health-check '{"privateKey":"/var/go/.ssh/id_rsa_digitalocean","base":"Test","instances":1}'

require 'net/ssh'
require 'net/sftp'
require 'json'
require 'registry'
require 'canzea/config'

parameters = JSON.parse(ARGV[0])

r = Registry.new

base=parameters['base']
instances=Integer(parameters['instances'])
privateKey=parameters['privateKey']

ary = []
for i in 1..instances
    id = i.to_s.rjust(2, '0')
    ary.push("nodes/#{base}-#{id}")
end

success = false
for try in [0..10]
    begin
        for id in ary

            @hostname = r.getValue "#{id}", "public_ip"
            @username = "root"

            begin
                puts "Connecting health check ON " + @hostname

                Net::SSH.start(@hostname, @username, :paranoid => false, :keys => [privateKey]) do |ssh|
                    chan = ssh.open_channel do |channel|
                        channel.request_pty
                        channel.exec("ls") do |ch, success|
                            abort "could not execute command" unless success

                            channel.on_data do |ch, data|
                              puts "got stdout: #{data}"
                            end

                            channel.on_extended_data do |ch, type, data|
                              puts "got stderr: #{type} #{data}"
                            end

                            channel.on_close do |ch|
                              puts "channel is closing!"
                            end

                            channel.on_request("exit-status") do |ch, data|
                                exit_code = data.read_long
                                puts "Exiting with #{exit_code}"
                                if (exit_code != 0)
                                    abort("Failed")
                                end
                            end

                        end
                    end

                    chan.wait
                end
            rescue
                abort("Unable to connect to #{@hostname} using #{@username}")
            end
        end
        success = true
    rescue
        sleep(5.seconds)
    end
    if (success)
        break
    end
end
if (success == false)
    raise "Unable to confirm health of servers"
end