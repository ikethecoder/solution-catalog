
File.write("Dockerfile", File.read("#{ENV['CATALOG_LOCATION']}/helpers/docker/Dockerfile-nginx.tmpl"))
