require 'git'
require 'java-properties'
require 'fileutils'

require_relative '../../init/trace-runner'

class BuildProject
    def build (parameters, name, folder)
        url = parameters["url"]
        branch = parameters["branch"]

        g = Git.clone(url, folder, :branch => branch, :path => '.')

        r = RunnerWorker.new

        cmd = "cd #{folder}; export JAVA_HOME=/usr/java/jdk1.8.0_60; mvn install"

        r.run cmd, 1, 1, false

    end

    def buildAndDeploy (parameters, name, folder)

        url = parameters["url"]
        branch = parameters["branch"]
        mod = ""
        if defined? parameters["module"] and !parameters["module"].nil?
            mod = "#{parameters['module']}/"
        end

        g = Git.clone(url, folder, :branch => branch, :path => '.')

        r = RunnerWorker.new

        cmd = "cd #{folder}; export JAVA_HOME=/usr/java/jdk1.8.0_60; mvn install"
        r.run cmd, 1, 1, false

        properties = JavaProperties.load("#{folder}/#{mod}target/maven-archiver/pom.properties")

        artifactId = properties[:artifactId]
        version = properties[:version]

        jar = "#{artifactId}-#{version}.jar"

        cmd = "cd #{folder}; export JAVA_HOME=/usr/java/jdk1.8.0_60; mvn deploy:deploy-file -Durl=http://localhost:9080/repository/snapshots -Dfile=#{mod}target/#{jar} -DpomFile=#{mod}pom.xml -DrepositoryId=remote"
        r.run cmd, 1, 1, false

        cleanup (folder)
    end

    def cleanup (folder)
        FileUtils.rm_rf(folder)
    end

end