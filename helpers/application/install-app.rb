# canzea --lifecycle=wire --solution=application --action=install-app --args='{"type":"js-npm", "project":"console-ui","port":5505}'

require 'json'
require 'net/http'
require 'template-runner'
require 'canzea/config'
require_relative 'install-project'

parameters = JSON.parse(ARGV[0])

project = parameters['project']

catalog = Canzea::config[:catalog_location]

# For static files, we need to update config file under NGINX
if (parameters['type'] == 'js-npm')

    t = Template.new
    t.processAndWriteToFile "#{catalog}/helpers/application/types/js-npm/nginx-service.conf", "nginx-service.conf", parameters


    result = system "sudo cp nginx-service.conf /etc/nginx/conf.d/#{project}.conf"

    if (result == false)
        raise("Failed registering service")
    end

    result = system "sudo nginx -s reload"
    if (result == false)
        raise("Failed reloading nginx")
    end

    ip = InstallProject.new

    ip.retrieveArtifact ENV['ARCHIVA_ADDRESS'], ENV['ARCHIVA_PORT'], "maven-archiver/pom.xml"

else
    ip = InstallProject.new

    ip.installExtended ENV['ARCHIVA_ADDRESS'], ENV['ARCHIVA_PORT'], "maven-archiver/pom.properties", parameters

end