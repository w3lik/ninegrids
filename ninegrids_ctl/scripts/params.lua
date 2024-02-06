function ninegridsCtl_params(stage)
    stage.bgW = 0.3
    stage.bgH = stage.bgW / 800 * 370
    stage.bgShadowH = stage.bgH / 7
    stage.bgTailW = stage.bgH * 130 / 370
    stage.plateBarW = 0.218
    stage.plateBarH = 0.013
    stage.abilityMAX = #Game():abilityHotkey()
    stage.abilitySize = 0.044
    stage.abilityMargin = 0.003
    stage.itemMAX = #Game():itemHotkey()
    stage.itemSize = 0.0296
    stage.itemMargin = 0.00184
    stage.warehouseMAX = Game():warehouseSlot()
    stage.warehouseRaw = 4
    stage.warehouseSize = 0.03
    stage.warehouseMarginW = 0.003
    stage.warehouseMarginH = 0.002
    stage.warehouseResAllow = {}
    stage.warehouseResOpt = {
        gold = { texture = 'worth/gold', color = 'FED112', x = 0.02, y = -0.03 },
        silver = { texture = 'worth/silver', color = 'BEC8EB', x = 0.02, y = -0.043 },
        copper = { texture = 'worth/copper', color = 'D7AE8E', x = 0.08, y = -0.043 },
    }
    local res = Game():worth()
    res:forEach(function(key, value)
        if (stage.warehouseResOpt[key]) then
            stage.warehouseResOpt[key].name = value.name
            if (false == table.includes(stage.warehouseResAllow, key)) then
                table.insert(stage.warehouseResAllow, key)
            end
        else
            stage.warehouseResOpt[key] = { name = value.name }
        end
    end)
end