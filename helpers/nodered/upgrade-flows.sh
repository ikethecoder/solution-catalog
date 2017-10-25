
(cd ~/.ecosystem-catalog/catalog && unzip blueprints/neat-and-tidy/flows/flows-8c020b4d77297af5bb34afeb0f1f2311.zip)

(cd ~/.ecosystem-catalog/catalog && canzea --lifecycle=wire --solution=nodered --action=flows --args='{"file":"nr-tab-id-global.flow"}')

(cd ~/.ecosystem-catalog/catalog && canzea --lifecycle=wire --solution=nodered --action=flows --args='{"file":"nr-tab-*.flow"}')
