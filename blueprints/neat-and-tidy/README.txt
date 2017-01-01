
BlueprintBuilder.new()
    .add(readBase('base.json'))
    .add(mapBuildingBlocks('building-blocks.yml'))
    .add(mapEnvironments('environments.yml'))
    .add(mapStacks('stacks.yml'))
    .merge(positionData)
    .merge(vendorSuppliedData)

When we post an update back, we need to be able to know which part needs updating.

BlueprintParser.new(data)
    .split(positionData).save("positionData")