
(cd ~/.ecosystem-catalog/catalog && unzip blueprints/neat-and-tidy/flows/flows.zip)

(cd ~/.ecosystem-catalog/catalog && canzea --lifecycle=wire --solution=nodered --action=flows --args='{"file":"nr-tab-id-global.flow"}')

(cd ~/.ecosystem-catalog/catalog && canzea --lifecycle=wire --solution=nodered --action=flows --args='{"file":"nr-tab-*.flow"}')
