require 'git'
require 'fileutils'

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

