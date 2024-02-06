TPL_ABILITY_BOSS = TPL_ABILITY_BOSS or {}
TPL_ABILITY_BOSS["界泠恶化"] = AbilityTpl()
    :name("界泠恶化")
    :targetType(ABILITY_TARGET_TYPE.pas)
    :icon("ability/DeathknightRemorselessWinters")
    :params(
    function()
        local gd = Game():GD()
        local erode = math.round(gd.erode)
        local diff = math.round(gd.diff)
        local diffHP = diff * 60 + erode
        local diffAtk = diff * 10
        local erodeHP = math.trunc(1.0 * erode, 3)
        local erodeAtk = math.trunc(0.5 * erode, 3)
        local erodeDef = math.trunc(0.04 * erode, 3)
        return diffHP, diffAtk, erodeHP, erodeAtk, erodeDef
    end)
    :description(
    function(this)
        local diffHP, diffAtk, erodeHP, erodeAtk, erodeDef = this:params()
        return {
            "探秘区中的原生英泠能力与界域动荡相关",
            "界域强度和侵蚀程度都会影响",
            colour.hex(colour.lawngreen, "界域HP强化：" .. diffHP),
            colour.hex(colour.lawngreen, "界域攻击强化：" .. diffAtk),
            colour.hex(colour.violet, "侵蚀HP强化：" .. erodeHP .. '%'),
            colour.hex(colour.violet, "侵蚀攻击强化：" .. erodeAtk .. '%'),
            colour.hex(colour.violet, "侵蚀防御强化：" .. erodeDef .. '%'),
        }
    end)
    :onEvent(EVENT.Ability.Get,
    function(abData)
        local diffHP, diffAtk, erodeHP, erodeAtk, erodeDef = abData.triggerAbility:params()
        abData.triggerUnit:hp("+=" .. diffHP)
        abData.triggerUnit:attack("+=" .. diffAtk)
        abData.triggerUnit:mutation("hp", "+=" .. erodeHP)
        abData.triggerUnit:mutation("attack", "+=" .. erodeAtk)
        abData.triggerUnit:mutation("defend", "+=" .. erodeDef)
    end)
    :onEvent(EVENT.Ability.Lose,
    function(abData)
        local diffHP, diffAtk, erodeHP, erodeAtk, erodeDef = abData.triggerAbility:params()
        abData.triggerUnit:hp("-=" .. diffHP)
        abData.triggerUnit:attack("-=" .. diffAtk)
        abData.triggerUnit:mutation("hp", "-=" .. erodeHP)
        abData.triggerUnit:mutation("attack", "-=" .. erodeAtk)
        abData.triggerUnit:mutation("defend", "-=" .. erodeDef)
    end)
TPL_ABILITY_BOSS["界泠恶堕"] = AbilityTpl()
    :name("界泠恶堕")
    :targetType(ABILITY_TARGET_TYPE.pas)
    :icon("ability/DeathknightRemorselessWinters2")
    :params(
    function()
        local gd = Game():GD()
        local diff = math.round(gd.diff)
        local hps = { 5000, 13000, 25000, 40000 }
        local diffHP = hps[diff]
        local diffMP = diff * 150
        local diffMPRegen = diff * 3
        local diffAtk = diff * 60
        local diffDef = diff * 15
        local erode = math.round(gd.erode)
        local erodeHP = math.trunc(1.2 * erode, 3)
        local erodeMP = math.trunc(0.09 * erode, 3)
        local erodeAtk = math.trunc(0.7 * erode, 3)
        local erodeDef = math.trunc(0.1 * erode, 3)
        return diffHP, diffMP, diffMPRegen, diffAtk, diffDef, erodeHP, erodeMP, erodeAtk, erodeDef
    end)
    :description(
    function(this)
        local diffHP, diffMP, diffMPRegen, diffAtk, diffDef, erodeHP, erodeMP, erodeAtk, erodeDef = this:params()
        return {
            "探秘区中的原生英泠能力与界域动荡相关",
            "界域强度和侵蚀程度都会影响",
            colour.hex(colour.lawngreen, "界域HP强化：" .. diffHP),
            colour.hex(colour.lawngreen, "界域MP强化：" .. diffMP),
            colour.hex(colour.lawngreen, "界域MP恢复：+" .. diffMPRegen),
            colour.hex(colour.lawngreen, "界域攻击强化：" .. diffAtk),
            colour.hex(colour.lawngreen, "界域防御强化：" .. diffDef),
            colour.hex(colour.violet, "侵蚀HP强化：" .. erodeHP .. '%'),
            colour.hex(colour.violet, "侵蚀MP强化：" .. erodeMP .. '%'),
            colour.hex(colour.violet, "侵蚀攻击强化：" .. erodeAtk .. '%'),
            colour.hex(colour.violet, "侵蚀防御强化：" .. erodeDef .. '%'),
            "当HP将至" .. colour.hex(colour.indianred, "50%以下") .. "时，引发" .. colour.hex(colour.indianred, "狂暴"),
            "当此英泠断泠时，怨念将会加重侵蚀" .. colour.hex(colour.violet, Game():erodeCell() .. "层"),
        }
    end)
    :onEvent(EVENT.Ability.Get,
    function(abData)
        local diffHP, diffMP, diffMPRegen, diffAtk, diffDef, erodeHP, erodeMP, erodeAtk, erodeDef = abData.triggerAbility:params()
        abData.triggerUnit:hp("+=" .. diffHP)
        abData.triggerUnit:mp("+=" .. diffMP)
        abData.triggerUnit:mpRegen("+=" .. diffMPRegen)
        abData.triggerUnit:attack("+=" .. diffAtk)
        abData.triggerUnit:defend("+=" .. diffDef)
        abData.triggerUnit:mutation("hp", "+=" .. erodeHP)
        abData.triggerUnit:mutation("mp", "+=" .. erodeMP)
        abData.triggerUnit:mutation("attack", "+=" .. erodeAtk)
        abData.triggerUnit:mutation("defend", "+=" .. erodeDef)
    end)
    :onUnitEvent(EVENT.Unit.Hurt,
    function(hurtData)
        local u = hurtData.triggerUnit
        if (u:buffHas("界泠恶堕狂暴状态")) then
            return
        end
        local hpCur = u:hpCur()
        local hp = u:hp()
        local percent = hpCur / hp
        local line = 0.5
        if (percent < line) then
            Game():bossBgmCrazy(u, "boss")
            u:buff("界泠恶堕狂暴状态")
             :icon("ability/DeathknightRemorselessWinters2")
             :duration(-1)
             :description(
                {
                    colour.hex(colour.lawngreen, "攻速：+20%"),
                    colour.hex(colour.lawngreen, "攻击：+20%"),
                    colour.hex(colour.lawngreen, "移动：+25%"),
                })
             :purpose(
                function(buffObj)
                    buffObj:attach("buff/Demonfilth", "overhead")
                    buffObj:mutation("attackSpeed", "+=20")
                    buffObj:mutation("attack", "+=20")
                    buffObj:mutation("move", "+=25")
                end)
             :rollback(
                function(buffObj)
                    buffObj:detach("buff/Demonfilth", "overhead")
                    buffObj:mutation("attackSpeed", "-=20")
                    buffObj:mutation("attack", "-=20")
                    buffObj:mutation("move", "-=25")
                end)
             :run()
            local hpRegen = 300 + 100 * math.floor(Game():GD().diff) + 3 * math.floor(Game():GD().erode)
            u:buff("界泠恶堕狂暴激活")
             :icon("ability/DeathknightRemorselessWinters2")
             :duration(5)
             :description({ colour.hex(colour.lawngreen, "HP恢复：+" .. hpRegen), })
             :purpose(function(buffObj) buffObj:hpRegen("+=" .. hpRegen) end)
             :rollback(function(buffObj) buffObj:hpRegen("-=" .. hpRegen) end)
             :run()
        end
    end)
TPL_ABILITY_BOSS["界泠深渊"] = AbilityTpl()
    :name("界泠深渊")
    :targetType(ABILITY_TARGET_TYPE.pas)
    :icon("ability/AchievementKirintorOffensive")
    :params(
    function()
        local gd = Game():GD()
        local diff = math.round(gd.diff)
        local hps = { 12000, 30000, 50000, 80000 }
        local diffHP = hps[diff]
        local diffMP = diff * 200
        local diffHPRegen = diff * 5
        local diffMPRegen = diff * 4
        local diffAtk = diff * 100
        local diffDef = diff * 25
        local erode = math.round(gd.erode)
        local erodeHP = math.trunc(1.3 * erode, 3)
        local erodeMP = math.trunc(0.12 * erode, 3)
        local erodeAtk = math.trunc(0.8 * erode, 3)
        local erodeDef = math.trunc(0.15 * erode, 3)
        return diffHP, diffMP, diffHPRegen, diffMPRegen, diffAtk, diffDef, erodeHP, erodeMP, erodeAtk, erodeDef
    end)
    :description(
    function(this)
        local diffHP, diffMP, diffHPRegen, diffMPRegen, diffAtk, diffDef, erodeHP, erodeMP, erodeAtk, erodeDef = this:params()
        return {
            "探秘区中的原生英泠能力与界域动荡相关",
            "界域强度和侵蚀程度都会影响",
            colour.hex(colour.lawngreen, "界域HP强化：" .. diffHP),
            colour.hex(colour.lawngreen, "界域MP强化：" .. diffMP),
            colour.hex(colour.lawngreen, "界域HP恢复：+" .. diffHPRegen),
            colour.hex(colour.lawngreen, "界域MP恢复：+" .. diffMPRegen),
            colour.hex(colour.lawngreen, "界域攻击强化：" .. diffAtk),
            colour.hex(colour.lawngreen, "界域防御强化：" .. diffDef),
            colour.hex(colour.violet, "侵蚀HP强化：" .. erodeHP .. '%'),
            colour.hex(colour.violet, "侵蚀MP强化：" .. erodeMP .. '%'),
            colour.hex(colour.violet, "侵蚀攻击强化：" .. erodeAtk .. '%'),
            colour.hex(colour.violet, "侵蚀防御强化：" .. erodeDef .. '%'),
            "当HP将至" .. colour.hex(colour.indianred, "50%以下") .. "时，引发" .. colour.hex(colour.indianred, "狂暴"),
        }
    end)
    :onEvent(EVENT.Ability.Get,
    function(abData)
        local diffHP, diffMP, diffHPRegen, diffMPRegen, diffAtk, diffDef, erodeHP, erodeMP, erodeAtk, erodeDef = abData.triggerAbility:params()
        abData.triggerUnit:hp("+=" .. diffHP)
        abData.triggerUnit:mp("+=" .. diffMP)
        abData.triggerUnit:hpRegen("+=" .. diffHPRegen)
        abData.triggerUnit:mpRegen("+=" .. diffMPRegen)
        abData.triggerUnit:attack("+=" .. diffAtk)
        abData.triggerUnit:defend("+=" .. diffDef)
        abData.triggerUnit:mutation("hp", "+=" .. erodeHP)
        abData.triggerUnit:mutation("mp", "+=" .. erodeMP)
        abData.triggerUnit:mutation("attack", "+=" .. erodeAtk)
        abData.triggerUnit:mutation("defend", "+=" .. erodeDef)
    end)
    :onUnitEvent(EVENT.Unit.Hurt,
    function(hurtData)
        local u = hurtData.triggerUnit
        if (u:buffHas("界泠深渊狂暴状态")) then
            return
        end
        local hpCur = u:hpCur()
        local hp = u:hp()
        local percent = hpCur / hp
        local line = 0.5
        if (percent < line) then
            Game():bossBgmCrazy(u, "bigBoss")
            u:buff("界泠深渊狂暴状态")
             :icon("ability/AchievementKirintorOffensive")
             :duration(-1)
             :description(
                {
                    colour.hex(colour.lawngreen, "攻速：+25%"),
                    colour.hex(colour.lawngreen, "攻击：+25%"),
                    colour.hex(colour.lawngreen, "移动：+30%"),
                })
             :purpose(
                function(buffObj)
                    buffObj:attach("buff/Demonfilth", "overhead")
                    buffObj:mutation("attackSpeed", "+=25")
                    buffObj:mutation("attack", "+=25")
                    buffObj:mutation("move", "+=30")
                end)
             :rollback(
                function(buffObj)
                    buffObj:detach("buff/Demonfilth", "overhead")
                    buffObj:mutation("attackSpeed", "-=25")
                    buffObj:mutation("attack", "-=25")
                    buffObj:mutation("move", "-=30")
                end)
             :run()
            local hpRegen = 700 + 150 * math.floor(Game():GD().diff)
            u:buff("界泠深渊狂暴激活")
             :icon("ability/AchievementKirintorOffensive")
             :duration(7)
             :description({ colour.hex(colour.lawngreen, "HP恢复：+" .. hpRegen), })
             :purpose(function(buffObj) buffObj:hpRegen("+=" .. hpRegen) end)
             :rollback(function(buffObj) buffObj:hpRegen("-=" .. hpRegen) end)
             :run()
        end
    end)
TPL_ABILITY_BOSS["无我无妄"] = AbilityTpl()
    :name("无我无妄")
    :targetType(ABILITY_TARGET_TYPE.pas)
    :icon("ability/AlienRune")
    :params(
    function()
        local gd = Game():GD()
        local upHP = math.round(175000 + (gd.lastDead * 15000))
        local upMP = math.round(2000 + (gd.lastDead * 100))
        local upHPRegen = 25
        local upMPRegen = 20
        local upAtk = math.round(130 + (gd.lastDead * 5))
        local upDef = math.round(100 + (gd.lastDead * 2))
        local erode = math.round(gd.erode)
        local erodeHP = math.trunc(1.35 * erode, 3)
        local erodeMP = math.trunc(0.11 * erode, 3)
        local erodeAtk = math.trunc(0.40 * erode, 3)
        local erodeDef = math.trunc(0.10 * erode, 3)
        return upHP, upMP, upHPRegen, upMPRegen, upAtk, upDef, erodeHP, erodeMP, erodeAtk, erodeDef
    end)
    :description(
    function(this)
        local upHP, upMP, upHPRegen, upMPRegen, upAtk, upDef, erodeHP, erodeMP, erodeAtk, erodeDef = this:params()
        return {
            "探秘区混沌至源，没有确切本体，常化作邪神至相",
            "吸收探秘区的力量，变得无比的强大，貌似无敌的存在",
            "还可侵蚀其他英泠的力量，并以侵蚀强化变得更强",
            colour.hex(colour.lawngreen, "界域HP强化：" .. upHP),
            colour.hex(colour.lawngreen, "界域MP强化：" .. upMP),
            colour.hex(colour.lawngreen, "界域HP恢复：+" .. upHPRegen),
            colour.hex(colour.lawngreen, "界域MP恢复：+" .. upMPRegen),
            colour.hex(colour.lawngreen, "界域攻击强化：" .. upAtk),
            colour.hex(colour.lawngreen, "界域防御强化：" .. upDef),
            colour.hex(colour.violet, "侵蚀HP强化：" .. erodeHP .. '%'),
            colour.hex(colour.violet, "侵蚀MP强化：" .. erodeMP .. '%'),
            colour.hex(colour.violet, "侵蚀攻击强化：" .. erodeAtk .. '%'),
            colour.hex(colour.violet, "侵蚀防御强化：" .. erodeDef .. '%'),
            "当HP将至" .. colour.hex(colour.indianred, "50%以下") .. "时，引发" .. colour.hex(colour.indianred, "狂暴"),
            "",
            colour.hex(colour.red, "打败最终BOSS后，下一次战斗TA将变得更加强大"),
        }
    end)
    :onEvent(EVENT.Ability.Get,
    function(abData)
        local upHP, upMP, upHPRegen, upMPRegen, upAtk, upDef, erodeHP, erodeMP, erodeAtk, erodeDef = abData.triggerAbility:params()
        abData.triggerUnit:hp("+=" .. upHP)
        abData.triggerUnit:mp("+=" .. upMP)
        abData.triggerUnit:hpRegen("+=" .. upHPRegen)
        abData.triggerUnit:mpRegen("+=" .. upMPRegen)
        abData.triggerUnit:attack("+=" .. upAtk)
        abData.triggerUnit:defend("+=" .. upDef)
        abData.triggerUnit:mutation("hp", "+=" .. erodeHP)
        abData.triggerUnit:mutation("mp", "+=" .. erodeMP)
        abData.triggerUnit:mutation("attack", "+=" .. erodeAtk)
        abData.triggerUnit:mutation("defend", "+=" .. erodeDef)
    end)
    :onUnitEvent(EVENT.Unit.Hurt,
    function(hurtData)
        local u = hurtData.triggerUnit
        if (u:buffHas("无我无妄狂暴状态")) then
            return
        end
        local hpCur = u:hpCur()
        local hp = u:hp()
        local percent = hpCur / hp
        local line = 0.5
        if (percent < line) then
            Game():bossBgmCrazy(u, "lastBoss")
            u:buff("无我无妄狂暴状态")
             :icon("ability/AlienRune")
             :duration(-1)
             :description(
                {
                    colour.hex(colour.lawngreen, "攻速：+30%"),
                    colour.hex(colour.lawngreen, "攻击：+30%"),
                    colour.hex(colour.lawngreen, "移动：+35%"),
                })
             :purpose(
                function(buffObj)
                    buffObj:attach("buff/Demonfilth", "overhead")
                    buffObj:mutation("attackSpeed", "+=30")
                    buffObj:mutation("attack", "+=30")
                    buffObj:mutation("move", "+=35")
                end)
             :rollback(
                function(buffObj)
                    buffObj:detach("buff/Demonfilth", "overhead")
                    buffObj:mutation("attackSpeed", "-=30")
                    buffObj:mutation("attack", "-=30")
                    buffObj:mutation("move", "-=35")
                end)
             :run()
            local hpRegen = 1000
            local mpRegen = 100
            u:buff("无我无妄狂暴激活")
             :icon("ability/AchievementKirintorOffensive")
             :duration(30)
             :description({
                colour.hex(colour.lawngreen, "HP恢复：+" .. hpRegen),
                colour.hex(colour.lawngreen, "MP恢复：+" .. mpRegen),
            })
             :purpose(function(buffObj)
                buffObj:hpRegen("+=" .. hpRegen)
                buffObj:mpRegen("+=" .. mpRegen)
            end)
             :rollback(function(buffObj)
                buffObj:hpRegen("-=" .. hpRegen)
                buffObj:mpRegen("-=" .. mpRegen)
            end)
             :run()
        end
    end)