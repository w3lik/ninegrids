function tooltipsAbility(whichAbility, lvOffset)
    if (instanceof(whichAbility, AbilityFuncClass) == false) then
        return nil
    end
    local types = {
        { "coolDown", "15DF89", "秒" },
        { "hpCost", "DE5D43", "血" },
        { "mpCost", "83B3E4", "蓝" },
    }
    lvOffset = lvOffset or 0
    local lv = lvOffset + whichAbility:level()
    if (lv > whichAbility:levelMax()) then
        return nil
    end
    local tips
    local combine
    if (lvOffset > 0) then
        combine = Game():combineDescription(whichAbility, { level = lv }, "abilityBase", SYMBOL_D, "attributes", "abilityLvPoint")
    else
        combine = Game():combineDescription(whichAbility, nil, "abilityBase", SYMBOL_D, "attributes")
    end
    tips = combine
    local content = {
        icons = {},
        bars = {},
        tips = tips,
    }
    for _, c in ipairs(types) do
        local method = c[1]
        if (method == "coolDown" or method == "hpCost" or method == "mpCost") then
            local color = c[2]
            local uit = c[3]
            local val = 0
            if (method == "coolDown") then
                val = whichAbility:coolDown(lv)
            elseif (method == "hpCost") then
                val = whichAbility:hpCost(lv)
            elseif (method == "mpCost") then
                val = whichAbility:mpCost(lv)
            end
            if (val > 0) then
                if (uit ~= nil) then
                    val = val .. " " .. uit
                end
                table.insert(content.icons, {
                    texture = "Framework\\ui\\" .. method .. ".tga",
                    text = colour.hex(color, val),
                })
            end
        end
    end
    if (isClass(whichAbility, AbilityClass)) then
        if (lv == whichAbility:level() and lv < whichAbility:levelMax()) then
            if (whichAbility:exp() > 0) then
                local cur = whichAbility:exp() or 0
                local prev = whichAbility:expNeed(lv) or 0
                local need = whichAbility:expNeed() or 0
                local percent = math.trunc((cur - prev) / (need - prev), 3)
                if (percent ~= nil) then
                    table.insert(content.bars, {
                        texture = "Framework\\ui\\tile_yellow.tga",
                        text = colour.hex("E2C306", "经验：" .. math.floor(cur - prev) .. "/" .. math.ceil(need - prev)),
                        ratio = percent,
                        width = 0.10,
                        height = 0.001,
                    })
                end
            end
        end
    end
    return content
end