# ruby helpers/helper-run.rb branching cleanup '{"app":"hello-world-svc-app", "type":"patch", "url":"git@build.escca.canzea.cc:root/hello-world-svc-app.git"}'

require 'git'
require 'json'
require 'fileutils'
require 'registry'
require 'trace-runner'
require 'canzea/config'

extraConfig = Canzea::config[:config_location] + "/config.json"
if File.exists?(extraConfig)
    file = File.read(extraConfig)
    Canzea::configure JSON.parse(file)
end

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

folder = "#{app}"

FileUtils.rm_rf(folder)

g = Git.clone(url, folder, :path => '.')

n.run "(cd #{folder}; git push origin --delete #{prefix}-#{newVersion})", 0, 0
