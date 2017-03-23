

canzea --config=config.json --lifecycle=wire --solution=nodered --action=flow --args='{"flow_file":"my.flow"}'
canzea --config=config.json --lifecycle=wire --solution=nodered --action=flow --args='{"flow_file":"subflows.nr"}'

canzea --config=config.json --lifecycle=wire --solution=nodered --action=get-flow --args='{"flow_id":"396c2376.c693dc"}'

canzea --config=config.json --lifecycle=wire --solution=nodered --action=flows --args='{}'

canzea --config=config.json --lifecycle=wire --solution=nodered --action=list-flows --args='{}'

To get all the sub-flows:

canzea --config=config.json --lifecycle=wire --solution=nodered --action=get-flow --args='{"flow_id":"global"}'

canzea --config=config.json --lifecycle=wire --solution=nodered --action=get-flow --args='{"flow_id":"global","out_file":"subflows.nr"}'
