TPL_ABILITY_SOUL[10] = AbilityTpl()
    :name("背刺")
    :targetType(ABILITY_TARGET_TYPE.tag_unit)
    :icon("ability/RogueSurpriseAttack")
    :coolDownAdv(20, -0.2)
    :mpCostAdv(50, 5)
    :castDistanceAdv(400, 50)
    :castRadiusAdv(50, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local d = math.trunc(0.3 + lv * 0.05, 2)
        local dmg
        local bu = obj:prop("bindUnit")
        if (isClass(bu, UnitClass)) then
            dmg = math.floor(bu:move()) * d
        else
            dmg = "移动x" .. d
        end
        local move = 150
        local deAtkSpd = 50
        local atkSpd = 18 + lv * 2
        return {
            "跳到木飙背后进行快速攻击",
            "眩晕0.3秒同时令其移速和攻速减慢",
            colour.hex(colour.indianred, "对敌伤害：" .. dmg),
            colour.hex(colour.indianred, "移动减速：" .. move),
            colour.hex(colour.indianred, "攻击减速：" .. deAtkSpd .. '%'),
            colour.hex(colour.lawngreen, "攻击加速：" .. atkSpd .. '%'),
            colour.hex(colour.skyblue, "持续时间：3秒"),
            colour.hex(colour.yellow, "在白雾天气里，有30%几率发动失败")
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Be.BeforeAttack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local d = math.trunc(0.3 + lv * 0.05, 2)
            local dmg
            local bu = obj:prop("bindUnit")
            if (isClass(bu, UnitClass)) then
                dmg = math.floor(bu:move()) * d
            else
                dmg = "移动x" .. d
            end
            local move = 150
            local deAtkSpd = 50
            local atkSpd = 18 + lv * 2
            return {
                "当即将被攻击时跳到攻击者背后进行快速攻击",
                "眩晕0.3秒同时令其移速和攻速减慢",
                colour.hex(colour.indianred, "对敌伤害：" .. dmg),
                colour.hex(colour.indianred, "移动减速：" .. move),
                colour.hex(colour.indianred, "攻击减速：" .. deAtkSpd .. '%'),
                colour.hex(colour.lawngreen, "攻击加速：" .. atkSpd .. '%'),
                colour.hex(colour.skyblue, "持续时间：3秒"),
                colour.hex(colour.yellow, "在白雾天气里，有30%几率发动失败")
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Be.BeforeAttack, this:id(), function(beBeforeAttackData)
            this:effective({ targetUnit = beBeforeAttackData.sourceUnit })
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        if (Game():isWeather("fogWhite")) then
            if (math.rand(1, 100) <= 50) then
                async.call(u:owner(), function()
                    UI_NinegridsInfo:info("alert", 2, "失误了")
                end)
                return
            end
        end
        local tu = effectiveData.targetUnit
        local lv = effectiveData.triggerAbility:level()
        local d = math.trunc(0.3 + lv * 0.05, 2)
        local dmg = math.floor(u:move()) * d
        local move = 150
        local deAtkSpd = 50
        local atkSpd = 18 + lv * 2
        local tFac = tu:facing()
        local x, y = vector2.polar(tu:x(), tu:y(), 50, 180 + tFac)
        ability.stun({
            sourceUnit = u,
            targetUnit = tu,
            duration = 0.3,
        })
        ability.damage({
            sourceUnit = u,
            targetUnit = tu,
            damageSrc = DAMAGE_SRC.ability,
            damageType = DAMAGE_TYPE.common,
            damageTypeLevel = 1,
            damage = dmg,
        })
        tu:buff("背刺")
          :signal(BUFF_SIGNAL.down)
          :icon("ability/RogueSurpriseAttack")
          :description({ colour.hex(colour.indianred, "移动：-" .. move), colour.hex(colour.indianred, "攻速：-" .. deAtkSpd .. '%') })
          :duration(5)
          :purpose(function(buffObj)
            buffObj:attackSpeed("-=" .. deAtkSpd)
            buffObj:move("-=" .. move)
        end)
          :rollback(function(buffObj)
            buffObj:move("+=" .. move)
            buffObj:attackSpeed("+=" .. deAtkSpd)
        end)
          :run()
        u:animate("spell")
        time.setTimeout(0.1, function()
            u:position(x, y)
            u:facing(tFac)
            u:effect("eff/DreadAwe")
            u:orderAttackTargetUnit(tu)
            u:buff("背刺")
             :signal(BUFF_SIGNAL.up)
             :icon("ability/RogueSurpriseAttack")
             :description({ colour.hex(colour.lawngreen, "攻速：+" .. atkSpd .. '%') })
             :duration(5)
             :purpose(function(buffObj) buffObj:attackSpeed("+=" .. atkSpd) end)
             :rollback(function(buffObj) buffObj:attackSpeed("-=" .. atkSpd) end)
             :run()
        end)
    end)