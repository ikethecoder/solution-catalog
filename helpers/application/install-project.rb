require 'git'
require 'fileutils'
require 'java-properties'
require 'patron'
require 'mustache'

class Template < Mustache
  self.template_file = "#{ENV['CATALOG_LOCATION']}/roles/application/conf/service.template"
end

class InstallProject
    def install (repoHost, repoPort, pomPropertiesFile)
        attributes = { "port" => 1888 }
        installExtended repoPost, repoPort, pomPropertiesFile, attributes
    end

    def installExtended (repoHost, repoPort, pomPropertiesFile, attributes)

        sess = Patron::Session.new
        sess.timeout = 10
        sess.base_url = "http://#{repoHost}:#{repoPort}"

        properties = JavaProperties.load(pomPropertiesFile)

        projectName = attributes['name']

        groupId = properties[:groupId]
        artifactId = properties[:artifactId]
        version = properties[:version]

        groupIdPath = groupId.tr(".","/")

        url = "/repository/snapshots/#{groupIdPath}/#{artifactId}/#{version}/#{artifactId}-#{version}.jar"

        puts url

        resp = sess.get(url)

        File.write("/opt/applications/#{projectName}-#{artifactId}-#{version}.jar", resp.body)

        # puts system "chown appuser:appuser /opt/applications/#{artifactId}-#{version}.jar"

        s = Template.new
        s[:jar] = "#{projectName}-#{artifactId}-#{version}.jar"
        s[:service] = "#{projectName}-#{artifactId}"
        s[:base] = "/opt/applications"
        s[:port] = attributes['port']

        File.write("/opt/applications/#{projectName}-#{artifactId}-#{version}.service", s.render)

        result = system "sudo /opt/canzea-utils/register_service.sh #{projectName}-#{artifactId} /opt/applications/#{projectName}-#{artifactId}-#{version}.service"
        if (result == false)
            raise("Failed registering service")
        end
    end
end

