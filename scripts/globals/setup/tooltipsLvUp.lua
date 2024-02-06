function tooltipsLvUp(idx)
    local gd = Game():GD()
    local abLv = gd.abilityLevel[idx]
    local content = { icons = {} }
    local wor = Game():abilityLevelUpWorth(idx, abLv)
    content.tips = {
        colour.hex(colour.lightyellow, "当前等级:" .. abLv),
        colour.hex(colour.lightgreen, "下一等级:" .. abLv + 1),
    }
    local icons = {
        { "lumber", "C49D5A", "木" },
        { "gold", "ECD104", "金" },
        { "silver", "E3E3E3", "银" },
        { "copper", "EC6700", "铜" }
    }
    for _, c in ipairs(icons) do
        local key = c[1]
        local color = c[2]
        local uit = c[3]
        local val = math.floor(wor[key] or 0)
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
    if (Game():worthLess(gd.me:owner():worth(), wor)) then
        table.insert(content.tips, "")
        table.insert(content.tips, colour.hex(colour.red, "银两不足以进行升级"))
    end
    return content
end