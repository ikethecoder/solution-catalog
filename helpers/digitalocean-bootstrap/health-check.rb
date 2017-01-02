# ruby helpers/helper-run.rb digitalocean health-check '{"privateKey":"/var/go/.ssh/id_rsa_digitalocean","base":"Test","instances":1}'

require 'net/ssh'
require 'net/sftp'
require 'json'
require 'canzea/config'
require 'active_support/time'

parameters = JSON.parse(ARGV[0])

base=parameters['base']

privateKey=parameters['privateKey']

file = File.read("#{Canzea::config[:pwd]}/#{parameters['metadata']}")
response = JSON.parse(file)

success = false
for try in [0..10]
    begin

        index = 1
        response.each do |item|
            puts item['name']

            privateIp = nil
            publicIp = nil

            item['networks']['v4'].each do |net|
                if net['type'] == "private"
                    privateIp = net['ip_address']
                end
                if net['type'] == "public"
                    publicIp = net['ip_address']
                end
            end

            @hostname = publicIp
            @username = "root"

            File.open("#{Canzea::config[:pwd]}/vps-#{base}-#{index}.json", 'w') { |file| file.write(@hostname) }

            index = index + 1

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