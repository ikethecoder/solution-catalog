# canzea --lifecycle=wire --solution=application --action=analyze-project --args='{"sourceRepo":"https://gitlab.com/ikethecoder/hello-world-svc-app.git","branch":"master","name":"a"}'


require 'git'
require 'json'
require 'xmlsimple'
require 'java-properties'
require 'fileutils'
require 'canzea/registry'
require_relative 'types/java-maven/java-maven-project'
require_relative 'types/java-maven/java-gradle-project'
require_relative 'types/js-npm/js-npm-project'
require_relative 'types/ruby/ruby-project'
require_relative 'types/static/mkdocs-project'
require_relative 'types/static/hugo-project'

parameters = JSON.parse(ARGV[0])

begin
    url = parameters['sourceRepo']
    branch = parameters['branch']
    name = parameters['name']

    if (parameters.has_key? 'credential_resource')
        credentialResource = parameters['credential_resource']
        creds = Registry.new.getSecret credentialResource
        File.write("#{Dir.home}/.git-credentials", "https://#{creds['username']}:#{creds['password']}@gitlab.com")
    end

    if (File.exists? name)
        FileUtils.remove_dir(name)
    end

    # Need to incorporate the credentials if they are passed in

    if (parameters.has_key? 'branch')
        g = Git.clone(url, name, :branch => branch, :path => '.')
    else
        g = Git.clone(url, name, :path => '.')
    end

    branch = g.current_branch
    commit = g.log[0]

    if (File.exists? "#{name}/pom.xml")
        puts JavaMavenProject.new.createDetails branch, commit, name
    elsif (File.exists? "#{name}/build.gradle")
        puts JavaGradleProject.new.createDetails branch, commit, name
    elsif (File.exists? "#{name}/config.toml")
        puts HugoProject.new.createDetails branch, commit, name
    elsif (File.exists? "#{name}/mkdocs.yml")
        puts MkdocsProject.new.createDetails branch, commit, name
    elsif (File.exists? "#{name}/package.json")
        puts JavascriptProject.new.createDetails branch, commit, name
    elsif (File.exists? "#{name}/Rakefile")
        puts RubyProject.new.createDetails name
    else
        raise "Unable to identify project type"
    end
rescue Exception => e
    resp = {
        "code" => "-1",
        "error" => e.message,
        "detail" => e.to_s
    }
    puts JSON.generate(resp)
end
