function tooltipsForge(idx, times)
    local gd = Game():GD()
    local fgLv = gd.sacredForge[idx]
    local content = { icons = {} }
    local wor = Game():sacredForgeWorth(idx, fgLv)
    if (times == 10) then
        content.tips = {
            colour.hex(colour.lightgreen, "价格、几率将动态计算"),
            colour.hex(colour.indianred, "当银两不足时自动停止"),
            "",
            colour.hex(colour.lightyellow, "当前精炼等级:" .. fgLv),
            colour.hex(colour.gold, "连续精炼十次，听天由命"),
        }
        if (Game():worthLess(gd.me:owner():worth(), Game():worthCale(wor, "*", 10))) then
            table.insert(content.tips, "")
            table.insert(content.tips, colour.hex(colour.red, "银两不足以启动十连"))
        end
    else
        local odds = math.format(Game():sacredForgeOdds(idx, fgLv), 2)
        content.tips = {
            colour.hex(colour.lightyellow, "当前精炼等级:" .. fgLv),
            colour.hex(colour.lightgreen, "下一精炼等级:" .. fgLv + 1),
            colour.hex(colour.gold, "精炼成功概率:" .. odds .. '%'),
            colour.hex(colour.indianred, "精炼失败概率:" .. (100 - odds) .. '%'),
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
            table.insert(content.tips, colour.hex(colour.red, "银两不足以进行精炼"))
        end
    end
    return content
end