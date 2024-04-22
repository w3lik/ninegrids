--- right-sync
sync.receive("slotSync", function(syncData)
    local syncPlayer = syncData.syncPlayer
    local command = syncData.transferData[1]
    if (command == "ability_push") then
        local abId = syncData.transferData[2]
        local i = tonumber(syncData.transferData[3])
        ---@type Ability
        local ab = i2o(abId)
        if (isClass(ab, AbilityClass)) then
            syncPlayer:selection():abilitySlot():insert(ab, i)
        end
    elseif (command == "item_push") then
        local itId = syncData.transferData[2]
        local i = tonumber(syncData.transferData[3])
        ---@type Item
        local it = i2o(itId)
        if (isClass(it, ItemClass)) then
            syncPlayer:selection():itemSlot():insert(it, i)
        end
    elseif (command == "warehouse_push") then
        local itId = syncData.transferData[2]
        local i = tonumber(syncData.transferData[3])
        ---@type Item
        local it = i2o(itId)
        if (isClass(it, ItemClass)) then
            syncPlayer:warehouseSlot():insert(it, i)
        end
    end
    async.call(syncPlayer, function()
        cursor.quoteOver("follow")
    end)
end)
