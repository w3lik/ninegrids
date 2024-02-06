TPL_ABILITY_SOUL[11] = AbilityTpl()
    :name("钢火双重炮")
    :targetType(ABILITY_TARGET_TYPE.tag_square)
    :icon("ability/MiscMissileLargeRed")
    :coolDownAdv(25, 0)
    :mpCostAdv(160, 10)
    :castKeepAdv(3, 0)
    :castDistanceAdv(800, 0)
    :castWidthAdv(500, 20)
    :castHeightAdv(500, 20)
    :description(
    function(this)
        local lv = this:level()
        local limit = 9 + lv
        local dmg = 200 + 140 * lv
        return {
            "对范围内随机点发射最多" .. colour.hex(colour.gold, limit) .. "发制导轰击",
            "发出弹药随机分为" .. colour.hex(colour.gold, "钢、火属性的2种") .. "炮弹",
            "每一发都将造成" .. colour.hex(colour.indianred, dmg) .. "小范围伤害",
            "在雨天里造成伤害减少50%",
        }
    end)
    :pasConvBack(function(this) this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), nil) end)
    :pasConvTo(
    function(this)
        this:prop("description", function()
            local lv = this:level()
            local limit = 9 + lv
            local dmg = 200 + 140 * lv
            return {
                "当攻击击中时对攻击位置附近范围随机点",
                "发射最多" .. colour.hex(colour.gold, limit) .. "发制导轰击",
                "发出弹药随机分为" .. colour.hex(colour.gold, "钢、火属性的2种") .. "炮弹",
                "每一发都将造成" .. colour.hex(colour.indianred, dmg) .. "小范围伤害",
                "在雨天里造成伤害减少50%",
            }
        end)
        this:bindUnit():onEvent(EVENT.Unit.Attack, this:id(), function(attackData)
            this:effective({
                targetX = attackData.targetUnit:x(),
                targetY = attackData.targetUnit:y(),
                targetZ = attackData.targetUnit:z(),
            })
        end)
    end)
    :onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        local u = effectiveData.triggerUnit
        local ab = effectiveData.triggerAbility
        local lv = ab:level()
        local x, y = u:x(), u:y()
        local tx, ty = effectiveData.targetX, effectiveData.targetY
        local castKeep = effectiveData.triggerAbility:castKeep()
        local w = effectiveData.triggerAbility:castWidth()
        local limit = 9 + lv
        local frq = castKeep / limit
        local fires = {}
        u:attach("buff/MechanicGears", "overhead")
        time.setInterval(frq, function(curTimer)
            if (#fires >= limit or u:isDead() or false == u:isAbilityKeepCasting()) then
                destroy(curTimer)
                u:detach("buff/MechanicGears", "overhead")
                return
            end
            local r = math.rand(1, 2)
            if (r == 1) then
                effector("eff/RocketUp", x, y, 80, 1)
                table.insert(fires, DAMAGE_TYPE.steel)
            else
                Effect("eff/RocketRainUp", x, y, 80, 1):speed(2)
                table.insert(fires, DAMAGE_TYPE.fire)
            end
        end)
        time.setTimeout(castKeep + 0.5, function()
            if (#fires > 0) then
                local dmg = 200 + 140 * lv
                for i, f in ipairs(fires) do
                    time.setTimeout(0.1 * (i - 1), function()
                        local ex, ey = math.square(tx, ty, w, w)
                        if (f == DAMAGE_TYPE.steel) then
                            effector("eff/RocketDown", ex, ey, 0, 1)
                        else
                            Effect("eff/RocketRainDown", ex, ey, 0, 1):speed(2)
                        end
                        time.setTimeout(0.5, function()
                            local g = Group():catch(UnitClass, {
                                filter = function(enumUnit) return ab:isCastTarget(enumUnit) end,
                                circle = { x = ex, y = ey, radius = 150 },
                                limit = 3,
                            })
                            local remain = limit
                            if (type(g) == "table") then
                                local gl = #g
                                if (gl > 0) then
                                    for j = 1, limit do
                                        if (j <= gl) then
                                            local eu = g[j]
                                            if (f == DAMAGE_TYPE.steel) then
                                                eu:effect("eff/NewGroundEX", 2):speed(2):size(0.6)
                                            end
                                            ability.damage({
                                                sourceUnit = u,
                                                targetUnit = eu,
                                                damage = dmg,
                                                damageSrc = DAMAGE_SRC.ability,
                                                damageType = f,
                                                damageTypeLevel = 3,
                                            })
                                            remain = remain - 1
                                        end
                                    end
                                end
                            end
                            if (remain > 0) then
                                for _ = 1, remain do
                                    if (f == DAMAGE_TYPE.steel) then
                                        Effect("eff/NewGroundEX", ex, ey, 0, 2):speed(2):size(0.6)
                                    end
                                end
                            end
                        end)
                    end)
                end
            end
        end)
    end)