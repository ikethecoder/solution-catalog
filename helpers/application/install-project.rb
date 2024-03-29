require 'git'
require 'fileutils'
require 'java-properties'
require 'patron'
require 'mustache'
require 'crack/xml'

class InstallProject
    def install (repoHost, repoPort, pomPropertiesFile)
        attributes = { "port" => 1888 }
        installExtended repoPost, repoPort, pomPropertiesFile, attributes
    end


    def retrieveArtifact (repoHost, repoPort, pomXmlFile)
        hash = Crack::XML.parse(File.read(pomXmlFile))

        # Get the project, artifact, version details from the pom.xml
        # And use that to get the artifact.



        sess = Patron::Session.new
        sess.timeout = 10
        sess.base_url = "http://#{repoHost}:#{repoPort}"

        # properties = JavaProperties.load(pomPropertiesFile)
        properties = hash['project']

        projectName = properties['artifactId']

        groupId = properties['groupId']
        artifactId = properties['artifactId']
        version = properties['version']

        groupIdPath = groupId.tr(".","/")

        url = "/repository/snapshots/#{groupIdPath}/#{artifactId}/#{version}/#{artifactId}-#{version}-bin.zip"

        puts url

        resp = sess.get(url)

        File.write("/opt/applications/#{projectName}-#{artifactId}-#{version}.zip", resp.body)

        result = system "yes | rm -rf /opt/applications/static/#{projectName}"
        if (result == false)
            raise("Failed registering service")
        end

        result = system "mkdir -p /opt/applications/static/#{projectName} && unzip /opt/applications/#{projectName}-#{artifactId}-#{version}.zip -d /opt/applications/static/#{projectName}"
        if (result == false)
            raise("Failed registering service")
        end

        result = system "cp -r /opt/applications/static/#{projectName}/#{artifactId}-#{version}/* /opt/applications/static/#{projectName}/."
        if (result == false)
            raise("Failed registering service")
        end

        return {
            "staticPath" => "/opt/applications/static/#{projectName}"
        }
    end

    def installExtended (repoHost, repoPort, pomPropertiesFile, attributes)

        sess = Patron::Session.new
        sess.timeout = 10
        sess.base_url = "http://#{repoHost}:#{repoPort}"

        properties = JavaProperties.load(pomPropertiesFile)

        branch = attributes['branch']
        projectName = attributes['name']

        groupId = properties[:groupId]
        artifactId = properties[:artifactId]
        version = properties[:version]

        groupIdPath = groupId.tr(".","/")

        url = "/repository/snapshots/#{groupIdPath}/#{artifactId}/#{version}/#{artifactId}-#{version}.jar"

        puts url

        resp = sess.get(url)

        File.write("/opt/applications/#{projectName}-#{branch}.jar", resp.body)

        # puts system "chown appuser:appuser /opt/applications/#{artifactId}-#{branch}.jar"

        s = Template.new

        attrs = {
            "jar" => "#{projectName}-#{branch}.jar",
            "service" => "#{projectName}",
            "base" => "/opt/applications",
            "port" => attributes['port'],
            "env" => attributes['env'],
            "custom" => attributes['custom']
        }

        # File.write("/etc/systemd/system/multi-user.target.wants/#{projectName}-#{artifactId}-#{branch}.service", s.render)
        File.write("/opt/applications/#{projectName}-#{branch}.service", s.process("#{ENV['CATALOG_LOCATION']}/roles/application/conf/service.template", attrs))

    end
end

