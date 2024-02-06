TPL_ABILITY_SOUL[36] = AbilityTpl()
    :name("焱至庇护")
    :targetType(ABILITY_TARGET_TYPE.pas)
    :icon("ability/CrazyFireball")
    :coolDownAdv(15, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local def = 15 + lv * 5
        local dmg = 70 + lv * 40
        return {
            "身上环绕3个火球保护自身，当移动时",
            "火球会对附近500半径范围敌人投掷攻击",
            "如果没有敌人木飙，冷却会变为3秒",
            colour.hex(colour.lawngreen, "防御提升：" .. def),
            colour.hex(colour.lawngreen, "火球伤害：" .. dmg),
        }
    end)
    :onEvent(EVENT.Ability.Get,
    function(abData)
        local u = abData.triggerUnit
        local ab = abData.triggerAbility
        local lv = ab:level()
        local def = 15 + lv * 5
        u:defend("+=" .. def)
        u:attach("buff/ThreeFireballs", "origin")
    end)
    :onEvent(EVENT.Ability.Lose,
    function(abData)
        local u = abData.triggerUnit
        local ab = abData.triggerAbility
        local lv = ab:level()
        local def = 15 + lv * 5
        u:defend("-=" .. def)
        u:detach("buff/ThreeFireballs", "origin")
    end)
    :onEvent(EVENT.Ability.LevelChange,
    function(levelChangeData)
        local u = levelChangeData.triggerUnit
        local diff = levelChangeData.new - levelChangeData.old
        if (isClass(u, UnitClass)) then
            local def = diff * 5
            if (def >= 0) then
                u:defend("+=" .. def)
            else
                u:defend("-=" .. -def)
            end
        end
    end)
    :onUnitEvent(EVENT.Unit.Moving, function(movingData) movingData.triggerAbility:effective() end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local g = Group():catch(UnitClass, {
            limit = 3,
            circle = { x = u:x(), y = u:y(), radius = 500 },
            filter = function(enumUnit)
                return ab:isCastTarget(enumUnit)
            end
        })
        local found = false
        if (type(g) == "table") then
            local gl = #g
            if (gl > 0) then
                found = true
                local dmg = 70 + lv * 40
                for i = 1, 3 do
                    local eu
                    if (i <= gl) then
                        eu = g[i]
                    else
                        eu = g[math.rand(1, gl)]
                    end
                    ability.missile({
                        sourceUnit = u,
                        targetUnit = eu,
                        modelAlias = "missile/Fireball",
                        scale = 1,
                        speed = 500 + i * 100,
                        height = 0,
                        shake = "rand",
                        onEnd = function(options)
                            ability.damage({
                                sourceUnit = options.sourceUnit,
                                targetUnit = options.targetUnit,
                                damage = dmg,
                                damageSrc = DAMAGE_SRC.ability,
                                damageType = DAMAGE_TYPE.fire,
                                damageTypeLevel = 1,
                            })
                        end
                    })
                end
            end
        end
        if (found == false) then
            ab:coolDownAdv(3, 0)
        else
            ab:coolDownAdv(18, 0)
        end
    end)