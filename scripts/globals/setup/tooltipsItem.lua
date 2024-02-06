function tooltipsItem(whichItem)
    if (instanceof(whichItem, ItemFuncClass) == false) then
        return nil
    end
    local icons = {
        { "coolDown", "15DF89", "秒" },
        { "hpCost", "DE5D43", "血" },
        { "mpCost", "83B3E4", "蓝" },
    }
    local content = {
        tips = Game():combineDescription(whichItem, { after = true }, "itemBase"),
        icons = {},
        bars = {},
        list = {},
    }
    local wor = whichItem:worth()
    local cale = Game():worthCale(wor, "*", PlayerLocal():sellRatio() * 0.01)
    for _, c in ipairs(icons) do
        local key = c[1]
        local color = c[2]
        local uit = c[3]
        local val = math.floor(cale[key] or 0)
        if (val > 0) then
            if (uit ~= nil) then
                val = val .. " " .. uit
            end
            table.insert(content.icons, {
                texture = "Framework\\ui\\" .. key .. ".tga",
                text = colour.hex(color, val),
            })
        end
    end
    local whichAbility = whichItem:ability()
    if (isClass(whichAbility, AbilityClass)) then
        local lv = whichAbility:level()
        for _, c in ipairs(icons) do
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
    end
    if (isClass(whichItem, ItemClass)) then
        local lv = whichItem:level()
        if (lv < whichItem:levelMax()) then
            if (whichItem:exp() > 0) then
                local cur = whichItem:exp() or 0
                local prev = whichItem:expNeed(lv) or 0
                local need = whichItem:expNeed() or 0
                local percent = math.trunc((cur - prev) / (need - prev), 3)
                if (percent ~= nil) then
                    table.insert(content.bars, {
                        texture = "Framework\\ui\\tile_white.tga",
                        text = colour.hex(colour.white, "经验：" .. math.floor(cur - prev) .. "/" .. math.ceil(need - prev)),
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