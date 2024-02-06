TPL_ABILITY_SOUL[29] = AbilityTpl()
    :name("急浪冲流")
    :targetType(ABILITY_TARGET_TYPE.tag_loc)
    :icon("ability/IceChopShock")
    :coolDownAdv(10, 0)
    :mpCostAdv(110, 7)
    :castDistanceAdv(800, 15)
    :castChantAdv(0.5, 0)
    :description(
    function(obj)
        local lv = obj:level()
        local speed = 600
        local n = 2 + math.ceil(lv / 4)
        local dmg = 55 + lv * 19
        local dmg2 = 180 + lv * 90
        local bu = obj:prop("bindUnit")
        if (bu) then
            if (Game():isWeather("rain")) then
                speed = speed / 2
            end
        end
        return {
            "挥砍出" .. colour.hex(colour.gold, n) .. "刀水流剑影",
            "水流剑影会对木飙造成多段水伤害",
            "且有15%几率形成冲流将木飙冲高",
            colour.hex(colour.deepskyblue, "水流剑影速度：" .. speed),
            colour.hex(colour.indianred, "水流剑影伤害：" .. dmg),
            colour.hex(colour.indianred, "冲流摔落伤害：" .. dmg2),
            colour.hex(colour.yellow, "在雨天天气下水流剑影流速减少50%"),
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local speed = 600
            local n = 2 + math.ceil(lv / 4)
            local dmg = 55 + lv * 19
            local dmg2 = 180 + lv * 90
            local bu = obj:prop("bindUnit")
            if (bu) then
                if (Game():isWeather("rain")) then
                    speed = speed / 2
                end
            end
            return {
                "当攻击击中时有20%的几率",
                "挥砍出" .. colour.hex(colour.gold, n) .. "刀水流剑影",
                "水流剑影会对木飙造成多段水伤害",
                "且有15%几率形成冲流将木飙冲高",
                colour.hex(colour.deepskyblue, "水流剑影速度：" .. speed),
                colour.hex(colour.indianred, "水流剑影伤害：" .. dmg),
                colour.hex(colour.indianred, "冲流摔落伤害：" .. dmg2),
                colour.hex(colour.yellow, "在雨天天气下水流剑影流速减少50%"),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function(attackData)
            if (math.rand(1, 10) <= 2) then
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
        local distance = ab:castDistance()
        local lv = ab:level()
        local speed = 600
        local n = 2 + math.ceil(lv / 4)
        local dmg = 55 + lv * 19
        local dmg2 = 180 + lv * 90
        if (Game():isWeather("rain")) then
            speed = speed / 2
        end
        local x1, y1, x2, y2 = u:x(), u:y(), effectiveData.targetX, effectiveData.targetY
        local angle = 25
        local fac0 = vector2.angle(x1, y1, x2, y2) - math.max(0, angle / 2 * (n - 1))
        local j = 0
        for i = 1, n, 1 do
            local x, y = vector2.polar(x1, y1, distance, fac0 + angle * (i - 1))
            ability.missile({
                sourceUnit = u,
                targetVec = { x, y },
                modelAlias = "slash/BladeShockwave",
                scale = 0.8,
                speed = speed,
                onMove = function(_, vec)
                    j = j + 1
                    if (j % 9 == 0) then
                        local g = Group():catch(UnitClass, {
                            circle = { x = vec[1], y = vec[2], radius = 110 },
                            limit = 3,
                            filter = function(enumUnit) return ab:isCastTarget(enumUnit) end
                        })
                        if (#g > 0) then
                            for _, eu in ipairs(g) do
                                eu:effect("CrushingWaveDamage", 1)
                                ability.damage({
                                    sourceUnit = u,
                                    targetUnit = eu,
                                    damage = dmg,
                                    damageSrc = DAMAGE_SRC.ability,
                                    damageType = DAMAGE_TYPE.water,
                                    damageTypeLevel = 0,
                                })
                                if (math.rand(1, 100) <= 15 and false == eu:buffHas("水流剑影冲流")) then
                                    ability.crackFly({
                                        name = "水流剑影冲流",
                                        icon = "ability/IceChopShock",
                                        description = "被水流冲上天了",
                                        sourceUnit = u,
                                        targetUnit = eu,
                                        effect = "buff/WaterHands",
                                        attach = "chest",
                                        distance = 50,
                                        height = math.rand(100, 200),
                                        duration = 2,
                                        onEnd = function(options)
                                            ability.damage({
                                                sourceUnit = options.sourceUnit,
                                                targetUnit = options.targetUnit,
                                                damage = dmg2,
                                                damageSrc = DAMAGE_SRC.ability,
                                                damageType = DAMAGE_TYPE.water,
                                                damageTypeLevel = 2,
                                            })
                                        end
                                    })
                                end
                            end
                        end
                    end
                end,
            })
        end
    end)