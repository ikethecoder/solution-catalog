require_relative './install-project'

ip = InstallProject.new

ip.install ENV['REPO_HOST'], ENV['REPO_PORT'], "maven-archiver/maven-archiver/pom.properties", "env"
