TPL_ABILITY_SOUL[25] = AbilityTpl()
    :name("七重龙神波")
    :targetType(ABILITY_TARGET_TYPE.tag_circle)
    :icon("ability/BlueThreeFire")
    :coolDownAdv(13, 0)
    :mpCostAdv(70, 5)
    :castKeepAdv(7, 0)
    :castRadiusAdv(250, 10)
    :keepAnimation("attack slam")
    :description(
    function(obj)
        local lv = obj:level()
        local radius = obj:castRadius()
        local n = 3 + lv
        local d = math.trunc(0.33 + lv * 0.09, 2)
        local dmg
        local bu = obj:prop("bindUnit")
        if (isClass(bu, UnitClass)) then
            dmg = math.floor(bu:attack()) * d
        else
            dmg = "攻击x" .. d
        end
        return {
            "每秒对" .. colour.hex(colour.gold, radius) .. "半径范围发动雷光波，最多 7 次",
            colour.hex(colour.gold, n) .. "个雷光波飞向范围内随机位置进行100范围爆破",
            colour.hex(colour.indianred, "爆破雷伤害：" .. dmg),
            colour.hex(colour.yellow, "在雷暴天气下，雷光波数量增加3"),
            colour.hex(colour.yellow, "在烈日天气下，雷光波转变为昊日波造成光伤害"),
        }
    end)
    :pasConvBack(
    function(this)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil)
    end)
    :pasConvTo(
    function(this)
        this:prop("description", function(obj)
            local lv = obj:level()
            local radius = obj:castRadius()
            local n = 3 + lv
            local d = math.trunc(0.33 + lv * 0.09, 2)
            local dmg
            local bu = obj:prop("bindUnit")
            if (isClass(bu, UnitClass)) then
                dmg = math.floor(bu:attack()) * d
            else
                dmg = "攻击x" .. d
            end
            return {
                "当攻击击中时有20%的几率在中点位置",
                "每秒对" .. colour.hex(colour.gold, radius) .. "半径范围发动雷光波，最多 7 次",
                colour.hex(colour.gold, n) .. "个雷光波飞向范围内随机位置进行100范围爆破",
                colour.hex(colour.indianred, "爆破雷伤害：" .. dmg),
                colour.hex(colour.yellow, "在雷暴天气下，雷光波数量增加3"),
                colour.hex(colour.yellow, "在烈日天气下，雷光波转变为昊日波造成光伤害"),
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function(attackData)
            if (math.rand(1, 100) <= 20) then
                local u = attackData.triggerUnit
                local tu = attackData.targetUnit
                local ux, uy = u:x(), u:y()
                local tx, ty = tu:x(), tu:y()
                local d = vector2.distance(ux, uy, tx, ty)
                local ang = vector2.angle(ux, uy, tx, ty)
                local x, y = vector2.polar(ux, uy, d / 2, ang)
                this:effective({
                    targetX = x,
                    targetY = y,
                    targetZ = japi.Z(x, y),
                })
            end
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local x, y = u:x(), u:y()
        local x2, y2 = effectiveData.targetX, effectiveData.targetY
        local afac = vector2.angle(x2, y2, x, y)
        local radius = ab:castRadius()
        local n = 3 + lv
        if (Game():isWeather("rainStorm")) then
            n = n + 3
        end
        local d = math.trunc(0.33 + lv * 0.09, 2)
        local dmg = math.floor(u:attack()) * d
        local i = 0
        time.setInterval(0.3, function(curTimer)
            i = i + 1
            if (i > 7 or u:isAbilityKeepCasting() == false) then
                destroy(curTimer)
                return
            end
            curTimer:period(1)
            for _ = 1, n, 1 do
                local sx, sy = vector2.polar(x, y, math.rand(50, 150), afac + math.rand(-75, 75))
                local tx, ty = vector2.polar(x2, y2, math.rand(0, radius), math.rand(0, 359))
                local modelAlias = "missile/Spirit_Orb"
                local eff = "eff/RotatingThunderstorm"
                local dt = DAMAGE_TYPE.thunder
                if (Game():isWeather("sun")) then
                    modelAlias = "missile/PlasmaCannon"
                    eff = "eff/CharmSeal"
                    dt = DAMAGE_TYPE.light
                end
                ability.missile({
                    modelAlias = modelAlias,
                    sourceUnit = u,
                    sourceVec = { sx, sy, 200 },
                    targetVec = { tx, ty, 100 },
                    speed = 800,
                    acceleration = 3,
                    height = 0,
                    onEnd = function(opt, vec)
                        effector(eff, vec[1], vec[2], 20, 1)
                        local g = Group():catch(UnitClass, {
                            filter = function(enumUnit) return ab:isCastTarget(enumUnit)
                            end,
                            circle = { x = vec[1], y = vec[2], radius = 200 },
                            limit = 10,
                        })
                        if (#g > 0) then
                            for _, eu in ipairs(g) do
                                ability.damage({
                                    sourceUnit = opt.sourceUnit,
                                    targetUnit = eu,
                                    damage = dmg,
                                    damageSrc = DAMAGE_SRC.ability,
                                    damageType = dt,
                                    damageTypeLevel = 0,
                                })
                            end
                        end
                    end
                })
            end
        end)
    end)