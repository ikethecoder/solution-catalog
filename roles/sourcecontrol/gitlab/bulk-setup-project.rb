require 'json'
require 'net/http'

class SetupProject
    def create (projectName)

        # Get the authtoken and userId
        uri = URI(ENV['GITLAB_URL'] + '/api/v3/session')

        res = Net::HTTP.post_form(uri, 'login' => 'root', 'password' => 'admin1admin1')
        puts res.body

        data = JSON.parse(res.body)

        privateToken = data['private_token']
        puts privateToken

        # Create Project
        headers = {
                'Content-Type' => 'application/json'
        }
        payload = {
                "name" => projectName, "visibility_level" => 20
        }
        http = Net::HTTP.new(ENV['GITLAB_ADDRESS'], ENV['GITLAB_PORT'])
        res = http.post("/api/v3/projects?private_token=#{privateToken}", payload.to_json, headers)
        puts res.code
        puts res.message
        puts res.body
    end
end