Game():defineDescription("unitBase", function(this, _)
    local desc = {}
    table.insert(desc, this:name())
    if (this:level() > 0) then
        table.insert(desc, "等级：Lv" .. this:level())
    else
        name = this:name()
    end
    return desc
end)
Game():defineDescription("unitSoul", function(this, _)
    local desc = {}
    local am = this:attackMode()
    if (am:mode() == "common") then
        if (this:attackRange() < 200) then
            table.insert(desc, colour.hex(colour.indianred, "武器: 近战"))
        else
            table.insert(desc, colour.hex(colour.indianred, "武器: 极速"))
        end
    elseif (am:mode() == "lightning") then
        table.insert(desc, colour.hex(colour.indianred, "武器: 闪电"))
        if (am:scatter() > 0 and am:radius() > 0) then
            table.insert(desc, colour.hex(colour.pink, " - 散射[数量" .. math.floor(am:scatter()) .. "][范围" .. am:radius() .. "]"))
        end
        if (am:focus() > 0) then
            table.insert(desc, colour.hex(colour.pink, " - 聚焦[数量" .. math.floor(am:focus()) .. "]"))
        end
        if (am:reflex() > 0) then
            table.insert(desc, colour.hex(colour.pink, " - 反弹[数量" .. math.floor(am:reflex()) .. "]"))
        end
    elseif (am:mode() == "missile") then
        if (am:homing()) then
            table.insert(desc, colour.hex(colour.indianred, "武器: 远程[自动跟踪]"))
        else
            table.insert(desc, colour.hex(colour.indianred, "武器: 远程"))
        end
        table.insert(desc, colour.hex(colour.pink, " - 发射[速度" .. math.floor(am:speed()) .. "][加速" .. am:acceleration() .. "][高度" .. am:height() .. "]"))
        if (am:scatter() > 0 and am:radius() > 0) then
            table.insert(desc, colour.hex(colour.pink, " - 散射[数量" .. math.floor(am:scatter()) .. "][范围" .. am:radius() .. "]"))
        end
        if (am:gatlin() > 0) then
            table.insert(desc, colour.hex(colour.pink, " - 多段[数量" .. math.floor(am:gatlin()) .. "]"))
        end
        if (am:reflex() > 0) then
            table.insert(desc, colour.hex(colour.pink, " - 反弹[数量" .. math.floor(am:reflex()) .. "]"))
        end
    end
    if (am:damageType() ~= nil) then
        table.insert(desc, colour.hex(colour.indianred, "伤害类型: " .. am:damageTypeLevel() .. "级" .. am:damageType().label))
    end
    local gd = Game():GD()
    local prevTpl = gd.me:tpl()
    local aKeys = {
        "hp", "mp",
        "attack", "attackSpaceBase", "attackRange",
        "defend", "move"
    }
    local aColor = {
        hp = colour.palegreen,
        mp = colour.lightcyan,
        attack = colour.pink,
        attackSpaceBase = colour.pink,
        attackRange = colour.plum,
        defend = colour.dodgerblue,
        move = colour.limegreen,
    }
    local av = {}
    for _, k in ipairs(aKeys) do
        local label, form, _ = attribute.conf(k)
        av[k] = label .. ": " .. this:prop(k) .. form
    end
    if (this == prevTpl) then
        for _, k in ipairs(aKeys) do
            table.insert(desc, colour.hex(aColor[k], av[k]))
        end
    else
        local dv = {}
        for _, k in ipairs(aKeys) do
            dv[k] = this:prop(k) - prevTpl:prop(k)
        end
        for _, k in ipairs(aKeys) do
            local dd
            if (dv[k] > 0) then
                if (attribute.isAnti(k)) then
                    dd = colour.hex(colour.red, '(+' .. dv[k] .. ')')
                else
                    dd = colour.hex(colour.lawngreen, '(+' .. dv[k] .. ')')
                end
            elseif (dv[k] < 0) then
                if (attribute.isAnti(k)) then
                    dd = colour.hex(colour.lawngreen, '(' .. dv[k] .. ')')
                else
                    dd = colour.hex(colour.red, '(' .. dv[k] .. ')')
                end
            else
                dd = colour.hex(colour.lightgray, '(~)')
            end
            table.insert(desc, colour.hex(aColor[k], av[k] .. ' ' .. dd))
        end
    end
    table.insert(desc, "")
    local sp = this:prop("sp")
    if (type(sp) == "string") then
        table.insert(desc, colour.hex(colour.lightyellow, "特性: " .. sp))
    end
    desc = table.merge(desc, Game():combineDescription(this, nil, SYMBOL_D))
    if (this:condition() == false and this:prop("condition") ~= nil) then
        table.insert(desc, "")
        table.insert(desc, colour.format("共鸣条件：%s", colour.mintcream, {
            { colour.violet, this:conditionTips() or "未知" }
        }))
    end
    return desc
end)