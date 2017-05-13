# canzea --lifecycle=wire --solution=application --action=copy-project --args='{"url":"https://gitlab.com/ikethecoder/hello-world-svc-app.git","branch":"master","name":"a"}'

# mkdir newproject.git
# cd newproject.git && git init --bare

# git clone git@localhost:/home/git/newproject.git
# cd newproject
# touch README.md
# git add README.md
# git commit -m "add README"
# git push -u origin master

# git clone --bare https://gitlab.com/ikethecoder/hello-world-svc-app.git

# cd hello-world-svc-app.git && git push --mirror git@localhost:/home/git/newproject.git

# cat /home/pm2user/.ssh/id_rsa.pub | ssh git@localhost "mkdir -p ~/.ssh && cat >>  ~/.ssh/authorized_keys"


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
