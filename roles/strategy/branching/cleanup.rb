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

newVersion = major+"."+minor+"."+patch
prefix = "release"
if (type == "patch")
    prefix = "hotfix"
end

url = "git@build.escca.canzea.cc:root/#{app}.git"

branch = "master"

folder = "#{app}"

FileUtils.rm_rf(folder)

g = Git.clone(url, folder, :branch => branch, :path => '.')

n.run "(cd #{folder}; git push origin --delete #{prefix}-#{newVersion})", 0, 0
