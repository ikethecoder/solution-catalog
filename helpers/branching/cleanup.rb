# ruby helpers/helper-run.rb branching cleanup '{"app":"hello-world-svc-app", "type":"patch", "url":"git@build.escca.canzea.cc:root/hello-world-svc-app.git"}'

require 'git'
require 'json'
require 'fileutils'
require 'trace-runner'
require 'canzea/registry'
require 'canzea/config'

parameters = JSON.parse(ARGV[0])

n = RunnerWorker.new

r = Registry.new

type = parameters['type']
app = parameters['app']
url = parameters['url']

major = r.getKeyValue ('components/' + app + '/versioning/major')
minor = r.getKeyValue ('components/' + app + '/versioning/minor')
patch = r.getKeyValue ('components/' + app + '/versioning/patch')

newVersion = major+"."+minor+"."+patch
prefix = "release"
if (type == "patch")
    prefix = "hotfix"
end

folder = "#{app}"

FileUtils.rm_rf(folder)

g = Git.clone(url, folder, :path => '.')

n.run "(cd #{folder}; git push origin --delete #{prefix}-#{newVersion})", 0, 0
