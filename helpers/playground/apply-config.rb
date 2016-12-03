require 'json'
require 'plan-step-class'

parameters = JSON.parse(ARGV[0])

ps = PlanStep.new

# Read the configuration file and make calls out to run

steps = JSON.parse(File.read("#{gitRoot}/configure.json"))

steps["steps"].each { | step |

    role = step['role']
    solution = step['solution']

    ps.runPhaseConfigure role, solution, false, 1
}
