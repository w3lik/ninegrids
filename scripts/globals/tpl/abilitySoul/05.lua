TPL_ABILITY_SOUL[5] = AbilityTpl()
    :name("水浪逆方")
    :targetType(ABILITY_TARGET_TYPE.tag_square)
    :icon("ability/Waterjet")
    :coolDownAdv(4, 0)
    :mpCostAdv(70, 5)
    :castDistanceAdv(200, 0)
    :castWidthAdv(180, 2)
    :castHeightAdv(180, 2)
    :description(
    function(obj)
        local lv = obj:level()
        local dmg = 160 + lv * 90
        local move = 60 + lv * 5
        return {
            "海浪对范围内敌人造成水伤害",
            "冲击使得双方移动速度都会减慢",
            "受到水击的敌人会进入眩晕 3 秒",
            "自身也有10%几率进入眩晕 5 秒",
            colour.hex(colour.skyblue, "效果持续时间：5秒"),
            colour.hex(colour.indianred, "冲击伤害：" .. dmg),
            colour.hex(colour.indianred, "移动减速：" .. move),
            colour.hex(colour.yellow, "在雨天天气下，伤害提升100%")
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Crit, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local dmg = 160 + lv * 90
            local move = 60 + lv * 5
            return {
                "海浪对范围内敌人造成水伤害",
                "冲击使得双方移动速度都会减慢",
                "受到水击的敌人会进入眩晕 3 秒",
                "自身也有10%几率进入眩晕 5 秒",
                colour.hex(colour.skyblue, "效果持续时间：5秒"),
                colour.hex(colour.indianred, "冲击伤害：" .. dmg),
                colour.hex(colour.indianred, "移动减速：" .. move),
                colour.hex(colour.yellow, "在雨天天气下，伤害提升100%")
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Crit, this:id(), function(critData)
            this:effective({
                targetX = critData.targetUnit:x(),
                targetY = critData.targetUnit:y(),
            })
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local x, y = effectiveData.targetX, effectiveData.targetY
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local width = ab:castWidth()
        local height = ab:castHeight()
        local dmg = 160 + lv * 90
        local move = 60 + lv * 5
        if (Game():isWeather("rain")) then
            dmg = dmg * 2
        end
        effectiveData.triggerUnit:animate("attack slam")
        effector("NagaDeath", x, y, 20 + japi.Z(x, y), 1.5)
        local g = Group():catch(UnitClass, {
            filter = function(enumUnit) return ab:isCastTarget(enumUnit) end,
            square = { x = x, y = y, width = width, height = height },
            limit = 3,
        })
        local _buf = function(whichUnit)
            whichUnit
                :buff("水浪逆方")
                :signal(BUFF_SIGNAL.down)
                :name("水浪逆方")
                :icon("ability/Waterjet")
                :description({ colour.hex(colour.indianred, "移动：-" .. move) })
                :duration(5)
                :purpose(function(buffObj) buffObj:move("-=" .. move) end)
                :rollback(function(buffObj) buffObj:move("+=" .. move) end)
                :run()
        end
        if (#g > 0) then
            for _, eu in ipairs(g) do
                ability.damage({
                    sourceUnit = u,
                    targetUnit = eu,
                    damageSrc = DAMAGE_SRC.ability,
                    damageType = DAMAGE_TYPE.water,
                    damageTypeLevel = 2,
                    damage = dmg,
                })
                ability.stun({ sourceUnit = u, targetUnit = eu, duration = 3, odds = 100 })
                _buf(eu)
            end
        end
        ability.stun({ sourceUnit = nil, targetUnit = u, duration = 5, odds = 10 })
        _buf(u)
    end)