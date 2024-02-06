Game():defineDescription("itemAbility", function(this)
    local desc = { '' }
    local lv = math.floor(this:level())
    local tt = this:targetType()
    table.insert(desc, colour.hex(colour.lightskyblue, "技能类型：" .. tt.label))
    if (tt ~= ABILITY_TARGET_TYPE.pas) then
        local chantCast = this:castChant(lv)
        if (chantCast > 0) then
            table.insert(desc, colour.hex(colour.lightskyblue, "吟唱时间：" .. chantCast .. " 秒"))
        else
            table.insert(desc, colour.hex(colour.lightskyblue, "吟唱时间：瞬间施法"))
        end
        local keepCast = this:castKeep(lv)
        if (keepCast > 0) then
            table.insert(desc, colour.hex(colour.lightskyblue, "施法持续：" .. keepCast .. " 秒"))
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
    return desc
end)
Game():defineDescription("itemBase", function(this, options)
    local desc = {}
    local name
    if (this:level() > 0 and this:levelMax() > 1) then
        name = this:name() .. "[精" .. colour.hex(colour.white, this:level()) .. "]"
    else
        name = this:name()
    end
    table.insert(desc, name)
    if (options.after ~= true) then
        table.insert(desc, '')
        local de = this:description()
        if (type(de) == "string") then
            table.insert(desc, colour.hex(colour.darkgray, de))
        elseif (type(de) == "table") then
            for _, de2 in ipairs(de) do
                table.insert(desc, colour.hex(colour.darkgray, de2))
            end
        end
    end
    local ab = this:ability()
    if (isClass(ab, AbilityClass)) then
        local tt = ab:targetType()
        if (isClass(this, ItemClass)) then
            if (tt ~= ABILITY_TARGET_TYPE.pas and this:hotkey() ~= nil) then
                name = name .. "（" .. colour.hex(colour.gold, "数字" .. this:hotkey()) .. "）"
            end
            desc[1] = name
        else
            desc[1] = name
        end
        desc = table.merge(desc, Game():combineDescription(ab, nil, "itemAbility", SYMBOL_D, "attributes"))
        if (this:charges() > 0) then
            table.insert(desc, colour.hex(colour.white, "|n剩余次数：" .. this:charges()))
        end
    else
        desc[1] = name
    end
    local attributes = this:attributes()
    if (type(attributes) == "table" and #attributes > 0) then
        table.insert(desc, '')
        table.insert(desc, colour.hex(colour.lightgray, "[ 属性 ]"))
        table.insert(desc, '')
        local lv = 1
        for _, a in ipairs(attributes) do
            local method = a[1]
            local m2 = a[2] or 0
            local d1
            local d2
            if (type(m2) == "number") then
                d1 = m2
                d2 = a[3] or d1
            elseif (type(m2) == "string") then
                method = method .. '_' .. m2
                d1 = a[3] or 0
                d2 = a[4] or d1
            end
            local label = attribute.conf(method)
            if (label ~= nil) then
                local v = d1
                if (lv > 1) then
                    v = v + (lv - 1) * d2
                end
                table.insert(desc, attribute.format(method, v))
            end
        end
    end
    if (options.after == true) then
        table.insert(desc, '')
        local de = this:description()
        if (type(de) == "string") then
            table.insert(desc, colour.hex(colour.darkgray, de))
        elseif (type(de) == "table") then
            for _, de2 in ipairs(de) do
                table.insert(desc, colour.hex(colour.darkgray, de2))
            end
        end
    end
    return desc
end)
Game():defineDescription("sacred", function(this, options)
    local desc = Game():combineDescription(this, nil, SYMBOL_D)
    local forgeList = this:prop("forgeList")
    local idx = this:prop("idx")
    local fgLv = Game():GD().sacredForge[idx]
    local attributes = forgeList[fgLv]
    local ab = this:ability()
    if (isClass(ab, AbilityTplClass)) then
        local abLv = options.level or fgLv
        ab:level(abLv)
        desc = table.merge(desc, Game():combineDescription(ab, nil, "itemAbility", SYMBOL_D, "attributes"))
        ab:level(1)
    end
    if (type(attributes) == "table" and #attributes > 0) then
        table.insert(desc, "")
        table.insert(desc, colour.hex(colour.lightgray, "[属性]"))
        table.insert(desc, "")
        local lv = 1
        local data = {}
        for _, a in ipairs(attributes) do
            local method = a[1]
            local m2 = a[2] or 0
            local d1
            local d2
            if (type(m2) == "number") then
                d1 = m2
                d2 = a[3] or d1
            elseif (type(m2) == "string") then
                method = method .. '_' .. m2
                d1 = a[3] or 0
                d2 = a[4] or d1
            end
            local v = d1
            if (lv > 1) then
                v = v + (lv - 1) * d2
            end
            if (v > 0) then
                data[method] = v
            elseif (v < 0) then
                data[method] = v
            end
        end
        local newData = {}
        if (type(options) == "table" and type(options.level) == "number") then
            local attributesUpper = forgeList[options.level]
            for _, a in ipairs(attributesUpper) do
                local method = a[1]
                local m2 = a[2] or 0
                local d1
                local d2
                if (type(m2) == "number") then
                    d1 = m2
                    d2 = a[3] or d1
                elseif (type(m2) == "string") then
                    method = method .. '_' .. m2
                    d1 = a[3] or 0
                    d2 = a[4] or d1
                end
                local v = d1
                if (lv > 1) then
                    v = v + (lv - 1) * d2
                end
                local label, form, iai = attribute.conf(method)
                if (data[method] ~= nil) then
                    local diff = ''
                    if (v ~= nil) then
                        if (v == data[method]) then
                            diff = "~"
                        elseif (v > data[method]) then
                            if (iai) then
                                diff = colour.hex(colour.red, "+" .. (v - data[method]) .. form)
                            else
                                diff = colour.hex(colour.green, "+" .. (v - data[method]) .. form)
                            end
                        else
                            if (iai) then
                                diff = colour.hex(colour.green, (v - data[method]) .. form)
                            else
                                diff = colour.hex(colour.red, (v - data[method]) .. form)
                            end
                        end
                    end
                    if (diff ~= '') then
                        if (data[method] > 0) then
                            if (iai) then
                                table.insert(desc, colour.hex(colour.indianred, label .. ": +" .. data[method] .. form) .. ' (' .. diff .. ')')
                            else
                                table.insert(desc, colour.hex(colour.lawngreen, label .. ": +" .. data[method] .. form) .. ' (' .. diff .. ')')
                            end
                        else
                            if (iai) then
                                table.insert(desc, colour.hex(colour.lawngreen, label .. ": " .. data[method] .. form) .. ' (' .. diff .. ')')
                            else
                                table.insert(desc, colour.hex(colour.indianred, label .. ": " .. data[method] .. form) .. ' (' .. diff .. ')')
                            end
                        end
                    end
                else
                    if (v > 0) then
                        table.insert(newData, colour.hex(colour.gold, label .. ": +" .. v .. form))
                    elseif (v < 0) then
                        table.insert(newData, colour.hex(colour.gold, label .. ": " .. v .. form))
                    end
                end
            end
        else
            for _, a in ipairs(attributes) do
                local method = a[1]
                table.insert(desc, attribute.format(method, data[method]))
            end
        end
        if (#newData > 0) then
            table.insert(desc, colour.hex(colour.lightgray, "[下一级将获得新属性]"))
            for _, d in ipairs(newData) do
                table.insert(desc, d)
            end
        end
    end
    if (this:condition() == false and this:prop("condition") ~= nil) then
        table.insert(desc, "")
        table.insert(desc, colour.hex(colour.violet, "获得条件：" .. this:conditionTips() or "未知"))
    end
    return desc
end)