require 'git'
require 'fileutils'
require_relative '../../../init/registry.rb'
require_relative '../../../init/trace-runner'

n = RunnerWorker.new

r = Registry.new

type = ARGV[0]
app = ARGV[1]

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

r.register('applications', app + '/major', major)
r.register('applications', app + '/minor', minor)
r.register('applications', app + '/patch', patch)

newVersion = major+"."+minor+"."+patch
prefix = "release"
if (type == "patch")
    prefix = "hotfix"
end

url = "git@build.escca.canzea.cc:root/#{app}.git"

branch = "develop"

folder = "#{app}"

FileUtils.rm_rf(folder)

g = Git.clone(url, folder, :branch => branch, :path => '.')

n.run "(cd #{folder}; git checkout -b #{prefix}-#{newVersion})", 0, 0

n.run "(cd #{folder}; mvn versions:set -DnewVersion=#{newVersion})", 0, 0

n.run "(cd #{folder}; git commit -a -m 'Bumped #{type} number to #{newVersion}')", 0, 0

n.run "(cd #{folder}; git push --set-upstream origin #{prefix}-#{newVersion})", 0, 0
