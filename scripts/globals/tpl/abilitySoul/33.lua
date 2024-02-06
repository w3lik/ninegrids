TPL_ABILITY_SOUL[33] = AbilityTpl()
    :name("黑弧月")
    :targetType(ABILITY_TARGET_TYPE.tag_loc)
    :icon("ability/SpellMageArcaneorb")
    :coolDownAdv(9, 0)
    :hpCostAdv(250, 25)
    :mpCostAdv(250, 25)
    :castDistanceAdv(1000, 0)
    :castChantAdv(1, 0)
    :castChantEffect("buff/EmberPurple")
    :description(
    function(obj)
        local lv = obj:level()
        local dmg = 55 + lv * 17
        local hurtIncrease = 8 + lv * 2
        return {
            "以缠月至力缠出月牙剑气如爪弧一般崩坏木飙",
            "黑弧月会对木飙造成多段暗伤害",
            "且有20%几率崩坏木飙增加其受的伤害2秒",
            colour.hex(colour.indianred, "黑弧月缠伤害：" .. dmg),
            colour.hex(colour.indianred, "崩坏受伤加深：" .. hurtIncrease .. '%'),
            colour.hex(colour.yellow, "在幽月天气下崩坏几率提高15%"),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local dmg = 55 + lv * 17
            local hurtIncrease = 8 + lv * 2
            return {
                "当准备攻击木飙时有75%的几率",
                "以缠月至力缠出月牙剑气如爪弧一般崩坏木飙",
                "黑弧月会对木飙造成多段暗伤害",
                "且有20%几率崩坏木飙增加其受的伤害2秒",
                colour.hex(colour.indianred, "黑弧月缠伤害：" .. dmg),
                colour.hex(colour.indianred, "崩坏受伤加深：" .. hurtIncrease .. '%'),
                colour.hex(colour.yellow, "在幽月天气下崩坏几率提高15%"),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function(attackData)
            if (math.rand(1, 100) <= 75) then
                local tu = attackData.targetUnit
                this:effective({
                    targetX = tu:x(),
                    targetY = tu:y(),
                    targetZ = tu:z(),
                })
            end
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local distance = ab:castDistance()
        local dmg = 55 + lv * 17
        local hurtIncrease = 8 + lv * 2
        local x1, y1, x2, y2 = u:x(), u:y(), effectiveData.targetX, effectiveData.targetY
        local x, y = vector2.polar(x1, y1, distance, vector2.angle(x1, y1, x2, y2))
        local j = 0
        ability.missile({
            sourceUnit = u,
            targetVec = { x, y },
            modelAlias = "slash/Black_flame_sword",
            scale = 1,
            speed = 1000,
            onMove = function(_, vec)
                j = j + 1
                if (j % 8 == 0) then
                    local g = Group():catch(UnitClass, {
                        circle = { x = vec[1], y = vec[2], radius = 130 },
                        limit = 4,
                        filter = function(enumUnit) return ab:isCastTarget(enumUnit)
                        end
                    })
                    if (#g > 0) then
                        for _, eu in ipairs(g) do
                            ability.damage({
                                sourceUnit = u,
                                targetUnit = eu,
                                damage = dmg,
                                damageSrc = DAMAGE_SRC.ability,
                                damageType = DAMAGE_TYPE.dark,
                                damageTypeLevel = 0,
                            })
                            local odds = 20
                            if (Game():isWeather("moon")) then
                                odds = odds + 15
                            end
                            if (math.rand(1, 100) <= odds) then
                                effector("slash/Ephemeral_Slash_Purple", eu:x(), eu:y(), eu:h() + 20, 1)
                                eu:buff("黑弧月崩")
                                  :icon("ability/SpellMageArcaneorb")
                                  :description(attribute.format("hurtIncrease", hurtIncrease))
                                  :duration(2)
                                  :purpose(function(buffObj)
                                    buffObj:attach("buff/ArmorPenetrationPurple", "overhead")
                                    buffObj:hurtIncrease("+=" .. hurtIncrease)
                                end)
                                  :rollback(function(buffObj)
                                    buffObj:detach("buff/ArmorPenetrationPurple", "overhead")
                                    buffObj:hurtIncrease("-=" .. hurtIncrease)
                                end)
                                  :run()
                            end
                        end
                    end
                end
            end,
        })
    end)