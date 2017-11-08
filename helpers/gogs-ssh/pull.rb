require 'git'
require 'json'

g = Git.init(".")

g.pull
