require 'json'
require 'base64'
require 'commands/add-env'
require 'plan-step-class'
require 'yaml'
require 'canzea/config'

class PreparePlan
    def initialize ()
        @log = Logger.new(Canzea::config[:logging_root] + '/plans.log')
        @basePath = "#{Pathname.new(Canzea::config[:catalog_location]).realpath}"
    end

    def do (blueprint, segment, step, task, test)
        ps = PlanStep.new

        log "Processing configure.json for #{segment} in #{blueprint} from #{@basePath}"

        instructions = YAML.load_file("#{@basePath}/blueprints/#{blueprint}/instruction.yml")
        segment = instructions['instructions']['segments'][segment]

        log segment['abbreviation']

        first = true
        index = 1
        segment['image'].each { |item|
            if item.start_with?("step:")
                parts = item.split(':')

                if (index < Integer(step))
                    log "[#{index.to_s.rjust(2, "0")}] #{item} SKIPPING"
                    msg = { "message" => { "task" => "skip", "context" => { "step" => index } } }
                    puts msg.to_json
                else

                    log "[#{index.to_s.rjust(2, "0")}] #{item}"

                    if (test == false)
                        if (task == nil)
                              ps.runPhaseInstall parts[1], parts[2], test, 1
                        else
                              ps.runPhaseInstall parts[1], parts[2], test, Integer(task)
                        end
                        # Keep track of what we have done; parsing the response and looking at the JSON
                    else
                          ps.runPhaseInstall parts[1], parts[2], test, 1
                    end

                    if first == true
                        # task is only relevant for the first invocation
                        task = nil
                        first = false
                    end
                end
                index = index + 1
            end
        }
    end

    def log (msg)
        puts "-- #{msg}"
        @log.info(msg)
    end
end


pp = PreparePlan.new


pp.do 'neat-and-tidy', 'ci', 1, nil, true