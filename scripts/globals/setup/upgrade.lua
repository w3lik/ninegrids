UPGRADE_ATTR = function(typ, level)
    local one = {}
    local attrs = {}
    if (typ == "atk") then
        table.insert(one, { "hp", 9 })
        table.insert(one, { "mp", 9 })
        table.insert(one, { "attack", 9 })
        table.insert(one, { "damageIncrease", 9 })
    elseif (typ == "def") then
        table.insert(one, { "hp", 9 })
        table.insert(one, { "mp", 9 })
        table.insert(one, { "defend", 9 })
        table.insert(one, { "hurtReduction", 9 })
    elseif (typ == "spd") then
        table.insert(one, { "hp", 9 })
        table.insert(one, { "mp", 9 })
        table.insert(one, { "move", 9 })
        table.insert(one, { "attackSpeed", 9 })
    end
    for _, s in ipairs(one) do
        table.insert(attrs, { s[1], s[2] * level })
    end
    return attrs, one
end
UPGRADE_DESC = function(diffLevel)
    local gd = Game():GD()
    local desc = {
        step = {},
        upgrade = {},
    }
    diffLevel = diffLevel or 0
    local typs = { "atk", "def", "spd" }
    for _, t in ipairs(typs) do
        local level = 0
        if (t == "atk") then
            level = gd.upgradeAtk or 0
        elseif (t == "def") then
            level = gd.upgradeDef or 0
        elseif (t == "spd") then
            level = gd.upgradeSpd or 0
        else
            level = 0
        end
        level = level + diffLevel
        local s = UPGRADE_ATTR(t, diffLevel)
        local u = UPGRADE_ATTR(t, level)
        local ds = { "每" .. diffLevel .. "点可提升" }
        local du = {  }
        for _, a in ipairs(s) do
            local method = a[1]
            local v = a[2] or 0
            local label = attribute.conf(method)
            if (label ~= nil) then
                table.insert(ds, attribute.format(method, v))
            end
        end
        for _, a in ipairs(u) do
            local method = a[1]
            local v = a[2] or 0
            local label = attribute.conf(method)
            if (label ~= nil) then
                table.insert(du, attribute.format(method, v))
            end
        end
        desc.step[t] = ds
        desc.upgrade[t] = du
    end
    return desc
end