function tooltipsAvatarB1()
    local gd = Game():GD()
    return { tips = {
        "当前拥有能力点：" .. colour.hex(colour.gold, math.format(gd.upgradePoint, 0)),
        "已用<攻>能力点：" .. colour.hex(colour.gold, math.format(gd.upgradeAtk, 0)),
        "已用<守>能力点：" .. colour.hex(colour.gold, math.format(gd.upgradeDef, 0)),
        "已用<疾>能力点：" .. colour.hex(colour.gold, math.format(gd.upgradeSpd, 0)),
        '',
        colour.hex(colour.gold, "左键点击") .. colour.hex(colour.silver, " 以分配能力点"),
    } }
end
function tooltipsAvatarB2()
    local gd = Game():GD()
    return { tips = TPL_WEATHER[gd.weather]:description() }
end