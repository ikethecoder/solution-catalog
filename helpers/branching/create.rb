# ruby helpers/helper-run.rb branching create '{"app":"hello-world-svc-app", "type":"patch", "url":"git@build.escca.canzea.cc:root/hello-world-svc-app.git"}'

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

major = r.getKeyValue ('applications/' + app + '/major')
minor = r.getKeyValue ('applications/' + app + '/minor')
patch = r.getKeyValue ('applications/' + app + '/patch')

if (type == "major")
    major = major.next
    minor = 0
    patch = 0
elsif (type == "minor")
    minor = minor.next
    patch = 0
elsif (type == "patch")
    patch = patch.next
else
    raise "Unrecognized type #{type}"
end

r.setKeyValue('applications', app + '/major', major)
r.setKeyValue('applications', app + '/minor', minor)
r.setKeyValue('applications', app + '/patch', patch)

newVersion = "#{major}.#{minor}.#{patch}"
prefix = "release"
if (type == "patch")
    prefix = "hotfix"
end
if (type == "major")
    r.setKeyValue('applications', "#{app}/releases/#{major}/minor", minor)
end
if (type == "minor")
    r.setKeyValue('applications', "#{app}/releases/#{major}.#{minor}/patch", patch)
end

branch = "develop"

folder = "#{app}"

FileUtils.rm_rf(folder)

g = Git.clone(url, folder, :path => '.')

n.run "(cd #{folder}; git checkout -b #{prefix}-#{newVersion})", 0, 0

n.run "(cd #{folder}; mvn versions:set -DnewVersion=#{newVersion})", 0, 0

n.run "(cd #{folder}; git commit -a -m 'Bumped #{type} number to #{newVersion}')", 0, 0

n.run "(cd #{folder}; git push --set-upstream origin #{prefix}-#{newVersion})", 0, 0
