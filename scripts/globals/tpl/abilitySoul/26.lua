TPL_ABILITY_SOUL[26] = AbilityTpl()
    :name("绝死镰刀")
    :targetType(ABILITY_TARGET_TYPE.tag_unit)
    :icon("ability/AGodOfDeathSickle")
    :coolDownAdv(30, 1)
    :mpCostAdv(250, 10)
    :castDistanceAdv(800, 0)
    :castRadiusAdv(50, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local dmg = 360 + lv * 150
        local hpRegen = 10 + lv * 2
        local avoid = 20 + lv * 5
        local dur = 15
        return {
            "瞬间向木飙砍出无视防御的死神镰刀",
            "对木飙造成巨大的伤害并且死念缠身",
            "缠身下木飙随意1个技能会进入冷却",
            "且冷却时间延迟20%，HP恢复、回避也会减低",
            colour.hex(colour.indianred, "镰刀暗伤害：" .. dmg),
            colour.hex(colour.indianred, "HP恢复降低：" .. hpRegen),
            colour.hex(colour.indianred, "回避降低：" .. avoid .. '%'),
            colour.hex(colour.violet, "缠身持续时间：" .. dur .. "秒"),
            colour.hex(colour.yellow, "在烈日天气下有20%几率不发生死念缠身")
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Crit, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local dmg = 360 + lv * 150
            local hpRegen = 17 + lv * 4
            local avoid = 20 + lv * 5
            local dur = 15
            return {
                "当暴击时瞬间向木飙砍出无视防御的死神镰刀",
                "对木飙造成巨大的伤害并且死念缠身",
                "缠身下木飙随意1个技能会进入冷却",
                "且冷却时间延迟20%，HP恢复、回避也会减低",
                colour.hex(colour.indianred, "镰刀暗伤害：" .. dmg),
                colour.hex(colour.indianred, "HP恢复降低：" .. hpRegen),
                colour.hex(colour.indianred, "回避降低：" .. avoid .. '%'),
                colour.hex(colour.violet, "缠身持续时间：" .. dur .. "秒"),
                colour.hex(colour.yellow, "在烈日天气下有20%几率不发生死念缠身")
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
        local dmg = 360 + lv * 150
        local hpRegen = 17 + lv * 4
        local avoid = 20 + lv * 5
        local dur = 15
        tu:attach("eff/ReaperJudgment", "chest", 0.5)
        time.setTimeout(1.0, function()
            tu:effect("slash/Black_sneaky", 0.5)
            ability.damage({
                sourceUnit = u,
                targetUnit = tu,
                damage = dmg,
                damageSrc = DAMAGE_SRC.ability,
                damageType = DAMAGE_TYPE.dark,
                damageTypeLevel = 2,
            })
            local isDeBuff = true
            if (Game():isWeather("sun")) then
                if (math.rand(1, 100) <= 20) then
                    isDeBuff = false
                end
            end
            if (isDeBuff) then
                tu:buff("死念缠身")
                  :signal(BUFF_SIGNAL.down)
                  :icon("ability/AGodOfDeathSickle")
                  :description({
                    colour.hex(colour.indianred, "冷却延长：10%"),
                    colour.hex(colour.indianred, "HP恢复：-" .. hpRegen),
                    colour.hex(colour.indianred, "回避：+" .. avoid .. '%')
                })
                  :duration(dur)
                  :purpose(function(buffObj)
                    buffObj:attach("buff/DarkCurse", "overhead")
                    buffObj:coolDownPercent("+=10")
                    buffObj:hpRegen("-=" .. hpRegen)
                    buffObj:avoid("-=" .. avoid)
                end)
                  :rollback(function(buffObj)
                    buffObj:detach("buff/DarkCurse", "overhead")
                    buffObj:coolDownPercent("-=10")
                    buffObj:hpRegen("+=" .. hpRegen)
                    buffObj:avoid("+=" .. avoid)
                end)
                  :run()
                local as = tu:abilitySlot()
                if (isClass(as, AbilitySlotClass)) then
                    local ss = as:storage()
                    local abs = {}
                    for i = 1, (Game():GD().abilityTail + 1), 1 do
                        local a = ss[i]
                        abs[#abs + 1] = a
                    end
                    if (#abs > 0) then
                        local abr = table.rand(abs, 1)
                        abr:coolingEnter()
                    end
                    abs = nil
                end
            end
        end)
    end)