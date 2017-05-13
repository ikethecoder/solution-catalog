# canzea --lifecycle=wire --solution=application --action=copy-project --args='{"sourceRepo":"https://gitlab.com/ikethecoder/hello-world-svc-app.git","branch":"master","name":"a"}'

require 'json'
require 'git'
require 'fileutils'

parameters = JSON.parse(ARGV[0])

class CopyProject
    def copy (parameters, folder, projectName)

        url = parameters["url"]
        branch = parameters["branch"]

        FileUtils.rm_rf(folder)

        g = Git.clone(url, folder, :branch => branch, :path => '.')

        g.remote('origin').remove

        user = "root"
        pass = "admin1admin1"
        gitUrl = ENV['GITLAB_ADDRESS'] + ":" + ENV['GITLAB_PORT']
        r = g.add_remote('origin', "http://#{user}:#{pass}@#{gitUrl}/root/#{projectName}.git")

        g.add(:all=>true)

        g.push(remote = 'origin', branch = branch)

        FileUtils.rm_rf(folder)
    end
end

CopyProject.new.copy (parameters, "xyz", 'project1')
