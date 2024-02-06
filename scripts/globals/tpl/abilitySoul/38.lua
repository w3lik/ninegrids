TPL_ABILITY_SOUL[38] = AbilityTpl()
    :name("灭却")
    :targetType(ABILITY_TARGET_TYPE.tag_unit)
    :icon("ability/Destroyredlightning3")
    :coolDownAdv(35, 1)
    :mpCostAdv(200, 15)
    :castDistanceAdv(700, 0)
    :castRadiusAdv(50, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local dmg = 160 + lv * 70
        return {
            "对木飙造成恐怖的暗雷2次属性伤害",
            "同时移除所有正面持续效果",
            colour.hex(colour.indianred, "暗伤害：" .. dmg),
            colour.hex(colour.indianred, "雷伤害：" .. dmg),
            colour.hex(colour.yellow, "在烈日天气下伤害减少30%")
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Crit, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local dmg = 160 + lv * 70
            return {
                "当暴击时对木飙造成恐怖的暗雷2次属性伤害",
                "同时移除所有正面持续效果",
                colour.hex(colour.indianred, "暗伤害：" .. dmg),
                colour.hex(colour.indianred, "雷伤害：" .. dmg),
                colour.hex(colour.yellow, "在烈日天气下伤害减少30%")
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Crit, this:id(), function(critData)
            this:effective({ targetUnit = critData.targetUnit })
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local tu = effectiveData.targetUnit
        local lv = effectiveData.triggerAbility:level()
        local dmg = 160 + lv * 70
        if (Game():isWeather("sun")) then
            dmg = dmg * 0.7
        end
        tu:effect("eff/LightingBlack", 1.2)
        ability.damage({
            sourceUnit = u,
            targetUnit = tu,
            damageSrc = DAMAGE_SRC.ability,
            damageType = DAMAGE_TYPE.dark,
            damageTypeLevel = 3,
            damage = dmg,
        })
        ability.damage({
            sourceUnit = u,
            targetUnit = tu,
            damageSrc = DAMAGE_SRC.ability,
            damageType = DAMAGE_TYPE.thunder,
            damageTypeLevel = 3,
            damage = dmg,
        })
        local bs = tu:buffCatch({
            signal = BUFF_SIGNAL.up,
            filter = function(enumBuff) return enumBuff:duration() > 0 end,
        })
        if (#bs > 0) then
            for _, b in ipairs(bs) do
                b:back()
            end
        end
    end)