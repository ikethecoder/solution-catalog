# ruby helpers/helper-run.rb branching finish '{"app":"hello-world-svc-app", "type":"patch", "url":"git@build.escca.canzea.cc:root/hello-world-svc-app.git"}'

require 'git'
require 'json'
require 'fileutils'
require 'trace-runner'
require 'canzea/config'
require 'canzea/registry'

parameters = JSON.parse(ARGV[0])

n = RunnerWorker.new

r = Registry.new

type = parameters['type']
app = parameters['app']
url = parameters['url']

major = r.getKeyValue ('applications/' + app + '/major')
minor = r.getKeyValue ('applications/' + app + '/minor')
patch = r.getKeyValue ('applications/' + app + '/patch')

newVersion = major+"."+minor+"."+patch
prefix = "release"
if (type == "patch")
    prefix = "hotfix"
end

branch = "#{prefix}-#{newVersion}"

folder = "#{app}"

FileUtils.rm_rf(folder)

g = Git.clone(url, folder, :branch => branch, :path => '.')

n.run "(cd #{folder}; git checkout master)", 0, 0

n.run "(cd #{folder}; git merge --no-ff #{prefix}-#{newVersion})", 0, 0

n.run "(cd #{folder}; git tag -a #{newVersion} -m '#{prefix} #{newVersion}')", 0, 0

n.run "(cd #{folder}; git push --follow-tags)", 0, 0
