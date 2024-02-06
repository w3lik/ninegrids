Game():defineDescription("abilityBase", function(this, options)
    local desc = {}
    local lv = math.floor(options.level or this:level())
    local tt = this:targetType()
    if (isClass(this, AbilityClass)) then
        local lvTxt = ''
        if (this:levelMax() > 1) then
            lvTxt = " - 等级 " .. colour.hex(colour.gold, lv)
        end
        if (tt ~= ABILITY_TARGET_TYPE.pas) then
            table.insert(desc, this:name() .. lvTxt .. "（" .. colour.hex(colour.gold, this:hotkey()) .. "）")
        else
            table.insert(desc, this:name() .. lvTxt)
        end
    else
        table.insert(desc, this:name())
    end
    table.insert(desc, colour.hex(colour.gold, "类型: " .. tt.label))
    local chantCast = this:castChant(lv)
    if (chantCast > 0) then
        table.insert(desc, colour.hex(colour.lightskyblue, "吟唱时间: " .. chantCast .. " 秒"))
    elseif (tt ~= ABILITY_TARGET_TYPE.pas) then
        table.insert(desc, colour.hex(colour.lightskyblue, "吟唱时间: 瞬间施法"))
    end
    local keepCast = this:castKeep(lv)
    if (keepCast > 0) then
        table.insert(desc, colour.hex(colour.lightskyblue, "最大施法持续: " .. keepCast .. " 秒"))
    end
    if (tt ~= ABILITY_TARGET_TYPE.tag_nil and tt ~= ABILITY_TARGET_TYPE.pas) then
        table.insert(desc, colour.hex(colour.lightskyblue, "施法距离: " .. this:castDistance(lv)))
    end
    local castRadius = this:castRadius(lv)
    if (castRadius > 0) then
        if (tt == ABILITY_TARGET_TYPE.tag_nil) then
            table.insert(desc, colour.hex(colour.lightskyblue, "作用半径: " .. this:castRadius(lv)))
        else
            table.insert(desc, colour.hex(colour.lightskyblue, "圆形半径: " .. this:castRadius(lv)))
        end
    end
    local castWidth = this:castWidth(lv)
    local castHeight = this:castHeight(lv)
    if (castWidth > 0 and castHeight > 0) then
        table.insert(desc, colour.hex(colour.lightskyblue, "方形范围: " .. castWidth .. '*' .. castHeight))
    end
    table.insert(desc, '')
    return desc
end)
Game():defineDescription("abilityLvPoint", function(this, _)
    if (this:levelUpNeedPoint() > 0) then
        return { colour.hex("EFBA16", "升级需要技能点: " .. this:levelUpNeedPoint()) }
    end
end)
Game():defineDescription("abilityFire", function(this)
    local desc = {
        colour.format("学习条件: %s", colour.mintcream, {
            { colour.violet, this:conditionTips() }
        }),
        ""
    }
    local lv = 1
    local tt = this:targetType()
    table.insert(desc, colour.hex(colour.gold, "类型: " .. tt.label))
    local chantCast = this:castChant(lv)
    if (chantCast > 0) then
        table.insert(desc, colour.hex(colour.lightskyblue, "吟唱时间: " .. chantCast .. " 秒"))
    elseif (tt ~= ABILITY_TARGET_TYPE.pas) then
        table.insert(desc, colour.hex(colour.lightskyblue, "吟唱时间: 瞬间施法"))
    end
    local keepCast = this:castKeep(lv)
    if (keepCast > 0) then
        table.insert(desc, colour.hex(colour.lightskyblue, "最大施法持续: " .. keepCast .. " 秒"))
    end
    if (tt ~= ABILITY_TARGET_TYPE.tag_nil and tt ~= ABILITY_TARGET_TYPE.pas) then
        table.insert(desc, colour.hex(colour.lightskyblue, "施法距离: " .. this:castDistance(lv)))
    end
    local castRadius = this:castRadius(lv)
    if (castRadius > 0) then
        if (tt == ABILITY_TARGET_TYPE.tag_nil) then
            table.insert(desc, colour.hex(colour.lightskyblue, "作用半径: " .. this:castRadius(lv)))
        else
            table.insert(desc, colour.hex(colour.lightskyblue, "圆形半径: " .. this:castRadius(lv)))
        end
    end
    local castWidth = this:castWidth(lv)
    local castHeight = this:castHeight(lv)
    if (castWidth > 0 and castHeight > 0) then
        table.insert(desc, colour.hex(colour.lightskyblue, "方形范围: " .. castWidth .. '*' .. castHeight))
    end
    table.insert(desc, '')
    desc = table.merge(desc, Game():combineDescription(this, nil, SYMBOL_D, "attributes"))
    return desc
end)
Game():defineDescription("abilityBook", function(this, options)
    local desc = {
        colour.format("学习条件: %s", colour.mintcream, {
            { colour.violet, this:conditionTips() }
        }),
        ""
    }
    local lv = math.floor(options.level or 1)
    local tt = this:targetType()
    table.insert(desc, colour.hex(colour.gold, "类型: " .. tt.label))
    if (tt ~= ABILITY_TARGET_TYPE.pas) then
        local coolDown = this:coolDown(lv)
        table.insert(desc, colour.hex(colour.palegreen, "冷却时间: " .. coolDown .. " 秒"))
        local mpCost = this:mpCost(lv)
        if (mpCost > 0) then
            table.insert(desc, colour.hex(colour.skyblue, "MP消耗: " .. mpCost))
        end
        local hpCost = this:hpCost(lv)
        if (hpCost > 0) then
            table.insert(desc, colour.hex(colour.indianred, "HP消耗: " .. hpCost))
        end
        local chantCast = this:castChant(lv)
        if (chantCast > 0) then
            table.insert(desc, colour.hex(colour.lightskyblue, "吟唱时间: " .. chantCast .. " 秒"))
        else
            table.insert(desc, colour.hex(colour.lightskyblue, "吟唱时间: 瞬间施法"))
        end
        local keepCast = this:castKeep(lv)
        if (keepCast > 0) then
            table.insert(desc, colour.hex(colour.lightskyblue, "施法持续: " .. keepCast .. " 秒"))
        end
        if (tt ~= ABILITY_TARGET_TYPE.tag_nil and tt ~= ABILITY_TARGET_TYPE.pas) then
            table.insert(desc, colour.hex(colour.lightskyblue, "施法距离: " .. this:castDistance(lv)))
        end
        local castRadius = this:castRadius(lv)
        if (castRadius > 0) then
            if (tt == ABILITY_TARGET_TYPE.tag_nil) then
                table.insert(desc, colour.hex(colour.lightskyblue, "作用半径: " .. this:castRadius(lv)))
            else
                table.insert(desc, colour.hex(colour.lightskyblue, "圆形半径: " .. this:castRadius(lv)))
            end
        end
        local castWidth = this:castWidth(lv)
        local castHeight = this:castHeight(lv)
        if (castWidth > 0 and castHeight > 0) then
            table.insert(desc, colour.hex(colour.lightskyblue, "方形范围: " .. castWidth .. '*' .. castHeight))
        end
    end
    table.insert(desc, '')
    this:level(lv)
    desc = table.merge(desc, Game():combineDescription(this, { level = lv }, SYMBOL_D, "attributes"))
    this:level(1)
    return desc
end)
Game():defineDescription("abilityFreak", function(this, options)
    local desc = {}
    local lv = math.floor(options.level or this:level())
    local tt = this:targetType()
    table.insert(desc, colour.hex(colour.gold, "类型: " .. tt.label))
    if (tt ~= ABILITY_TARGET_TYPE.pas) then
        local coolDown = this:coolDown(lv)
        table.insert(desc, colour.hex(colour.palegreen, "冷却时间: " .. coolDown .. " 秒"))
        local chantCast = this:castChant(lv)
        if (chantCast > 0) then
            table.insert(desc, colour.hex(colour.lightskyblue, "吟唱时间: " .. chantCast .. " 秒"))
        else
            table.insert(desc, colour.hex(colour.lightskyblue, "吟唱时间: 瞬间施法"))
        end
        local keepCast = this:castKeep(lv)
        if (keepCast > 0) then
            table.insert(desc, colour.hex(colour.lightskyblue, "施法持续: " .. keepCast .. " 秒"))
        end
        if (tt ~= ABILITY_TARGET_TYPE.tag_nil and tt ~= ABILITY_TARGET_TYPE.pas) then
            table.insert(desc, colour.hex(colour.lightskyblue, "施法距离: " .. this:castDistance(lv)))
        end
        local castRadius = this:castRadius(lv)
        if (castRadius > 0) then
            if (tt == ABILITY_TARGET_TYPE.tag_nil) then
                table.insert(desc, colour.hex(colour.lightskyblue, "作用半径: " .. this:castRadius(lv)))
            else
                table.insert(desc, colour.hex(colour.lightskyblue, "圆形半径: " .. this:castRadius(lv)))
            end
        end
        local castWidth = this:castWidth(lv)
        local castHeight = this:castHeight(lv)
        if (castWidth > 0 and castHeight > 0) then
            table.insert(desc, colour.hex(colour.lightskyblue, "方形范围: " .. castWidth .. '*' .. castHeight))
        end
    end
    table.insert(desc, '')
    desc = table.merge(desc, Game():combineDescription(this, nil, SYMBOL_D, "attributes"))
    return desc
end)